# Dotfiles Setup

My dotfiles managed with [yadm](https://yadm.io/)

---

## Quick Setup (Brewfile)

If you already have Homebrew and yadm configured, you can restore everything at once:

```bash
# Dump current packages (for backup)
brew bundle dump --file=~/.config/brew/mac.Brewfile --no-vscode --force

# Install everything from Brewfile
brew bundle --file=~/.config/brew/mac.Brewfile
```

> `dump --force` rewrites the Brewfile from what brew currently owns. Anything
> installed another way is silently dropped, e.g. `uv` (standalone installer).
> Check the diff before committing a fresh dump.

> If an app or font is already installed by hand, add `--adopt`
> (`brew install --cask <name> --adopt`) so brew manages it instead of erroring.

For a fresh device, follow the step-by-step guide below.

---

## Step-by-Step Setup

### 1. Homebrew

Package manager for macOS/Linux. Skip if already installed.

**macOS:**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Linux (user-local install):**

```bash
mkdir -p ~/.linuxbrew
git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir -p ~/.linuxbrew/bin
ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin

echo 'eval "$(~/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
source ~/.bashrc

brew install zsh
```

### 2. yadm (dotfile manager)

```bash
# Install yadm
mkdir -p ~/.local/bin && curl -fLo ~/.local/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod a+x ~/.local/bin/yadm && export PATH=$PATH:$HOME/.local/bin

# Setup Bitwarden (for encrypted dotfiles)
export BW_CLIENTID={BITWARDEN_CLIENT_ID}
export BW_CLIENTSECRET={BITWARDEN_CLIENT_SECRET}
export BW_PASSWORD={BITWARDEN_PASSWORD}
```

> Full bootstrap: [private gist](https://gist.github.com/dipta007/a68276b44fd9fa42f8746d6dfb2e8390)

> Secrets live in the yadm archive at `~/.local/share/yadm/archive`, the yadm 3.x
> default. Needs yadm 3.x, and `XDG_DATA_HOME` unset or set to `~/.local/share`.
> Do not keep it at `~/.config/yadm/archive` (the yadm 2.x path). Hooks and scripts
> that run `yadm decrypt` get no shell alias, so they fail with "does not exist".

### 3. Shell & Prompt

| Tool                                                | What it does         |
| --------------------------------------------------- | -------------------- |
| [sheldon](https://github.com/rossmacarthur/sheldon) | Zsh plugin manager   |
| [starship](https://starship.rs/)                    | Minimal, fast prompt |

```bash
brew install sheldon starship
```

### 4. Runtime & Package Management

| Tool                             | What it does                           |
| -------------------------------- | -------------------------------------- |
| [mise](https://mise.jdx.dev/)    | Manage Node, Python, Go, etc. versions |
| [uv](https://docs.astral.sh/uv/) | Fast Python package/project manager    |

```bash
brew install mise uv

# Install runtimes declared in ~/.config/mise/config.toml (node/npm) + gen shims.
# We use shims mode (no per-prompt activate hook), so this step is what creates
# the node/npm binaries on a fresh machine.
mise install

# Zsh completions for uv
mkdir -p ~/.local/share/zsh/completions
uv generate-shell-completion zsh > ~/.local/share/zsh/completions/_uv
uvx --generate-shell-completion zsh > ~/.local/share/zsh/completions/_uvx

# Install ipython as a global tool
uv tool install ipython
```

### 5. Search & Navigation

| Tool                                             | What it does                           |
| ------------------------------------------------ | -------------------------------------- |
| [fd](https://github.com/sharkdp/fd)              | Fast `find` alternative                |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast `grep` alternative                |
| [eza](https://github.com/eza-community/eza)      | Modern `ls` with git cols + icons (`ll` alias) |
| [fzf](https://github.com/junegunn/fzf)           | Fuzzy finder for everything            |
| [zoxide](https://github.com/ajeetdsouza/zoxide)  | Smarter `cd` that learns your habits   |
| [atuin](https://github.com/atuinsh/atuin)        | `Ctrl-R` history in SQLite, syncs across machines |
| [wt](https://github.com/max-sixty/worktrunk)     | Git worktree manager with fuzzy search |

```bash
brew install fd ripgrep eza fzf zoxide atuin worktrunk

# Zsh completions
fd --gen-completions zsh > ~/.local/share/zsh/completions/_fd

# atuin: import existing shell history (one-time, per machine)
atuin import zsh

# atuin: OPTIONAL encrypted history sync across machines (Mac + lab servers).
# Run `register` once on your first machine, then `login` on each other machine
# using the same key (atuin key on the first machine gives the recovery key).
atuin register -u <username> -e <email>   # first machine only
# atuin login -u <username>                # each additional machine
atuin sync
```

> `.zshrc` inits atuin with `--disable-up-arrow` (keeps our own up/down prefix-search).
> `Ctrl-R` is bound inside `zvm_after_init` so zsh-vi-mode doesn't clobber it, and
> atuin's experimental `?` AI binding is reset to normal there too.

### 6. Editor & Git

| Tool                                                | What it does        |
| --------------------------------------------------- | ------------------- |
| [neovim](https://neovim.io/)                        | Vim-based editor    |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |
| [git-delta](https://github.com/dandavid/delta)      | Better git diffs    |

```bash
brew install neovim lazygit git-delta
```

Inside neovim, install formatters:

```
:MasonInstall stylua shfmt prettier
```

### 7. Terminal Tools

| Tool                                                 | What it does                        |
| ---------------------------------------------------- | ----------------------------------- |
| [bat](https://github.com/sharkdp/bat)                | `cat` with syntax highlighting      |
| [yazi](https://github.com/sxyazi/yazi)               | Terminal file manager               |
| [jq](https://jqlang.github.io/jq/)                   | JSON processor                      |
| [aichat](https://github.com/sigoden/aichat)          | AI chat in terminal                 |
| [opencode](https://github.com/anomalyco/opencode)    | AI coding agent in the terminal     |
| [paseo](https://www.npmjs.com/package/@getpaseo/cli) | Drive AI coding agents from the CLI |
| [claude-sync](https://github.com/tawanorg/claude-sync) | Sync Claude Code sessions across machines (encrypted, own bucket) |
| [claude-swap](https://github.com/realiti4/claude-swap) | Switch Claude accounts before rate limits hit (`cswap`) |

```bash
brew install bat jq aichat

# Zsh completions for bat
bat --completion=zsh > ~/.local/share/zsh/completions/_bat
brew install --cask claude-code    # Claude Code CLI
brew install codex                 # OpenAI Codex CLI
brew install anomalyco/tap/opencode # opencode agent (pulls ripgrep)

# Paseo: needs node/npm from mise (section 4). Launches on first install.
npm install -g @getpaseo/cli
mise reshim                        # else paseo is not on PATH (node globals are shimmed)
paseo                              # first launch
# npm may block esbuild/node-pty postinstall scripts. If paseo misbehaves:
#   npm install -g --allow-scripts=esbuild,node-pty @getpaseo/cli

# claude-sync: session sync across machines. Standalone binary, NOT the npm
# package: node comes from mise (section 4), so a global npm install breaks on
# every node version switch. Asset per platform:
#   macOS  claude-sync-darwin-arm64  (Intel: -darwin-amd64)
#   Linux  claude-sync-linux-amd64   (arm64: -linux-arm64)
cd /tmp && B=claude-sync-darwin-arm64        # <- change per platform
curl -fsSL -O https://github.com/tawanorg/claude-sync/releases/latest/download/$B
curl -fsSL -O https://github.com/tawanorg/claude-sync/releases/latest/download/checksums.txt
grep "$B" checksums.txt && { shasum -a 256 "$B" 2>/dev/null || sha256sum "$B"; }  # hashes must match
chmod +x "$B" && mv "$B" ~/.local/bin/claude-sync

# FIRST machine: R2 (10GB free, zero egress), sessions scope only so it never
# fights yadm over settings.json/CLAUDE.md/skills/agents.
claude-sync init --provider r2 --scope sessions   # prompts for creds + passphrase
# Exclude anything that must not reach a personal bucket BEFORE the first push:
#   claude-sync paths exclude '<glob>'    # repeat per pattern
#   claude-sync paths list                # verify, THEN push
claude-sync push

# NEW machine: `yadm decrypt` already restored ~/.claude-sync/config.yaml, which
# carries the R2 creds, scope AND the excludes. The age key is missing on purpose:
# it is derived from the passphrase, so archiving it buys nothing.
claude-sync init --passphrase      # SAME passphrase or nothing decrypts

# init writes the age key but does NOT update encryption_key_path. It still names
# the home of the machine that made the config, so every command dies with
# "failed to read age key". Fix it first:
grep encryption_key_path ~/.claude-sync/config.yaml   # see whose home it names
sed -i '' "s#/Users/OLD_USER#$HOME#" ~/.claude-sync/config.yaml

claude-sync paths list             # confirm scope + excludes came across
claude-sync status                 # also shows what a push would upload
claude-sync pull --dry-run         # pull is interactive; dry-run shows the damage
claude-sync pull                   # pick "backup existing files" at the prompt
# Sessions over 100MB upload fine but can NEVER be pulled back: MaxDownloadSize
# is a hardcoded 100MB on the download path only. Pull reports them failed
# forever. Keep sessions small. Upstream: tawanorg/claude-sync#87

# claude-swap: multi-account switcher, command is `cswap`. Needs uv (section 4).
# Swaps stored credentials (Keychain on macOS), so CLI + VS Code both work.
uv tool install claude-swap
# uv tool install 'claude-swap[menubar]'   # + macOS menu bar quota extra

```

### 7b. tmux plugin dependencies

tmux plugins install themselves via TPM (`prefix + I`), but these binaries they
depend on are NOT installed by TPM — do these manually per machine.

| Tool | Used by | What it does |
| ---- | ------- | ------------ |
| [sesh](https://github.com/joshmedeski/sesh)          | `prefix + o` | fuzzy jump to any project/session (uses zoxide) |
| [tmux-fingers](https://github.com/Morantron/tmux-fingers) | `prefix + f` | hint-label copy of paths/urls/hashes on screen |
| python3 | [extrakto](https://github.com/laktak/extrakto) (`prefix + Tab`) | fzf grab of pane text into the command line |

```bash
brew install tmux              # no earlier section installs it
brew install sesh              # needs zoxide + fzf (already installed above)
brew install tmux-fingers      # or let its prefix+I wizard pick "brew"
brew install python            # for extrakto (fzf already present)
```

> First tmux launch: run `prefix + I` to install the TPM plugins, then the binaries
> above make sesh/fingers/extrakto work. lazygit popup (`prefix + g`) needs `lazygit`
> (installed in section 6).

### 8. Fonts

```bash
brew install font-meslo-lg-nerd-font font-symbols-only-nerd-font
brew install --cask font-jetbrains-mono
```

---

## macOS Only

These are only needed on a local macOS machine (not remote servers).

### 9. Terminal Emulator & Apps

```bash
# yazi + its optional dependencies
brew install yazi ffmpeg sevenzip poppler resvg imagemagick

brew install --cask ghostty         # GPU-accelerated terminal
brew install --cask claude          # Claude desktop app
brew install cronboard              # cron scheduler with a terminal UI
brew install --cask wispr-flow      # voice-to-text dictation, AI auto-editing

# terminal-notifier: powers Claude Code's click-to-focus notifications
# (~/.claude/hooks/notify.sh). Click a banner -> jumps to the tmux pane that
# fired it. Without it the hook falls back to a plain (non-clickable) banner.
brew install terminal-notifier
```

### 10. GitHub CLI

```bash
brew install gh && gh auth login
```

### 11. Window Management

| Tool                                                  | What it does                  |
| ----------------------------------------------------- | ----------------------------- |
| [aerospace](https://github.com/nikitabobko/AeroSpace) | Tiling window manager         |
| [borders](https://github.com/FelixKratz/JankyBorders) | Colored window borders        |
| [Homerow](https://www.homerow.app/)                   | Keyboard-driven UI navigation |
| [kindavim](https://kindavim.app/)                     | Vim keybindings system-wide   |

```bash
brew install --cask kindavim      # vim keys system-wide
brew install --cask homerow       # keyboard-driven UI navigation

brew install --cask nikitabobko/tap/aerospace
brew tap FelixKratz/formulae
brew install borders

# Let spaces span across displays
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

# Group windows by app in Mission Control
defaults write com.apple.dock expose-group-apps -bool true && killall Dock
```

After install, set Homerow's hotkeys (cmd + shift + space and cmd + shift + j) in its settings.

### 12. Other macOS Tools

```bash
brew install --cask mactex                   # LaTeX distribution
brew install imagemagick                      # Image manipulation
brew install luarocks                        # Lua package manager
# image.nvim is disabled in the nvim config, so the magick rock is not needed.
# if you re-enable it: luarocks install magick
brew install mutagen-io/mutagen/mutagen      # File sync for remote dev
```
