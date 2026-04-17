#!/usr/bin/env python3
"""Append newly announced Homebrew casks to a Markdown digest."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from collections import OrderedDict
from datetime import date
from pathlib import Path

DEFAULT_DOC = Path.home() / "Documents" / "homebrew-new-casks.md"
NEW_CASKS_HEADER = "==> New Casks"
TOKEN_RE = re.compile(r"^[a-z0-9@+._-]+$")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Parse Homebrew new-cask output, enrich it with brew metadata, "
            "and append a dated Markdown digest."
        )
    )
    parser.add_argument(
        "casks",
        nargs="*",
        help="Explicit cask tokens to document instead of parsing brew update output.",
    )
    parser.add_argument(
        "--doc",
        default=os.environ.get("HOMEBREW_NEW_CASKS_DOC", str(DEFAULT_DOC)),
        help="Markdown file to append to. Defaults to ~/Documents/homebrew-new-casks.md.",
    )
    parser.add_argument(
        "--input-file",
        help="Read pasted brew update output from a file instead of stdin.",
    )
    parser.add_argument(
        "--run-update",
        action="store_true",
        help="Run `brew update --quiet` and parse its output for a New Casks section.",
    )
    parser.add_argument(
        "--no-analytics",
        action="store_true",
        help="Skip Homebrew analytics lookup.",
    )
    parser.add_argument(
        "--allow-duplicates",
        action="store_true",
        help="Append casks even if the token already exists in the destination doc.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print the Markdown section instead of appending it.",
    )
    return parser.parse_args()


def run_command(args: list[str]) -> str:
    completed = subprocess.run(
        args,
        check=True,
        capture_output=True,
        text=True,
    )
    return completed.stdout


def run_command_combined(args: list[str]) -> str:
    completed = subprocess.run(
        args,
        check=True,
        capture_output=True,
        text=True,
    )
    return (completed.stdout or "") + (completed.stderr or "")


def get_source_text(args: argparse.Namespace) -> tuple[str | None, str]:
    if args.casks:
        return None, "explicit cask arguments"
    if args.input_file:
        return (
            Path(args.input_file).read_text(encoding="utf-8"),
            f"input file `{args.input_file}`",
        )
    if not sys.stdin.isatty():
        stdin_text = sys.stdin.read()
        if stdin_text.strip():
            return stdin_text, "stdin"
    return run_command_combined(["brew", "update", "--quiet"]), "`brew update --quiet`"


def parse_candidate_line(line: str) -> tuple[str, str] | None:
    token_part, separator, desc_part = line.partition(":")
    token = token_part.strip().lower()
    desc = desc_part.strip() if separator else ""
    if not TOKEN_RE.match(token):
        return None
    return token, desc


def parse_new_casks(text: str) -> OrderedDict[str, str]:
    tokens: OrderedDict[str, str] = OrderedDict()
    in_section = False

    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line or line == "```":
            if in_section and tokens:
                break
            continue

        if line == NEW_CASKS_HEADER:
            in_section = True
            continue

        if not in_section:
            continue

        if line.startswith("==> "):
            break

        candidate = parse_candidate_line(line)
        if not candidate:
            break
        token, desc = candidate
        tokens.setdefault(token, desc)

    if tokens:
        return tokens

    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line or line == "```" or line.startswith("==> "):
            continue
        candidate = parse_candidate_line(line)
        if not candidate:
            continue
        token, desc = candidate
        tokens.setdefault(token, desc)

    return tokens


def unique_tokens(raw_tokens: list[str]) -> list[str]:
    ordered = OrderedDict()
    for token in raw_tokens:
        normalized = token.strip().lower()
        if normalized and TOKEN_RE.match(normalized):
            ordered.setdefault(normalized, None)
    return list(ordered.keys())


def fetch_metadata(tokens: list[str]) -> dict[str, dict]:
    try:
        payload = run_command(["brew", "info", "--json=v2", "--cask", *tokens])
        data = json.loads(payload)
        return {item["token"]: item for item in data.get("casks", [])}
    except subprocess.CalledProcessError:
        metadata: dict[str, dict] = {}
        for token in tokens:
            try:
                payload = run_command(["brew", "info", "--json=v2", "--cask", token])
            except subprocess.CalledProcessError:
                continue
            data = json.loads(payload)
            for item in data.get("casks", []):
                metadata[item["token"]] = item
        return metadata


def parse_analytics(text: str) -> dict[int, int]:
    counts: dict[int, int] = {}
    current_days: int | None = None

    for raw_line in text.splitlines():
        line = raw_line.strip()
        header_match = re.match(r"^==> install \((30|90|365) days\)$", line)
        if header_match:
            current_days = int(header_match.group(1))
            continue

        if current_days is None or "|" not in line:
            continue

        columns = [column.strip() for column in line.split("|")]
        if len(columns) < 4 or not columns[0].isdigit():
            continue

        count_text = columns[2].replace(",", "")
        if count_text.isdigit():
            counts[current_days] = int(count_text)
            current_days = None

    return counts


def fetch_analytics(token: str) -> dict[int, int] | None:
    try:
        output = run_command(["brew", "info", "--analytics", token])
    except subprocess.CalledProcessError:
        return None
    counts = parse_analytics(output)
    return counts or None


def adoption_signal(analytics: dict[int, int] | None) -> str | None:
    if not analytics or 365 not in analytics:
        return None

    installs = analytics[365]
    if installs >= 50000:
        return "Very strong adoption signal in Homebrew analytics."
    if installs >= 10000:
        return "Strong adoption signal in Homebrew analytics."
    if installs >= 1000:
        return "Solid adoption signal in Homebrew analytics."
    return "Limited adoption signal so far in Homebrew analytics."


def analytics_line(analytics: dict[int, int] | None) -> str | None:
    if not analytics:
        return None

    parts = []
    for days in (30, 90, 365):
        if days in analytics:
            parts.append(f"{days}d {analytics[days]:,} installs")
    if not parts:
        return None
    return "; ".join(parts)


def existing_tokens(doc_path: Path) -> set[str]:
    if not doc_path.exists():
        return set()
    content = doc_path.read_text(encoding="utf-8")
    return set(re.findall(r"^### `([^`]+)`$", content, re.MULTILINE))


def ensure_doc_header(doc_path: Path) -> None:
    if doc_path.exists():
        return
    doc_path.parent.mkdir(parents=True, exist_ok=True)
    header = (
        "# Homebrew New Casks\n\n"
        "Append-only notes generated by `homebrew-new-casks`.\n"
    )
    doc_path.write_text(header, encoding="utf-8")


def format_entry(
    token: str,
    metadata: dict | None,
    parsed_desc: str,
    analytics: dict[int, int] | None,
) -> str:
    app_names = metadata.get("name") if metadata else None
    app_name = ", ".join(app_names) if app_names else token
    description = (metadata or {}).get("desc") or parsed_desc or "No description available."
    homepage = (metadata or {}).get("homepage")
    version = (metadata or {}).get("version")

    lines = [f"### `{token}`"]
    lines.append(f"- App: {app_name}")
    lines.append(f"- Description: {description}")
    if homepage:
        lines.append(f"- Homepage: {homepage}")
    if version:
        lines.append(f"- Version: `{version}`")

    analytics_summary = analytics_line(analytics)
    if analytics_summary:
        lines.append(f"- Homebrew analytics: {analytics_summary}")

    signal = adoption_signal(analytics)
    if signal:
        lines.append(f"- Adoption signal: {signal}")

    return "\n".join(lines)


def build_section(
    tokens: list[str],
    parsed_descriptions: dict[str, str],
    metadata_by_token: dict[str, dict],
    analytics_by_token: dict[str, dict[int, int] | None],
    source_label: str,
) -> str:
    section_lines = [
        f"## {date.today().isoformat()}",
        f"Source: {source_label}",
        "",
    ]

    for token in tokens:
        section_lines.append(
            format_entry(
                token,
                metadata_by_token.get(token),
                parsed_descriptions.get(token, ""),
                analytics_by_token.get(token),
            )
        )
        section_lines.append("")

    return "\n".join(section_lines).rstrip() + "\n"


def main() -> int:
    args = parse_args()
    doc_path = Path(args.doc).expanduser()
    source_text, source_label = get_source_text(args)

    if args.casks:
        parsed_descriptions: OrderedDict[str, str] = OrderedDict(
            (token, "") for token in unique_tokens(args.casks)
        )
    else:
        if not source_text:
            print("No input available to parse.", file=sys.stderr)
            return 1
        parsed_descriptions = parse_new_casks(source_text)

    tokens = list(parsed_descriptions.keys())
    if not tokens:
        print("No new casks found.")
        return 0

    known_tokens = existing_tokens(doc_path) if not args.allow_duplicates else set()
    tokens_to_append = [token for token in tokens if token not in known_tokens]
    if not tokens_to_append:
        print("All parsed casks are already present in the destination doc.")
        return 0

    metadata_by_token = fetch_metadata(tokens_to_append)
    analytics_by_token: dict[str, dict[int, int] | None] = {}
    if args.no_analytics:
        analytics_by_token = {token: None for token in tokens_to_append}
    else:
        for token in tokens_to_append:
            analytics_by_token[token] = fetch_analytics(token)

    section = build_section(
        tokens_to_append,
        parsed_descriptions,
        metadata_by_token,
        analytics_by_token,
        source_label,
    )

    if args.dry_run:
        print(section, end="")
        return 0

    ensure_doc_header(doc_path)
    with doc_path.open("a", encoding="utf-8") as handle:
        if doc_path.stat().st_size > 0:
            handle.write("\n")
        handle.write(section)

    print(
        f"Appended {len(tokens_to_append)} cask entr"
        f"{'y' if len(tokens_to_append) == 1 else 'ies'} to {doc_path}"
    )
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except FileNotFoundError as exc:
        print(f"Missing file or command: {exc}", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as exc:
        print(f"Failed to parse Homebrew JSON output: {exc}", file=sys.stderr)
        sys.exit(1)
    except subprocess.CalledProcessError as exc:
        detail = (exc.stderr or exc.stdout or str(exc)).strip()
        print(f"Command failed: {detail}", file=sys.stderr)
        sys.exit(exc.returncode or 1)
