---
name: review-pr
description: Review a GitHub pull request when the user gives a PR number or a branch name and wants review findings without first checking out the branch manually. Use for requests like "$review-pr 1234", "$review-pr story/my-branch", "review PR 1234", or "review the PR for branch foo/bar". Focus on bugs, regressions, risky assumptions, and missing test coverage; do not default to implementation unless the user asks for fixes after the review.
---

# Review PR

## Overview

Review a PR from GitHub using `gh` without mutating the current worktree. Resolve the target from either a PR number or a head branch, fetch a local review bundle, then inspect the diff and report findings in code-review style.

## Workflow

1. Confirm GitHub CLI access
- Run `gh auth status`.
- If authentication fails, tell the user to run `gh auth login`, then stop.

2. Build a review bundle
- Run `python3 scripts/fetch_pr_bundle.py <target>`.
- Treat the resulting bundle directory as the source of truth.
- Read `metadata.json` first, then `files.json`, then `diff.patch`.

3. Review the change
- Prioritize high-signal risk areas first:
  - deleted guards or validation
  - auth, permission, data-loss, and concurrency behavior
  - changes to API contracts, schema assumptions, or serialization
  - incomplete updates across call sites
  - test gaps around changed behavior
- Use the patch as the primary review surface.
- If a finding depends on broader file context, fetch only the specific file contents you need with `gh api` or `git show` against the SHAs recorded in `metadata.json`.

4. Report findings only
- Present findings first, ordered by severity.
- Include file and line references when the patch provides them.
- Keep summaries brief and secondary.
- If there are no findings, say so explicitly and mention any residual risk or verification gaps.

## Output Shape

- Start with the findings list.
- For each finding, include:
  - severity
  - file path and line when available
  - the concrete risk or regression
  - why the diff suggests that outcome
- After findings, add a short note for:
  - open questions or assumptions
  - residual risk if no findings were found

## Boundaries

- Do not check out the PR branch unless the user explicitly asks.
- Do not edit code as part of this skill.
- Do not pad the response with a long diff summary when findings exist.
- Prefer "no findings" over speculative nits.

## Resources

### scripts/fetch_pr_bundle.py

Resolve a PR from either a number or head branch, fetch metadata plus changed-file details from GitHub, and write a local bundle with:
- `metadata.json`
- `files.json`
- `diff.patch`

The script prints a compact JSON summary including the bundle directory path so follow-up inspection stays deterministic.
