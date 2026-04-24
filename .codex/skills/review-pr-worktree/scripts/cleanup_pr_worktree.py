#!/usr/bin/env python3
"""
Clean up a review-pr-worktree temporary worktree root.

Usage:
    python3 cleanup_pr_worktree.py <root_dir>
"""

from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
from pathlib import Path


def run(cmd: list[str], *, check: bool = True, cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        cmd,
        check=check,
        text=True,
        capture_output=True,
        cwd=str(cwd) if cwd else None,
    )


def load_info(root_dir: Path) -> dict:
    info_path = root_dir / "worktree-info.json"
    if not info_path.exists():
        raise SystemExit(f"Missing worktree-info.json in {root_dir}")
    return json.loads(info_path.read_text())


def remove_worktree(repo_root: Path, worktree_dir: Path) -> None:
    if not worktree_dir.exists():
        return
    result = run(
        ["git", "worktree", "remove", "--force", str(worktree_dir)],
        check=False,
        cwd=repo_root,
    )
    if result.returncode != 0:
        sys.stderr.write(result.stderr or result.stdout)
        raise SystemExit("Failed to remove Git worktree.")


def delete_local_ref(repo_root: Path, ref_name: str) -> None:
    result = run(
        ["git", "update-ref", "-d", ref_name],
        check=False,
        cwd=repo_root,
    )
    if result.returncode != 0 and "cannot lock ref" not in (result.stderr or "") and "not a valid ref" not in (result.stderr or ""):
        sys.stderr.write(result.stderr or result.stdout)
        raise SystemExit("Failed to delete temporary local ref.")


def main() -> int:
    parser = argparse.ArgumentParser(description="Clean up a PR review worktree.")
    parser.add_argument("root_dir", help="Root directory created by prepare_pr_worktree.py")
    args = parser.parse_args()

    root_dir = Path(args.root_dir).expanduser().resolve()
    info = load_info(root_dir)
    repo_root = Path(info["repo_root"]).resolve()
    worktree_dir = Path(info["worktree_dir"]).resolve()
    ref_name = info["local_ref"]

    remove_worktree(repo_root, worktree_dir)
    delete_local_ref(repo_root, ref_name)

    if root_dir.exists():
        shutil.rmtree(root_dir)

    sys.stdout.write(
        json.dumps(
            {
                "success": True,
                "removed_root_dir": str(root_dir),
                "removed_worktree_dir": str(worktree_dir),
                "deleted_local_ref": ref_name,
            },
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
