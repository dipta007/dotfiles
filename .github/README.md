> [!IMPORTANT]
> Only for ME 👨🏻‍💻  
> Init YADM script - [private gist](https://gist.github.com/dipta007/a68276b44fd9fa42f8746d6dfb2e8390)  
> See below for public version

## Installation

0. Install Homebrew (only needed if you don't have it already):

```
# Set the install location to your home
mkdir -p ~/.linuxbrew
git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir -p ~/.linuxbrew/bin
ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin

brew install zsh
```

1. Install yadm: [only for me](https://gist.github.com/dipta007/a68276b44fd9fa42f8746d6dfb2e8390)

```
###########
# Install yadm
###########
mkdir -p ~/.local/bin && curl -fLo ~/.local/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod a+x ~/.local/bin/yadm && export PATH=$PATH:$HOME/.local/bin

##########
# SETUP BW
##########
export BW_CLIENTID={BITWARDEN_CLIENT_ID}
export BW_CLIENTSECRET={BITWARDEN_CLIENT_SECRET}
export BW_PASSWORD={BITWARDEN_PASSWORD}
```

2. Install the following dependencies:

```bash
brew install sheldon
brew install starship
brew install mise

mkdir -p ~/.local/share/zsh/completions

brew install uv
uv generate-shell-completion zsh > ~/.local/share/zsh/completions/_uv
uvx --generate-shell-completion zsh > ~/.local/share/zsh/completions/_uvx

uv tool install ipython

brew install sheldon starship mise uv fd ripgrep bat zoxide fzf neovim lazygit git-delta tmux font-meslo-lg-nerd-font

brew install fd
fd --gen-completions zsh > ~/.local/share/zsh/completions/_fd

brew install ripgrep

brew install bat
bat --completion=zsh > ~/.local/share/zsh/completions/_bat

brew install zoxide

brew install fzf

brew install neovim
:MasonInstall stylua shfmt prettier

brew install lazygit
brew install git-delta

brew install tmux

brew install font-meslo-lg-nerd-font

brew install yazi ffmpeg-full sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick-full font-symbols-only-nerd-font

########################################
# only install locally
########################################

brew install mutagen-io/mutagen/mutagen
brew install --cask claude-code

brew install --cask ghostty
brew install --cask claude
brew install codex

brew install --cask nikitabobko/tap/aerospace

brew install gh && gh auth login

brew install --cask mactex

brew install imagemagick

brew install luarocks

luarocks install magick

brew install --cask kindavim

brew tap FelixKratz/formulae
brew install borders
```

4. Install [Homerow](https://www.homerow.app/)

## Public Version:

```
###########
# Install yadm
###########
mkdir -p ~/.local/bin && curl -fLo ~/.local/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod a+x ~/.local/bin/yadm && export PATH=$PATH:$HOME/.local/bin

##########
# SETUP BW
##########
export BW_CLIENTID={BITWARDEN_CLIENT_ID}
export BW_CLIENTSECRET={BITWARDEN_CLIENT_SECRET}
export BW_PASSWORD={BITWARDEN_PASSWORD}
```
