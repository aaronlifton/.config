---
name: gh-fetch-comments
description: Fetch GitHub PR review context for the open pull request on the current branch using gh CLI, then present numbered comments and review threads so the user can choose which ones to analyze. Use when Codex needs PR feedback context without making code changes yet, especially when the user wants to review only specific comments before deciding what to fix.
---

# GitHub Fetch Comments

## Overview

Fetch the current branch PR's conversation comments, review bodies, and inline review threads, then turn them into a concise numbered menu for the user. Stop at context gathering and feedback; do not make edits or apply fixes as part of this skill.

## Workflow

1. Confirm GitHub CLI access
- Run `gh auth status`.
- If authentication fails, tell the user to run `gh auth login`, then retry.

2. Fetch the PR comment context
- Run `python3 scripts/fetch_comments.py`.
- Treat the script output as the source of truth for:
  - top-level PR conversation comments
  - review submission bodies
  - inline review threads with file and line metadata

3. Normalize the results into a numbered list
- Create one numbered item per actionable comment or thread.
- Include enough context for fast selection:
  - author
  - comment type: conversation comment, review body, or inline thread
  - file and line when present
  - resolved/outdated state for review threads
  - a short one-line summary of the concern
- Skip empty review bodies and obvious non-actionable noise unless they materially affect interpretation.
- Keep numbering stable within the response so the user can refer to comment numbers directly.

4. Let the user choose scope
- If the user has not specified which comments they want feedback on, ask them which numbered items to focus on.
- Accept selections by number, quoted text, author, or file path when the mapping is unambiguous.
- If the user already identified specific comments in their request, map those to the numbered items and continue without asking again.

5. Provide feedback only for the selected items
- Explain what each selected comment is asking for.
- State whether it appears valid, ambiguous, or likely already addressed, based on the current code and PR context.
- Describe likely fix directions or response options when helpful.
- Do not change code, stage files, open an editor, or apply a fix in this skill.

## Output Shape

- Start with a short PR header: title, number, URL.
- Then provide the numbered menu of comments.
- Then either:
  - ask which items the user wants feedback on, or
  - provide feedback for the specific items the user already selected.

## Boundaries

- Do not fix comments as part of this skill.
- Do not draft code changes unless the user later asks for implementation help.
- Do not treat all comments as actionable by default; summarize first, then let the user choose.

## Resources

- `scripts/fetch_comments.py`: fetch the open PR's conversation comments, reviews, and inline review threads as JSON.
