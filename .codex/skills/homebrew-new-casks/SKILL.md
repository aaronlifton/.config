---
name: homebrew-new-casks
description: Capture newly announced Homebrew casks from `brew update` output or by running `brew update`, enrich each cask with `brew info` metadata and optional Homebrew analytics, and append a dated Markdown digest to a notes file. Use when Codex needs to document `==> New Casks` output, maintain a running Homebrew cask watchlist, summarize newly added casks, or turn pasted Homebrew update text into structured notes.
---

# Homebrew New Casks

## Overview

Use this skill to turn fresh Homebrew casks into an append-only Markdown digest. Prefer the bundled script so repeated runs stay consistent, metadata stays current, and duplicate entries are avoided by default.

## Workflow

1. Choose the input source
- If the user pasted `brew update` output, pipe it to the script or save it to a temp file and use `--input-file`.
- If the user only wants a few known casks documented, pass the cask tokens as positional arguments.
- If no update text was provided, let the script run `brew update --quiet` itself.

2. Choose the destination document
- Default to `~/Documents/homebrew-new-casks.md`.
- Override with `--doc <path>` or `HOMEBREW_NEW_CASKS_DOC=/path/to/file.md`.

3. Run the script
```bash
python3 scripts/update_cask_digest.py --run-update
python3 scripts/update_cask_digest.py --doc ~/Documents/homebrew-new-casks.md google-gemini koharu
python3 scripts/update_cask_digest.py --input-file /tmp/brew-update.txt --doc ~/Documents/homebrew-new-casks.md
pbpaste | python3 scripts/update_cask_digest.py --doc ~/Documents/homebrew-new-casks.md
```

4. Review the generated digest
- Each entry should include token, app name, description, homepage, version, and Homebrew analytics when available.
- Treat analytics as an adoption signal, not as a guaranteed recommendation.
- Use `--dry-run` first if the user wants to preview the Markdown before appending it.

## Recommendation Enrichment

Only do this extra pass if the user explicitly wants community sentiment or "is this worth trying?" context.

- Browse because recommendation signals are time-sensitive.
- Start with first-party sources such as the product homepage or source repository.
- Add a small number of recent community signals when they are easy to verify, such as GitHub stars/issues for open-source apps or recent discussion threads.
- Append a short `Community note:` line with citations instead of inventing confidence you do not have.
- If the signal is thin or mixed, say so plainly.

## Boundaries

- Do not append an empty section when there are no new casks.
- Do not duplicate a cask token already present in the target doc unless the user asks for duplicates.
- If Homebrew analytics are unavailable, continue with metadata only.
- Prefer the script over ad hoc shell parsing so the output format stays stable.

## Resource

- `scripts/update_cask_digest.py`: Parse `brew update` output, fetch `brew info` metadata, collect optional analytics, and append a dated Markdown section.
