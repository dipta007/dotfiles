> [!IMPORTANT]
> Only for ME 👨🏻‍💻  
> Init YADM script - [private gist](https://gist.github.com/dipta007/a68276b44fd9fa42f8746d6dfb2e8390)  
> See below for public version

## Installation

1. install nvim
2. install yadm
3. clone the repo using yadm
4. install the dependencies

```bash
brew install shelldon
brew install starship

brew install fd
fd --gen-completions zsh > ~/.local/share/zsh/completions/_fd

brew install uv
uv generate-shell-completion zsh > ~/.local/share/zsh/completions/_uv
uvx --generate-shell-completion zsh > ~/.local/share/zsh/completions/_uvx

brew install ripgrep

brew install bat
bat --completion=zsh > ~/.local/share/zsh/completions/_bat

brew install zoxide

brew install yazi ffmpeg-full sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick-full font-symbols-only-nerd-font

brew install fzf
```

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
