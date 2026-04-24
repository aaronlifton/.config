---
name: review-pr-worktree
description: Review a GitHub pull request by PR number or branch using a temporary Git worktree that persists until explicit cleanup. Use when Codex or the user needs the PR's actual checked-out repository state for repo-wide search, code-intel, test runs, or direct inspection, while still focusing on review findings rather than implementation by default.
---

# Review PR Worktree

## Overview

Review a PR from GitHub using a temporary Git worktree rooted at the PR's head commit without mutating the current worktree. This skill also creates a local review bundle so the patch stays the primary review surface while the checked-out repository is available for broader context and verification.

## Workflow

1. Confirm GitHub CLI access
- Run `gh auth status`.
- If authentication fails, tell the user to run `gh auth login`, then stop.

2. Materialize the review workspace
- Run `python3 scripts/prepare_pr_worktree.py <target>`.
- Treat the resulting root directory as the source of truth.
- Read `worktree-info.json` first, then `bundle/metadata.json`, `bundle/files.json`, and `bundle/diff.patch`.
- Use `repo/` inside that root as the checked-out PR tree for search, inspection, and optional verification.

3. Review the change
- Prioritize high-signal risk areas first:
  - deleted guards or validation
  - auth, permission, data-loss, and concurrency behavior
  - changes to API contracts, schema assumptions, or serialization
  - incomplete updates across call sites
  - test gaps around changed behavior
- Use `bundle/diff.patch` as the primary review surface.
- Use the `repo/` worktree for repo-wide `rg`, symbol lookup, broader file context, and targeted verification commands.
- If you run tests or lint inside the worktree, report the exact command and result.

4. Report findings only
- Present findings first, ordered by severity.
- Include file and line references when the patch provides them.
- Keep summaries brief and secondary.
- If there are no findings, say so explicitly and mention any residual risk or verification gaps.

5. Preserve the worktree until explicit cleanup
- Do not clean up the temporary worktree automatically.
- Tell the user where the worktree lives if it matters for inspection.
- Only remove it when the user explicitly asks to clean up or remove the review worktree.
- When asked to clean up, run `python3 scripts/cleanup_pr_worktree.py <root_dir>`.

## Output Shape

- Start with the findings list.
- For each finding, include:
  - severity
  - file path and line when available
  - the concrete risk or regression
  - why the diff suggests that outcome
- After findings, add a short note for:
  - open questions or assumptions
  - verification run status if applicable
  - residual risk if no findings were found

## Boundaries

- Do not mutate the user's current worktree.
- Do not edit code as part of this skill unless the user explicitly asks for follow-up fixes.
- Do not automatically remove the temporary worktree.
- Do not pad the response with a long diff summary when findings exist.
- Prefer "no findings" over speculative nits.

## Resources

### scripts/prepare_pr_worktree.py

Resolve a PR from either a number or head branch, fetch metadata plus changed-file details from GitHub, fetch the PR head into a temporary local ref, and create a temporary worktree root with:
- `worktree-info.json`
- `bundle/metadata.json`
- `bundle/files.json`
- `bundle/diff.patch`
- `repo/`

The script prints a compact JSON summary including the root directory, worktree directory, and cleanup command.

### scripts/cleanup_pr_worktree.py

Remove a previously created review worktree root by:
- removing the Git worktree
- deleting the temporary local ref
- deleting the temporary root directory

Use this script only when the user explicitly asks for cleanup.
