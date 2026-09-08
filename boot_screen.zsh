#!/usr/bin/env zsh
# =============================================================================
#  TERMINAL BOOT SCREEN
#  Auto-detects OS, arch, and tools — works on macOS, Linux, Windows (WSL)
#  No config needed — only installed tools are shown
# =============================================================================

RESET='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
C_CYAN='\033[38;5;51m';   C_BLUE='\033[38;5;39m';   C_PURPLE='\033[38;5;141m'
C_PINK='\033[38;5;213m';  C_GREEN='\033[38;5;82m';   C_YELLOW='\033[38;5;226m'
C_ORANGE='\033[38;5;208m';C_RED='\033[38;5;196m';    C_WHITE='\033[38;5;255m'
C_GREY='\033[38;5;240m'

# ── OS Detection ──────────────────────────────────────────────────────────────
_detect_os() {
  case "$OSTYPE" in
    darwin*)  echo "macos" ;;
    linux*)
      grep -qi microsoft /proc/version 2>/dev/null && echo "wsl" || echo "linux" ;;
    msys*|cygwin*|mingw*) echo "windows" ;;
    *) echo "unknown" ;;
  esac
}

_os_label() {
  case "$1" in
    macos)   echo "🍎 macOS" ;;
    linux)   echo "🐧 Linux" ;;
    wsl)     echo "🪟 Windows (WSL)" ;;
    windows) echo "🪟 Windows" ;;
    *)       echo "💻 Unknown" ;;
  esac
}

_detect_arch() {
  case "$(uname -m 2>/dev/null)" in
    x86_64|amd64)  echo "x86_64" ;;
    arm64|aarch64) echo "arm64" ;;
    i386|i686)     echo "x86" ;;
    *)             echo "$(uname -m)" ;;
  esac
}

# ── Typewriter ────────────────────────────────────────────────────────────────
_typewrite() {
  local color="$1" text="$2" delay="${3:-0.022}"
  printf "${color}"
  for (( i=1; i<=${#text}; i++ )); do printf "%s" "${text[$i]}"; sleep "$delay"; done
  printf "${RESET}\n"
}

# ── Tool line — silently skipped if command not found ─────────────────────────
_tool_line() {
  local label="$1" cmd="$2"
  if command -v "$cmd" &>/dev/null; then
    local ver
    ver=$("$cmd" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
    [[ -z "$ver" ]] && ver="found"
    printf "  ${C_CYAN}%-18s${RESET}  ${C_GREEN}●${RESET}  ${C_GREY}%s${RESET}\n" "$label" "$ver"
  fi
}

_section() { printf "\n  ${C_PURPLE}${BOLD}$1${RESET}\n\n"; }

_git_info() {
  if git rev-parse --git-dir &>/dev/null 2>&1; then
    local branch dirty=""
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    git diff --quiet 2>/dev/null || dirty=" ${C_ORANGE}✦ dirty${RESET}"
    printf "  ${C_GREY}git${RESET}  ${C_PURPLE}⎇  %s${RESET}%s\n\n" "$branch" "$dirty"
  fi
}

# =============================================================================
clear
tput civis 2>/dev/null

# Glitch intro
for _ in 1 2 3; do
  printf "${C_PINK}${BOLD}  ▓▒░ INIT ░▒▓${RESET}\n"; sleep 0.07; tput cuu1; tput el
done
sleep 0.1

# Logo
printf "\n"
printf "${C_CYAN}${BOLD}  ╔═══════════════════════════════════════════════════════════╗\n"
printf "${C_BLUE}${BOLD}  ║                                                           ║\n"
printf "  ║        ██████╗ ███████╗██╗   ██╗                        ║\n"
printf "  ║        ██╔══██╗██╔════╝██║   ██║                        ║\n"
printf "  ║        ██║  ██║█████╗  ██║   ██║                        ║\n"
printf "  ║        ██║  ██║██╔══╝  ╚██╗ ██╔╝                        ║\n"
printf "  ║        ██████╔╝███████╗ ╚████╔╝                         ║\n"
printf "  ║        ╚═════╝ ╚══════╝  ╚═══╝                          ║\n"
printf "  ║                                                           ║\n"
printf "${C_PURPLE}${BOLD}  ║                  My Dev Environment                       ║\n"
printf "${C_CYAN}${BOLD}  ╚═══════════════════════════════════════════════════════════╝\n"
printf "${RESET}\n"
sleep 0.15

# System info
local _os=$(_detect_os)
local _user=$(whoami)
local _host=$(hostname -s 2>/dev/null || echo "localhost")
local _date=$(date "+%A, %b %d %Y")
local _time=$(date "+%H:%M:%S")
local _uptime=$(uptime | sed 's/.*up //' | sed 's/,.*//' | xargs 2>/dev/null || echo "n/a")

printf "  ${C_GREY}┌─────────────────────────────────────────────────────────┐${RESET}\n"
printf "  ${C_GREY}│${RESET}  ${C_PINK}◉${RESET} ${C_WHITE}user    ${C_YELLOW}%-18s${RESET}  ${C_PINK}◉${RESET} ${C_WHITE}host    ${C_YELLOW}%s${RESET}\n" "$_user" "$_host"
printf "  ${C_GREY}│${RESET}  ${C_CYAN}◈${RESET} ${C_WHITE}date    ${C_GREEN}%-18s${RESET}  ${C_CYAN}◈${RESET} ${C_WHITE}time    ${C_GREEN}%s${RESET}\n" "$_date" "$_time"
printf "  ${C_GREY}│${RESET}  ${C_BLUE}◆${RESET} ${C_WHITE}os      ${C_BLUE}%-18s${RESET}  ${C_BLUE}◆${RESET} ${C_WHITE}arch    ${C_BLUE}%s${RESET}\n" "$(_os_label $_os)" "$(_detect_arch)"
printf "  ${C_GREY}│${RESET}  ${C_PURPLE}◆${RESET} ${C_WHITE}uptime  ${C_PURPLE}%s${RESET}\n" "$_uptime"
printf "  ${C_GREY}└─────────────────────────────────────────────────────────┘${RESET}\n"

_git_info

# ── Tools — only installed ones show up ───────────────────────────────────────

_section "📦 Version Managers"
_tool_line "nvm"           "nvm"
_tool_line "fnm"           "fnm"
_tool_line "volta"         "volta"
_tool_line "pyenv"         "pyenv"
_tool_line "rbenv"         "rbenv"
_tool_line "chruby"        "chruby"
_tool_line "jenv"          "jenv"
_tool_line "sdkman"        "sdk"
_tool_line "asdf"          "asdf"
_tool_line "mise"          "mise"

_section "🚀 Runtimes"
_tool_line "node"          "node"
_tool_line "deno"          "deno"
_tool_line "bun"           "bun"
_tool_line "python"        "python3"
_tool_line "ruby"          "ruby"
_tool_line "java"          "java"
_tool_line "go"            "go"
_tool_line "rustc"         "rustc"
_tool_line "swift"         "swift"
_tool_line "kotlin"        "kotlin"
_tool_line "php"           "php"
_tool_line "perl"          "perl"
_tool_line "lua"           "lua"
_tool_line "luajit"        "luajit"
_tool_line "v"             "v"
_tool_line "zig"           "zig"
_tool_line "elixir"        "elixir"
_tool_line "erlang"        "erl"
_tool_line "haskell"       "ghc"
_tool_line "ocaml"         "ocaml"
_tool_line "julia"         "julia"
_tool_line "r"             "Rscript"
_tool_line "dotnet"        "dotnet"
_tool_line "rustpython"    "rustpython"
_tool_line "micropython"   "micropython"
_tool_line "pypy"          "pypy3"

_section "📦 Package Managers"
_tool_line "npm"           "npm"
_tool_line "yarn"          "yarn"
_tool_line "pnpm"          "pnpm"
_tool_line "pip"           "pip3"
_tool_line "uv"            "uv"
_tool_line "pipx"          "pipx"
_tool_line "gem"           "gem"
_tool_line "composer"      "composer"
_tool_line "cargo"         "cargo"
_tool_line "brew"          "brew"
_tool_line "port"          "port"
_tool_line "apt"           "apt"
_tool_line "apt-get"       "apt-get"
_tool_line "dnf"           "dnf"
_tool_line "yum"           "yum"
_tool_line "pacman"        "pacman"
_tool_line "zypper"        "zypper"
_tool_line "snap"          "snap"
_tool_line "flatpak"       "flatpak"
_tool_line "winget"        "winget"
_tool_line "choco"         "choco"
_tool_line "scoop"         "scoop"
_tool_line "nix"           "nix"
_tool_line "guix"          "guix"

_section "🐳 DevOps & Cloud"
_tool_line "docker"        "docker"
_tool_line "podman"        "podman"
_tool_line "kubectl"       "kubectl"
_tool_line "helm"          "helm"
_tool_line "terraform"     "terraform"
_tool_line "ansible"       "ansible"
_tool_line "vagrant"       "vagrant"
_tool_line "packer"        "packer"
_tool_line "minikube"      "minikube"
_tool_line "kind"          "kind"
_tool_line "k9s"           "k9s"
_tool_line "flux"          "flux"
_tool_line "argocd"        "argocd"
_tool_line "linkerd"       "linkerd"
_tool_line "aws"           "aws"
_tool_line "gcloud"        "gcloud"
_tool_line "az"            "az"
_tool_line "vercel"        "vercel"
_tool_line "netlify"       "netlify"
_tool_line "fly"           "fly"
_tool_line "wrangler"      "wrangler"
_tool_line "fastly"        "fastly"
_tool_line "supabase"      "supabase"
_tool_line "firebase"      "firebase"
_tool_line "railway"       "railway"

_section "🔧 Build Tools"
_tool_line "make"          "make"
_tool_line "cmake"         "cmake"
_tool_line "ninja"         "ninja"
_tool_line "meson"         "meson"
_tool_line "gradle"        "gradle"
_tool_line "maven"         "mvn"
_tool_line "bazel"         "bazel"
_tool_line "just"          "just"
_tool_line "xcodebuild"    "xcodebuild"

_section "🔀 Version Control"
_tool_line "git"           "git"
_tool_line "gh"            "gh"
_tool_line "hub"           "hub"
_tool_line "git-lfs"       "git-lfs"
_tool_line "svn"           "svn"
_tool_line "hg"            "hg"
_tool_line "gitlab-runner" "gitlab-runner"
_tool_line "dependabot"    "dependabot"

_section "🛠  Shell & CLI Tools"
_tool_line "tmux"          "tmux"
_tool_line "zsh"           "zsh"
_tool_line "bash"          "bash"
_tool_line "fish"          "fish"
_tool_line "bat"           "bat"
_tool_line "eza"           "eza"
_tool_line "fzf"           "fzf"
_tool_line "ripgrep"       "rg"
_tool_line "fd"            "fd"
_tool_line "jq"            "jq"
_tool_line "yq"            "yq"
_tool_line "curl"          "curl"
_tool_line "wget"          "wget"
_tool_line "rsync"         "rsync"
_tool_line "htop"          "htop"
_tool_line "btop"          "btop"
_tool_line "neofetch"      "neofetch"
_tool_line "fastfetch"     "fastfetch"
_tool_line "pandoc"        "pandoc"
_tool_line "ffmpeg"        "ffmpeg"
_tool_line "imagemagick"   "convert"
_tool_line "whisper"       "whisper"
_tool_line "yt-dlp"        "yt-dlp"
_tool_line "aria2"         "aria2c"
_tool_line "pv"            "pv"
_tool_line "tldr"          "tldr"

_section "🗄  Databases"
_tool_line "psql"          "psql"
_tool_line "mysql"         "mysql"
_tool_line "sqlite"        "sqlite3"
_tool_line "redis-cli"     "redis-cli"
_tool_line "mongosh"       "mongosh"

_section "🔐 Security"
_tool_line "gpg"           "gpg"
_tool_line "ssh"           "ssh"
_tool_line "openssl"       "openssl"

_section "✏️  Editors"
_tool_line "vim"           "vim"
_tool_line "nvim"          "nvim"
_tool_line "nano"          "nano"
_tool_line "emacs"         "emacs"
_tool_line "helix"         "hx"
_tool_line "code"          "code"
_tool_line "zed"           "zed"

# Quote
local -a quotes=(
  "\"Ship it. Polish it later.\""
  "\"Make it work, make it right, make it fast.\" — Kent Beck"
  "\"Talk is cheap. Show me the code.\" — Linus Torvalds"
  "\"It works on my machine.\" — Every developer"
  "\"Any fool can write code a computer understands.\" — Fowler"
  "\"First, solve the problem. Then, write the code.\""
  "\"sudo make me a sandwich\""
  "\"404: Motivation not found. Coding anyway.\""
  "\"rm -rf bugs/  — if only it were that easy\""
  "\"Simplicity is the soul of efficiency.\" — Austin Freeman"
  "\"There are only two hard things in CS: cache invalidation and naming things.\""
  "\"It's not a bug, it's an undocumented feature.\""
  "\"Works on my machine™\""
  "\"Have you tried turning it off and on again?\""
  "\"In a world without walls, who needs Windows?\""
)

local idx=$(( RANDOM % ${#quotes[@]} + 1 ))
printf "\n  ${C_GREY}─────────────────────────────────────────────────────────${RESET}\n"
printf "  ${C_YELLOW}💬${RESET}  ${DIM}${quotes[$idx]}${RESET}\n"
printf "  ${C_GREY}─────────────────────────────────────────────────────────${RESET}\n\n"

sleep 0.1
_typewrite "${C_GREEN}${BOLD}" "  ✨  Ready. Let's build something great." 0.022
printf "\n"

tput cnorm 2>/dev/null
