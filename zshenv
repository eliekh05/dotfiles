# ~/.zshenv — sourced for ALL shells (interactive, non-interactive, scripts)
# Keep this minimal and fast. Only set environment variables here.

# Rust / Cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Add your local bin to PATH early so everything picks it up
export PATH="$HOME/.local/bin:$PATH"
