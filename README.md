# dotfiles 🚀

Animated terminal boot screen + neon zsh prompt + dev aliases.

Works on **macOS** (Intel & Apple Silicon) and **Linux**.

## What's included

| File | Purpose |
|------|---------|
| `boot_screen.zsh` | Animated boot screen — copy to `~/.boot_screen.zsh` |
| `zprofile` | Login shell — calls the boot screen |
| `zshrc` | Paths, completions, neon prompt, aliases |
| `zshenv` | Env vars for all shells |
| `install.sh` | One-command installer |

## Install

```zsh
git clone https://github.com/eliekh05/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then open a new terminal.

## Boot screen

On every login shell you'll see:

- Glitch intro flicker
- ASCII logo
- Live system info (user · host · date · time · uptime)
- **Real** tool status — checks node, npm, yarn, deno, cargo, rustc, go, git, docker
- Git branch + dirty flag of the current directory
- Random dev quote

### Package manager

Edit `boot_screen.zsh` and uncomment the line for your package manager:

```zsh
# _tool_line "brew"  "brew"   # Homebrew (Apple Silicon / Linux)
# _tool_line "port"  "port"   # MacPorts (Intel Mac)
# _tool_line "apt"   "apt"    # Debian/Ubuntu
```

## Prompt

```
╭─ ⚡ you  ~/projects/myapp   main
╰─ ❯ _
```

- Git branch shown automatically via `vcs_info` (no plugins needed)
- Prompt arrow turns **red** on non-zero exit code
- Current time on the right

## Syntax highlighting

Install `zsh-fast-syntax-highlighting` with your package manager:

```zsh
# MacPorts
sudo port install zsh-fast-syntax-highlighting

# Homebrew (Apple Silicon / Linux)
brew install zsh-fast-syntax-highlighting
```

The `.zshrc` loads it automatically if found — no error if missing.
