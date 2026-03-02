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

# Zsh completions for uv
mkdir -p ~/.local/share/zsh/completions
uv generate-shell-completion zsh > ~/.local/share/zsh/completions/_uv
uvx --generate-shell-completion zsh > ~/.local/share/zsh/completions/_uvx

# Install ipython as a global tool
uv tool install ipython
```

### 5. Search & Navigation

| Tool                                             | What it does                         |
| ------------------------------------------------ | ------------------------------------ |
| [fd](https://github.com/sharkdp/fd)              | Fast `find` alternative              |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast `grep` alternative              |
| [fzf](https://github.com/junegunn/fzf)           | Fuzzy finder for everything          |
| [zoxide](https://github.com/ajeetdsouza/zoxide)  | Smarter `cd` that learns your habits |

```bash
brew install fd ripgrep fzf zoxide

# Zsh completions
fd --gen-completions zsh > ~/.local/share/zsh/completions/_fd
```

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

| Tool                                        | What it does                   |
| ------------------------------------------- | ------------------------------ |
| [bat](https://github.com/sharkdp/bat)       | `cat` with syntax highlighting |
| [tmux](https://github.com/tmux/tmux)        | Terminal multiplexer           |
| [yazi](https://github.com/sxyazi/yazi)      | Terminal file manager          |
| [jq](https://jqlang.github.io/jq/)          | JSON processor                 |
| [aichat](https://github.com/sigoden/aichat) | AI chat in terminal            |

```bash
brew install bat tmux jq aichat

# Zsh completions for bat
bat --completion=zsh > ~/.local/share/zsh/completions/_bat

# yazi + its optional dependencies
brew install yazi ffmpeg sevenzip poppler resvg imagemagick
```

### 8. Fonts

```bash
brew install font-meslo-lg-nerd-font font-symbols-only-nerd-font
```

---

## macOS Only

These are only needed on a local macOS machine (not remote servers).

### 9. Terminal Emulator & Apps

```bash
brew install --cask ghostty       # GPU-accelerated terminal
brew install --cask claude         # Claude desktop app
brew install --cask claude-code    # Claude Code CLI
brew install codex                 # OpenAI Codex CLI
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
brew install --cask kindavim

brew install --cask nikitabobko/tap/aerospace
brew tap FelixKratz/formulae
brew install borders

# Let spaces span across displays
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

# Group windows by app in Mission Control
defaults write com.apple.dock expose-group-apps -bool true && killall Dock
```

Install [Homerow](https://www.homerow.app/) manually.

### 12. Other macOS Tools

```bash
brew install --cask mactex                   # LaTeX distribution
brew install imagemagick                      # Image manipulation
brew install luarocks && luarocks install magick  # Lua image library (for neovim)
brew install mutagen-io/mutagen/mutagen      # File sync for remote dev
```
