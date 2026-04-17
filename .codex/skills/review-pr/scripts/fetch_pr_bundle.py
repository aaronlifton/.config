#!/usr/bin/env python3
"""
Fetch a local PR review bundle from GitHub.

Usage:
    python3 fetch_pr_bundle.py <target>

Where <target> is either:
  - a PR number, e.g. 1234
  - a head branch name, e.g. story/my-branch
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any


def run(cmd: list[str], *, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        cmd,
        check=check,
        text=True,
        capture_output=True,
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
    return Path(
        tempfile.mkdtemp(prefix=f"review-pr-{pr_number}-", dir=str(base))
    )


def write_json(path: Path, payload: Any) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Fetch a PR review bundle from GitHub.")
    parser.add_argument("target", help="PR number or head branch name")
    parser.add_argument(
        "--output-dir",
        help="Optional output directory. Defaults to a temporary directory.",
    )
    args = parser.parse_args()

    ensure_gh_auth()
    repo = current_repo()
    pr_number = resolve_pr_number(repo, args.target)
    pr = fetch_pr(repo, pr_number)
    files = fetch_files(repo, pr_number)
    diff = fetch_diff(pr_number)

    output_dir = Path(args.output_dir).expanduser().resolve() if args.output_dir else make_output_dir(pr_number)
    output_dir.mkdir(parents=True, exist_ok=True)

    metadata = compact_metadata(repo, pr)
    write_json(output_dir / "metadata.json", metadata)
    write_json(output_dir / "files.json", files)
    (output_dir / "diff.patch").write_text(diff)

    summary = {
        "bundle_dir": str(output_dir),
        "repo": repo,
        "number": metadata["number"],
        "title": metadata["title"],
        "url": metadata["url"],
        "head_ref": metadata["head"]["ref"],
        "base_ref": metadata["base"]["ref"],
        "changed_files": metadata["changed_files"],
        "additions": metadata["additions"],
        "deletions": metadata["deletions"],
    }
    sys.stdout.write(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
