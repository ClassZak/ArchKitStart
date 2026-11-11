#!/usr/bin/env bash
#
# install.sh — install lazy.nvim and sync all Neovim plugins.
#
# DESCRIPTION
#   Cold-install script for a Neovim configuration on a new machine. It
#   checks whether the lazy.nvim plugin manager is present and, if not,
#   clones it from the official repository. It then starts Neovim in
#   headless mode and runs :Lazy! sync, which installs every plugin
#   described in the configuration (including local plugins from
#   custom_plugins/ that are picked up via { import = "plugins" }).
#
# USAGE
#   chmod +x install.sh
#   ./install.sh
#
# REQUIREMENTS
#   - git
#   - neovim (>= 0.9)
#   - network access for the initial lazy.nvim clone and plugin install
#
# PATHS
#   lazy.nvim : ~/.local/share/nvim/lazy/lazy.nvim
#   config    : ~/.config/nvim
#
# NOTES
#   - The script is idempotent: re-running it will not break anything.
#   - Local plugins under custom_plugins/ are not cloned: lazy.nvim uses
#     them in place via dir = ... in the plugin spec.
#   - To update already-installed plugins, run :Lazy update inside
#     Neovim, or replace "sync" with "update" in the headless call below.
#
# EXIT CODES
#   0 — success
#   1 — failure (e.g. lazy.nvim could not be cloned)
#

set -euo pipefail

readonly LAZY_REPO="https://github.com/folke/lazy.nvim.git"
readonly LAZY_BRANCH="stable"
readonly DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
readonly LAZY_PATH="$DATA_DIR/lazy/lazy.nvim"
readonly NVIM_BIN="${NVIM_BIN:-nvim}"

log() {
	printf '[install] %s\n' "$*"
}

die() {
	printf '[install] ERROR: %s\n' "$*" >&2
	exit 1
}

require_cmd() {
	command -v "$1" >/dev/null 2>&1 || die "command not found: $1"
}

require_cmd git
require_cmd "$NVIM_BIN"

if [ ! -d "$LAZY_PATH" ]; then
	log "lazy.nvim not found, cloning into $LAZY_PATH"
	mkdir -p "$(dirname "$LAZY_PATH")"
	git clone --filter=blob:none --branch="$LAZY_BRANCH" "$LAZY_REPO" "$LAZY_PATH" \
		|| die "failed to clone lazy.nvim"
	log "lazy.nvim installed"
else
	log "lazy.nvim already present at $LAZY_PATH"
fi

log "syncing plugins via headless Neovim"
"$NVIM_BIN" --headless "+Lazy! sync" +qa \
	|| die "Lazy sync failed"

log "done. Restart Neovim to use the configuration."
