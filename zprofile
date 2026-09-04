# ~/.zprofile — sourced for login shells
# Global Order: zshenv, zprofile, zshrc, zlogin

# ── Boot screen ───────────────────────────────────────────────────────────────
# Runs the animated boot screen on every new login shell.
# To disable, comment out the two lines below.
if [[ -o interactive && -f "$HOME/.boot_screen.zsh" ]]; then
  source "$HOME/.boot_screen.zsh"
fi
