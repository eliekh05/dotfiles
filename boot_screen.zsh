#!/usr/bin/env zsh
# =============================================================================
#  🚀  TERMINAL BOOT SCREEN
# =============================================================================

# ── Colors ───────────────────────────────────────────────────────────────────
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

C_CYAN='\033[38;5;51m'
C_BLUE='\033[38;5;39m'
C_PURPLE='\033[38;5;141m'
C_PINK='\033[38;5;213m'
C_GREEN='\033[38;5;82m'
C_YELLOW='\033[38;5;226m'
C_ORANGE='\033[38;5;208m'
C_RED='\033[38;5;196m'
C_WHITE='\033[38;5;255m'
C_GREY='\033[38;5;240m'

# ── Typewriter ────────────────────────────────────────────────────────────────
_typewrite() {
  local color="$1" text="$2" delay="${3:-0.025}"
  printf "${color}"
  for (( i=1; i<=${#text}; i++ )); do
    printf "%s" "${text[$i]}"
    sleep "$delay"
  done
  printf "${RESET}\n"
}

# ── Real tool check ───────────────────────────────────────────────────────────
_tool_line() {
  local label="$1" cmd="$2"
  if command -v "$cmd" &>/dev/null; then
    local ver
    ver=$( "$cmd" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1 )
    [[ -z "$ver" ]] && ver="found"
    printf "  ${C_CYAN}%-12s${RESET}  ${C_GREEN}● online${RESET}   ${C_GREY}%s${RESET}\n" "$label" "$ver"
  else
    printf "  ${C_CYAN}%-12s${RESET}  ${C_RED}○ absent${RESET}\n" "$label"
  fi
}

# ── Git branch of current dir ─────────────────────────────────────────────────
_git_info() {
  if git rev-parse --git-dir &>/dev/null 2>&1; then
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    local dirty=""
    git diff --quiet 2>/dev/null || dirty=" ${C_ORANGE}✦ dirty${RESET}"
    printf "  ${C_GREY}git${RESET}  ${C_PURPLE}⎇  %s${RESET}%s\n" "$branch" "$dirty"
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
clear
tput civis 2>/dev/null

# ── Glitch flicker ────────────────────────────────────────────────────────────
for _ in 1 2 3; do
  printf "${C_PINK}${BOLD}  ▓▒░ INIT ░▒▓${RESET}\n"
  sleep 0.07
  tput cuu1; tput el
done
sleep 0.1

# ── Logo ──────────────────────────────────────────────────────────────────────
# Edit the banner lines below to personalise your terminal
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

sleep 0.2

# ── System info ───────────────────────────────────────────────────────────────
local _user=$(whoami)
local _host=$(hostname -s 2>/dev/null || echo "localhost")
local _date=$(date "+%A, %b %d %Y")
local _time=$(date "+%H:%M:%S")
local _uptime=$(uptime | sed 's/.*up //' | sed 's/,.*//' | xargs)

printf "  ${C_GREY}┌─────────────────────────────────────────────────────────┐${RESET}\n"
printf "  ${C_GREY}│${RESET}  ${C_PINK}◉${RESET} ${C_WHITE}user    ${C_YELLOW}%-18s${RESET}  ${C_PINK}◉${RESET} ${C_WHITE}host    ${C_YELLOW}%s${RESET}\n" "$_user" "$_host"
printf "  ${C_GREY}│${RESET}  ${C_CYAN}◈${RESET} ${C_WHITE}date    ${C_GREEN}%-18s${RESET}  ${C_CYAN}◈${RESET} ${C_WHITE}time    ${C_GREEN}%s${RESET}\n" "$_date" "$_time"
printf "  ${C_GREY}│${RESET}  ${C_PURPLE}◆${RESET} ${C_WHITE}uptime  ${C_PURPLE}%s${RESET}\n" "$_uptime"
printf "  ${C_GREY}└─────────────────────────────────────────────────────────┘${RESET}\n"
printf "\n"

# ── Tool status (real checks — add/remove as needed) ──────────────────────────
printf "${C_PURPLE}${BOLD}  ⚡  TOOL STATUS${RESET}\n\n"

_tool_line "node"    "node"
_tool_line "npm"     "npm"
_tool_line "yarn"    "yarn"
_tool_line "deno"    "deno"
_tool_line "cargo"   "cargo"
_tool_line "rustc"   "rustc"
_tool_line "go"      "go"
_tool_line "git"     "git"
_tool_line "docker"  "docker"
_tool_line "uv"      "uv"
_tool_line "brew"    "brew"

_tool_line "brew"    "brew"



printf "\n"

# ── Git status of current dir ─────────────────────────────────────────────────
_git_info

printf "\n"

# ── Random quote ──────────────────────────────────────────────────────────────
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
  "\"Code is like humor. When you have to explain it, it's bad.\""
)

local idx=$(( RANDOM % ${#quotes[@]} + 1 ))
printf "  ${C_GREY}─────────────────────────────────────────────────────────${RESET}\n"
printf "  ${C_YELLOW}💬${RESET}  ${DIM}${quotes[$idx]}${RESET}\n"
printf "  ${C_GREY}─────────────────────────────────────────────────────────${RESET}\n\n"

# ── Done ──────────────────────────────────────────────────────────────────────
sleep 0.15
_typewrite "${C_GREEN}${BOLD}" "  ✨  Ready. Let's build something great." 0.022
printf "\n"

tput cnorm 2>/dev/null
