#!/usr/bin/env zsh
# =============================================================================
#  dotfiles installer
# =============================================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

_link() {
  local src="$DOTFILES_DIR/$1" dst="$HOME/$2"
  if [[ -f "$dst" && ! -L "$dst" ]]; then
    echo "  ${YELLOW}⚠ backing up${RESET}  $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  ${GREEN}✓${RESET}  $dst"
}

echo "\n  Installing dotfiles...\n"

_link boot_screen.zsh  .boot_screen.zsh
_link zprofile          .zprofile
_link zshrc             .zshrc
_link zshenv            .zshenv

echo "\n  ${GREEN}Done!${RESET} Open a new terminal to see the boot screen.\n"
