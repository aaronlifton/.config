# Repository Guidelines

## Project Structure & Module Organization
This LazyVim configuration boots from `init.lua` and keeps reusable helpers under `lua/util/`. Plugin specs live in `lua/plugins/`, while per-feature adjustments sit in `lua/config/`. Store language server and tooling presets in `configs/`, and place any Fennel modules inside `fnl/`. Regression and unit specs belong in `tests/`, mirroring the directories they exercise (e.g., `tests/config/` covers `lua/config/`).

## Build, Test, and Development Commands
- `nvim --headless "+Lazy sync" +qa` installs or updates the plugin set declared in `lua/plugins/`.
- `nvim --headless -c "checkhealth" +qa` verifies LazyVim integrations after you adjust plugins or external tooling.
- `nvim -l ./tests/busted.lua tests` runs the Busted suite and should pass before pushing changes.

## Coding Style & Naming Conventions
Format Lua with `stylua` (configured in `stylua.toml` for 2-space indents, width 120, double quotes). Lint Lua with Selene via `selene.toml`. Match module names to file paths using snake_case (e.g., `lua/config/lsp.lua` for `config.lsp`). Keep plugin declarations declarative—extract logic to helpers under `lua/util/` or dedicated config modules.

## Testing Guidelines
Write specs with Busted in `tests/`, matching folder structure to the target module. Use descriptive `describe`/`it` phrases that reflect the feature under test. Add regression coverage when fixing bugs so the suite fails before the fix and passes afterward. Always run `nvim -l ./tests/busted.lua tests` before submitting work.

## Commit & Pull Request Guidelines
Follow the conventional prefixes already in `git log` (`fix:`, `feat:`, `docs:`, etc.) with a concise scope and summary. PRs should link related issues, outline configuration or UI changes, and include screenshots or terminal output when behavior is user-facing. Confirm `stylua` formatting and the full Busted suite prior to review, and call out any remaining risks in the PR description.

## Security & Configuration Tips
Limit machine-specific tweaks to `after/` or `lua/custom/` so they stay out of shared modules. Keep tokens or secrets in environment variables; never commit them. Document any new external dependencies directly alongside their configuration blocks to ease future maintenance.
