# ==============================================================================
# ~/.zshrc
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. PATH — edit to match your own tools
# ------------------------------------------------------------------------------
typeset -U path   # no duplicates

path=(
  "$HOME/.local/bin"
  /usr/local/bin
  /usr/local/sbin
  "$HOME/.cargo/bin"      # Rust
  "$HOME/go/bin"          # Go
  "$HOME/node_modules/.bin"
  $path
)

export PATH

# ------------------------------------------------------------------------------
# 2. COMPLETIONS
# ------------------------------------------------------------------------------
# Docker completions (remove if you don't use Docker)
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)

autoload -Uz compinit
compinit

# ------------------------------------------------------------------------------
# 3. ENVIRONMENT
# ------------------------------------------------------------------------------
# Deno
[[ -f "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

# Rust / Cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# zsh syntax highlighting — install with MacPorts or your package manager:
#   MacPorts:  sudo port install zsh-fast-syntax-highlighting
#   Homebrew:  brew install zsh-fast-syntax-highlighting
ZSH_HIGHLIGHT_PLUGIN="/usr/local/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
[[ -f "$ZSH_HIGHLIGHT_PLUGIN" ]] && source "$ZSH_HIGHLIGHT_PLUGIN"

# ------------------------------------------------------------------------------
# 4. PROMPT  (no plugins required)
# ------------------------------------------------------------------------------
autoload -Uz vcs_info colors && colors

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats        '%F{141}  %b%f'
zstyle ':vcs_info:git:*' actionformats  '%F{213}  %b (%a)%f'

precmd() { vcs_info }
setopt PROMPT_SUBST

# ╭─ ⚡ user  ~/path   branch
# ╰─ ❯
PROMPT='
%F{51}╭─%f %F{213}⚡%f %F{255}%n%f %F{240}in%f %F{82}%~%f${vcs_info_msg_0_}
%F{51}╰─%f %(?.%F{82}❯%f.%F{196}❯%f) '

RPROMPT='%F{240}%*%f'   # time on the right

# ------------------------------------------------------------------------------
# 5. ALIASES
# ------------------------------------------------------------------------------
alias ll='ls -lAFh'
alias la='ls -AF'
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias reload='source ~/.zshrc && echo "  ✅  zshrc reloaded"'
alias zconf='${EDITOR:-nano} ~/.zshrc'
alias path='echo $PATH | tr ":" "\n"'

# Git
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all --decorate'
alias gco='git checkout'
alias gb='git branch'

# Node / npm
alias ni='npm install'
alias nr='npm run'
alias nrd='npm run dev'

# Yarn
alias yi='yarn install'
alias yr='yarn run'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
