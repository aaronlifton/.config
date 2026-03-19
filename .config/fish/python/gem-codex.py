#!/usr/bin/env python3

import argparse
import re
import subprocess
import sys
import shlex
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run `codex exec` from the Ruby gem source directory."
    )
    parser.add_argument("gem_name", help="Gem name to inspect with `gem info`.")
    parser.add_argument(
        "--ask",
        required=True,
        help="Question or prompt to pass to `codex exec`.",
    )
    parser.add_argument(
        "--codex-bin",
        default="codex",
        help="Codex executable to run (default: codex).",
    )
    return parser.parse_args()


def gem_info(gem_name: str) -> str:
    result = subprocess.run(
        ["gem", "info", gem_name],
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        stderr = result.stderr.strip() or result.stdout.strip()
        raise RuntimeError(f"`gem info {gem_name}` failed: {stderr}")
    return result.stdout


def parse_install_dir(info_output: str, gem_name: str) -> Path:
    match = re.search(r"^\s*Installed at:\s*(.+?)\s*$", info_output, re.MULTILINE)
    if not match:
        raise RuntimeError(
            f"Could not find 'Installed at:' in `gem info {gem_name}` output."
        )

    install_dir = Path(match.group(1)).expanduser()
    if not install_dir.exists():
        raise RuntimeError(f"Install directory does not exist: {install_dir}")
    return install_dir


def parse_gem_version(info_output: str, gem_name: str) -> str | None:
    pattern = rf"^\s*{re.escape(gem_name)}\s+\(([^)]+)\)\s*$"
    match = re.search(pattern, info_output, re.MULTILINE)
    if not match:
        return None

    versions_raw = match.group(1).strip()
    if not versions_raw:
        return None

    versions = [v.strip() for v in versions_raw.split(",") if v.strip()]
    if not versions:
        return None

    # `gem info` lists newest first.
    return versions[0]


def resolve_gem_dir(install_dir: Path, gem_name: str, version: str | None) -> Path:
    gems_dir = install_dir / "gems"
    if not gems_dir.is_dir():
        raise RuntimeError(f"gems directory does not exist: {gems_dir}")

    if version:
        exact = gems_dir / f"{gem_name}-{version}"
        if exact.is_dir():
            return exact

    candidates = sorted(p for p in gems_dir.glob(f"{gem_name}-*") if p.is_dir())
    if not candidates:
        raise RuntimeError(f"No installed gem directory found for: {gem_name}")

    if version:
        prefix = f"{gem_name}-{version}"
        version_matches = [p for p in candidates if p.name == prefix or p.name.startswith(f"{prefix}-")]
        if version_matches:
            return version_matches[0]

    if len(candidates) == 1:
        return candidates[0]

    raise RuntimeError(
        "Found multiple gem directories and could not choose one: "
        + ", ".join(p.name for p in candidates)
    )


def run_codex(codex_bin: str, ask: str, cwd: Path) -> int:
    command = [codex_bin, "exec", "--skip-git-repo-check", ask]
    print(f"command: {shlex.join(command)}")
    completed = subprocess.run(command, cwd=str(cwd), check=False)
    return completed.returncode


def main() -> int:
    args = parse_args()

    try:
        info_output = gem_info(args.gem_name)
        install_dir = parse_install_dir(info_output, args.gem_name)
        version = parse_gem_version(info_output, args.gem_name)
        gem_dir = resolve_gem_dir(install_dir, args.gem_name, version)
    except RuntimeError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    print(f"Gem dir: {gem_dir}")
    return run_codex(args.codex_bin, args.ask, gem_dir)


if __name__ == "__main__":
    raise SystemExit(main())
