# Repository Guidelines

## Project Structure & Module Organization
`config.fish` is the entry point and loads helper snippets from `conf.d/`. Use numeric prefixes (e.g. `conf.d/00_path.fish`) to control load order. Long-lived overrides belong in `user_variables.fish`; secrets stay in untracked `secrets.fish`. Reusable helpers live under `functions/`, mirroring upstream layouts such as `functions/fisher/` and `functions/yazi/`. Drop ad-hoc scripts in `misc-fns.fish`, custom completions in `completions/`, and themes or prompts under `themes/` and `prompt.fish`. Temporary runtime files should go under `tmp/`.

## Build, Test, and Development Commands
Validate syntax before sourcing: `fish -n config.fish` or `fish -n functions/*.fish`. Apply changes in your current session with `source ~/.config/fish/config.fish`. Install external dependencies once per machine via `functions/install-deps.fish`. Manage plugins with Fisher—`fisher update` refreshes the list pinned in `fish_plugins`, while `fisher install <repo>` adds new plugins (remember to commit the updated list).

## Coding Style & Naming Conventions
Indent with four spaces and keep a blank line between functions for readability. Expose helpers via kebab-case functions whose filenames match (e.g. `functions/run-ginkgo.fish` exports `run-ginkgo`). Prefer descriptive `--argument-names` and guard required inputs explicitly. Wrap external commands with `command <tool>` to bypass aliases, and document non-obvious plugin additions inline in `fish_plugins`.

## Testing Guidelines
There is no dedicated test harness; rely on syntax checks (`fish -n`) and dry runs inside disposable shells. For complex helpers, execute them with representative arguments, such as `run-ginkgo component "Store - GetScriptsByAssetUID" ./modules/...`. Echo sample output in comments when helpful, and surface risky shell-outs for review.

## Commit & Pull Request Guidelines
Follow Conventional Commits (e.g. `feat: add yazi helper`). Keep each commit focused and update related docs when behavior changes. Pull requests should explain motivation, flag new dependencies (brew, curl, etc.), and note any security-sensitive paths touched. List the validation you ran—`fish -n`, manual command output—so reviewers can replay the steps quickly.

## Security & Configuration Tips
Never commit populated `.dotenv-*` files or credentials. Store secrets locally in `secrets.fish` and ensure it remains untracked. When introducing helpers that require external CLIs, wire them into `install-deps` so teammates can bootstrap safely.
