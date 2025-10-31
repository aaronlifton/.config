#!/usr/bin/env python3

import json
import re
import sys
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Iterable, List, Optional


@dataclass
class DocInfo:
    filename: str
    description: str
    details: str
    short: str


def find_first_doc_block(content: str) -> (str | None):
    """
    Return the text between the first pair of triple double quotes (\"\"\") in `content`,
    or None if fewer than two occurrences are found.
    """
    # We look specifically for triple double quotes (""") not single quotes.
    # Use regex to find non-overlapping occurrences and capture between first two.
    pattern = re.compile(r'"""')
    matches = list(pattern.finditer(content))
    if len(matches) < 2:
        return None
    start = matches[0].end()
    end = matches[1].start()
    return content[start:end]


def normalize_whitespace_one_line(text: str) -> str:
    """Collapse whitespace and newlines into single spaces, trimmed."""
    return re.sub(r'\s+', ' ', text).strip()


def split_paragraphs(text: str) -> List[str]:
    """
    Split text into paragraphs (blocks separated by one or more blank lines).
    Preserve internal newlines for each paragraph trimmed of leading/trailing blank lines.
    """
    # Normalize CRLF to LF
    text = text.replace('\r\n', '\n').replace('\r', '\n')
    paragraphs = re.split(r'\n\s*\n', text.strip())
    return [p.strip() for p in paragraphs if p.strip()]


def extract_doc_info(path: Path) -> Optional[DocInfo]:
    """
    Read file at `path` and extract the first doc block between triple double quotes.
    Return DocInfo or None if no such block exists.
    """
    try:
        content = path.read_text(encoding='utf-8')
    except Exception as exc:  # wide exception to surface read errors
        print(f"Warning: cannot read {path}: {exc}", file=sys.stderr)
        return None

    block = find_first_doc_block(content)
    if block is None:
        return None

    # Normalize leading/trailing newlines
    block = block.strip('\n')
    # Split into lines and remove any leading common indentation like a docstring would have
    lines = block.splitlines()
    if not lines:
        description = ""
        details = ""
        short = ""
    else:
        # Remove uniform indentation (like textwrap.dedent)
        # Compute min indentation (excluding empty lines)
        indent_levels = [
            len(re.match(r'^[ \t]*', line).group(0))
            for line in lines
            if line.strip()
        ]
        min_indent = min(indent_levels) if indent_levels else 0
        dedented_lines = [line[min_indent:] if len(line) >= min_indent else line for line in lines]
        # First non-empty line is description
        non_empty = [ln for ln in dedented_lines if ln.strip()]
        description = non_empty[0].strip() if non_empty else ""
        # Details: everything after the first line (preserve newlines)
        if len(dedented_lines) >= 2:
            details = "\n".join(dedented_lines[1:]).strip()
        else:
            details = ""
        # Short: create one-line summary from the first paragraph
        paragraphs = split_paragraphs("\n".join(dedented_lines))
        first_para = paragraphs[0] if paragraphs else ""
        short = normalize_whitespace_one_line(first_para)

    return DocInfo(
        filename=path.name,
        description=description,
        details=details,
        short=short,
    )


def iter_py_files(directory: Path, exclude: Iterable[str] = ()) -> Iterable[Path]:
    """
    Yield Path objects for .py files in `directory` (non-recursive),
    excluding any names listed in `exclude`.
    """
    for entry in directory.iterdir():
        if not entry.is_file():
            continue
        if entry.suffix != ".py":
            continue
        if entry.name in exclude:
            continue
        yield entry


def main() -> int:
    here = Path(__file__).resolve().parent
    this_name = Path(__file__).name
    results: List[DocInfo] = []
    for p in iter_py_files(here, exclude=(this_name,)):
        info = extract_doc_info(p)
        if info is not None:
            results.append(info)

    # Print JSON array to stdout
    out = [asdict(r) for r in results]
    json.dump(out, sys.stdout, ensure_ascii=False, indent=2)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
