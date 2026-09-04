#!/usr/bin/env zsh
# =============================================================================
#  dotfiles installer
# =============================================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

mv() {
  local src="$DOTFILES_DIR/$1" dst="$HOME/$2"
  if [[ -f "$dst" && ! -L "$dst" ]]; then
    echo "  ${YELLOW}⚠ backing up${RESET}  $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  mv "$src" "$dst"
  echo "  ${GREEN}✓${RESET}  $dst"
}

echo "\n  Installing dotfiles...\n"

mv boot_screen.zsh  .boot_screen.zsh
mv zprofile          .zprofile
mv zshrc             .zshrc
mv zshenv            .zshenv

echo "\n  ${GREEN}Done!${RESET} Open a new terminal to see the boot screen.\n"
