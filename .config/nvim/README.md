# Neovim Config

## Prerequisites

### Required

- **Xcode Command Line Tools** - `xcode-select --install` (provides git, clang, curl, sed, unzip)
- **[Nerd Font](https://www.nerdfonts.com/)** - install one and set it in your terminal
- **Node.js >= 18** - for Copilot, several LSPs (jsonls, bashls, dockerls), and prettier
- **ripgrep** - `brew install ripgrep`
- **fd** - `brew install fd`
- **lazygit** - `brew install lazygit`

### After First Launch

Install formatters used by conform.nvim:

```vim
:MasonInstall stylua shfmt prettier
```

LSP servers (ruff, lua_ls, jsonls, bashls, dockerls, docker_compose_language_service, taplo, marksman) are auto-installed by mason-lspconfig.

### Optional

| Tool | What for | Install |
|------|----------|---------|
| gh CLI | GitHub issues/PRs (`<leader>gi`, `<leader>gp`) | `brew install gh && gh auth login` |
| claude CLI | AI assistant (`<leader>ac` via sidekick.nvim) | `npm install -g @anthropic-ai/claude-code` |
| ipython | Python REPL (`<leader>ro`) | `uv tool install ipython` |
| MacTeX | LaTeX editing (`.tex` files) | `brew install --cask mactex` |
| Kitty/WezTerm | Image rendering in markdown | Terminal with Kitty graphics protocol |
| ImageMagick | Image rendering (image.nvim + snacks.img) | `brew install imagemagick` |
| luarocks + magick | Image rendering (image.nvim) | `luarocks install magick` |
| Obsidian app | Obsidian notes integration | iCloud vault synced locally |
| tmux | Cross-pane navigation with Navigator.nvim | `brew install tmux` |
