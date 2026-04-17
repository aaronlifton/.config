---
name: ask-claude
description: Ask Claude via local CLI and capture a reusable artifact
---

# Ask Claude (Local CLI)

Use the locally installed Claude CLI as a direct external advisor for focused questions, reviews, or second opinions.

## Usage

```bash
/ask-claude <question or task>
```

## Routing

### Preferred: Local CLI execution
Run Claude through the canonical OMX CLI command path (no MCP routing):

```bash
omx ask claude "{{ARGUMENTS}}"
```

Important: `omx ask claude ...` does **not** stream Claude's answer to stdout. The wrapper waits for the local Claude CLI to finish, writes a markdown artifact under `.omx/artifacts/`, and then prints the artifact path. After the command returns, open the artifact file and read `## Raw output` / `## Concise summary`.

Exact non-interactive Claude CLI command from `claude --help`:

```bash
claude -p "{{ARGUMENTS}}"
# equivalent: claude --print "{{ARGUMENTS}}"
```

If needed, adapt to the user's installed Claude CLI variant while keeping local execution as the default path.

Legacy compatibility entrypoints (`./scripts/ask-claude.sh`, `npm run ask:claude -- ...`) are transitional wrappers.

### Missing binary behavior
If `claude` is not found, do **not** switch to MCP.
Instead:
1. Explain that local Claude CLI is required for this skill.
2. Ask the user to install/configure Claude CLI.
3. Provide a quick verification command:

```bash
claude --version
```

## Artifact requirement
After local execution, save a markdown artifact to:

```text
.omx/artifacts/claude-<slug>-<timestamp>.md
```

The command's expected terminal output is the artifact path itself. Treat that path as the result handle, then read the file.

Minimum artifact sections:
1. Original user task
2. Final prompt sent to Claude CLI
3. Claude output (raw)
4. Concise summary
5. Action items / next steps

## Completion behavior
- Treat the emitted artifact path as the command result.
- Open the artifact immediately after the command completes.
- Summarize the `## Raw output` section for the user instead of assuming stdout already contains Claude's answer.
- If Claude exits non-zero or times out, report that from the artifact rather than saying no result was returned.

Task: {{ARGUMENTS}}
