#!/usr/bin/env python3
"""
Prepare a persistent temporary worktree and review bundle for a GitHub PR.

Usage:
    python3 prepare_pr_worktree.py <target>

Where <target> is either:
  - a PR number, e.g. 1234
  - a head branch name, e.g. story/my-branch
"""

from __future__ import annotations

import argparse
import json
import re
import shlex
import subprocess
import sys
import tempfile
import uuid
from pathlib import Path
from typing import Any


def run(cmd: list[str], *, check: bool = True, cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        cmd,
        check=check,
        text=True,
        capture_output=True,
        cwd=str(cwd) if cwd else None,
    )


def gh_json(args: list[str]) -> Any:
    result = run(["gh", *args])
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as exc:
        raise SystemExit(
            f"Failed to parse JSON from: {' '.join(['gh', *args])}\n{exc}\n{result.stdout}"
        ) from exc


def ensure_gh_auth() -> None:
    result = run(["gh", "auth", "status"], check=False)
    if result.returncode != 0:
        sys.stderr.write(result.stderr or result.stdout)
        raise SystemExit("gh auth is required. Run `gh auth login` and retry.")


def current_repo() -> str:
    result = run(["gh", "repo", "view", "--json", "nameWithOwner"])
    data = json.loads(result.stdout)
    repo = data.get("nameWithOwner")
    if not repo:
        raise SystemExit("Unable to determine current GitHub repository.")
    return repo


def git_toplevel() -> Path:
    result = run(["git", "rev-parse", "--show-toplevel"], check=False)
    if result.returncode != 0:
        raise SystemExit("Current directory is not inside a Git repository.")
    return Path(result.stdout.strip()).resolve()


def resolve_pr_number(repo: str, target: str) -> int:
    if re.fullmatch(r"\d+", target):
        return int(target)

    prs = gh_json(
        [
            "pr",
            "list",
            "--repo",
            repo,
            "--state",
            "all",
            "--head",
            target,
            "--json",
            "number,headRefName,title,state,url",
            "--limit",
            "20",
        ]
    )
    exact_matches = [pr for pr in prs if pr.get("headRefName") == target]
    if len(exact_matches) == 1:
        return int(exact_matches[0]["number"])
    if len(exact_matches) > 1:
        lines = "\n".join(
            f"- #{pr['number']} {pr['title']} ({pr['state']}) {pr['url']}" for pr in exact_matches
        )
        raise SystemExit(f"Multiple PRs matched branch '{target}':\n{lines}")

    if prs:
        lines = "\n".join(
            f"- #{pr['number']} {pr['headRefName']} -> {pr['title']} ({pr['state']})"
            for pr in prs
        )
        raise SystemExit(
            f"No exact head branch match for '{target}'. Similar GitHub matches were:\n{lines}"
        )

    raise SystemExit(f"No pull request found for branch '{target}'.")


def fetch_pr(repo: str, pr_number: int) -> dict[str, Any]:
    return gh_json(["api", f"repos/{repo}/pulls/{pr_number}"])


def fetch_files(repo: str, pr_number: int) -> list[dict[str, Any]]:
    page = 1
    files: list[dict[str, Any]] = []
    while True:
        batch = gh_json(
            ["api", f"repos/{repo}/pulls/{pr_number}/files?per_page=100&page={page}"]
        )
        if not isinstance(batch, list):
            raise SystemExit("Unexpected GitHub API response while fetching changed files.")
        files.extend(batch)
        if len(batch) < 100:
            return files
        page += 1


def fetch_diff(pr_number: int) -> str:
    result = run(["gh", "pr", "diff", str(pr_number), "--patch"])
    return result.stdout


def compact_metadata(repo: str, pr: dict[str, Any]) -> dict[str, Any]:
    head = pr.get("head") or {}
    base = pr.get("base") or {}
    user = pr.get("user") or {}
    return {
        "repo": repo,
        "number": pr.get("number"),
        "title": pr.get("title"),
        "url": pr.get("html_url"),
        "state": pr.get("state"),
        "draft": pr.get("draft"),
        "author": user.get("login"),
        "body": pr.get("body"),
        "additions": pr.get("additions"),
        "deletions": pr.get("deletions"),
        "changed_files": pr.get("changed_files"),
        "commits": pr.get("commits"),
        "head": {
            "label": head.get("label"),
            "ref": head.get("ref"),
            "sha": head.get("sha"),
            "repo": ((head.get("repo") or {}).get("full_name")),
        },
        "base": {
            "label": base.get("label"),
            "ref": base.get("ref"),
            "sha": base.get("sha"),
            "repo": ((base.get("repo") or {}).get("full_name")),
        },
    }


def make_output_dir(pr_number: int) -> Path:
    base = Path(tempfile.gettempdir())
    return Path(tempfile.mkdtemp(prefix=f"review-pr-worktree-{pr_number}-", dir=str(base)))


def write_json(path: Path, payload: Any) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def normalize_github_remote(url: str) -> str:
    url = url.strip()
    url = re.sub(r"\.git$", "", url)
    if url.startswith("git@github.com:"):
        return url.removeprefix("git@github.com:")
    if url.startswith("https://github.com/"):
        return url.removeprefix("https://github.com/")
    if url.startswith("ssh://git@github.com/"):
        return url.removeprefix("ssh://git@github.com/")
    return url


def resolve_repo_remote(repo: str, cwd: Path) -> str:
    result = run(["git", "remote", "-v"], cwd=cwd)
    for line in result.stdout.splitlines():
        parts = line.split()
        if len(parts) < 3 or parts[2] != "(fetch)":
            continue
        remote_name, remote_url = parts[0], parts[1]
        if normalize_github_remote(remote_url) == repo:
            return remote_name
    return f"https://github.com/{repo}.git"


def local_ref_name(pr_number: int) -> str:
    return f"refs/review-pr-worktree/{pr_number}/{uuid.uuid4().hex}"


def fetch_pr_head_ref(repo_remote: str, pr_number: int, ref_name: str, cwd: Path) -> None:
    result = run(
        [
            "git",
            "fetch",
            "--no-tags",
            "--force",
            repo_remote,
            f"+refs/pull/{pr_number}/head:{ref_name}",
        ],
        check=False,
        cwd=cwd,
    )
    if result.returncode != 0:
        sys.stderr.write(result.stderr or result.stdout)
        raise SystemExit(
            "Failed to fetch PR head into a temporary local ref. "
            "The PR may be inaccessible or the remote may not expose pull refs."
        )


def create_worktree(repo_root: Path, worktree_dir: Path, ref_name: str) -> None:
    result = run(
        ["git", "worktree", "add", "--detach", str(worktree_dir), ref_name],
        check=False,
        cwd=repo_root,
    )
    if result.returncode != 0:
        sys.stderr.write(result.stderr or result.stdout)
        raise SystemExit("Failed to create temporary Git worktree.")


def main() -> int:
    parser = argparse.ArgumentParser(description="Prepare a PR review worktree.")
    parser.add_argument("target", help="PR number or head branch name")
    parser.add_argument(
        "--output-dir",
        help="Optional root output directory. Defaults to a temporary directory.",
    )
    args = parser.parse_args()

    ensure_gh_auth()
    repo = current_repo()
    repo_root = git_toplevel()
    pr_number = resolve_pr_number(repo, args.target)
    pr = fetch_pr(repo, pr_number)
    files = fetch_files(repo, pr_number)
    diff = fetch_diff(pr_number)

    root_dir = Path(args.output_dir).expanduser().resolve() if args.output_dir else make_output_dir(pr_number)
    bundle_dir = root_dir / "bundle"
    worktree_dir = root_dir / "repo"
    bundle_dir.mkdir(parents=True, exist_ok=True)

    metadata = compact_metadata(repo, pr)
    write_json(bundle_dir / "metadata.json", metadata)
    write_json(bundle_dir / "files.json", files)
    (bundle_dir / "diff.patch").write_text(diff)

    repo_remote = resolve_repo_remote(repo, repo_root)
    ref_name = local_ref_name(pr_number)
    fetch_pr_head_ref(repo_remote, pr_number, ref_name, repo_root)
    create_worktree(repo_root, worktree_dir, ref_name)

    cleanup_script = Path(__file__).resolve().parent / "cleanup_pr_worktree.py"
    info = {
        "root_dir": str(root_dir),
        "bundle_dir": str(bundle_dir),
        "worktree_dir": str(worktree_dir),
        "repo_root": str(repo_root),
        "repo_remote": repo_remote,
        "local_ref": ref_name,
        "cleanup_command": f"python3 {shlex.quote(str(cleanup_script))} {shlex.quote(str(root_dir))}",
        "repo": repo,
        "number": metadata["number"],
        "title": metadata["title"],
        "url": metadata["url"],
        "head_ref": metadata["head"]["ref"],
        "head_sha": metadata["head"]["sha"],
        "base_ref": metadata["base"]["ref"],
        "base_sha": metadata["base"]["sha"],
    }
    write_json(root_dir / "worktree-info.json", info)
    sys.stdout.write(json.dumps(info, indent=2, sort_keys=True) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
