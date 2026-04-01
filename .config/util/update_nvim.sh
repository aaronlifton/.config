#!/usr/bin/env bash
set -euo pipefail

SOURCE_ROOT="${HOME}/.config"
DEST_ROOT="/Users/aarron/Code/.config/.config"

DRY_RUN=0
VERBOSE=0

ENTRIES=(
  aerospace
  alacritty
  atuin
  base_config
  bat
  btop
  commitlint.config.js
  fd
  fish
  gh
  ghostty
  git
  helix
  htop
  Justfile
  karabiner
  karabiner.edn
  kitty
  km-nvim
  LaunchAgents
  lazydocker
  lazygit
  mcphub
  mise
  mise.toml
  neovide
  newsboat
  nvim
  nvim2
  nvimpager
  README.md
  rg
  starship
  starship.toml
  vale
  wezterm
  yadm
  yadm_notes.md
  yazi
  zellij
)

usage() {
  cat <<'USAGE'
Usage: update_nvim.sh [--dry-run] [--verbose]

Sync an allowlist of top-level entries from ~/.config into:
  /Users/aarron/Code/.config/.config

This is a safe sync:
  - changed files are copied over
  - missing source entries are skipped
  - extra files already in the destination are not deleted

Options:
  -n, --dry-run  Show what would change without writing anything
  -v, --verbose  Print rsync's per-file output
  -h, --help     Show this help text
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)
      DRY_RUN=1
      ;;
    -v|--verbose)
      VERBOSE=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if ! command -v rsync >/dev/null 2>&1; then
  echo "rsync is required but was not found in PATH." >&2
  exit 1
fi

mkdir -p "$DEST_ROOT"

rsync_opts=(
  --archive
  --human-readable
  --exclude=.DS_Store
  --exclude=.git/
  --exclude=.svn/
  --exclude=.hg/
  --exclude=__pycache__/
  --exclude=.mypy_cache/
  --exclude=.pytest_cache/
  --exclude=.pyre/
)
if [[ "$DRY_RUN" -eq 1 ]]; then
  rsync_opts+=(--dry-run --itemize-changes)
fi
if [[ "$VERBOSE" -eq 1 ]]; then
  rsync_opts+=(--verbose)
fi

synced=0
skipped=0

for entry in "${ENTRIES[@]}"; do
  src="${SOURCE_ROOT}/${entry}"
  if [[ ! -e "$src" ]]; then
    echo "skip: ${entry} (missing from ${SOURCE_ROOT})"
    skipped=$((skipped + 1))
    continue
  fi

  echo "sync: ${entry}"
  rsync "${rsync_opts[@]}" "$src" "$DEST_ROOT/"
  synced=$((synced + 1))
done

echo
if [[ "$synced" -eq 1 ]]; then
  entry_word="entry"
else
  entry_word="entries"
fi

echo "Done. Synced ${synced} ${entry_word}; skipped ${skipped}."
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Dry run only; no files were modified."
fi
