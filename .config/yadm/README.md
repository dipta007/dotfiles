## Some Manual Things to install
0. brew (just if you dont have sudo access): 
    * first go to https://docs.brew.sh/Installation#untar-anywhere-unsupported
    * go to .local/
    * install using the untar alternative option, pasted here just if that is deprecated

```
eval "$(homebrew/bin/brew shellenv)"
brew update --force --quiet
chmod -R go-w "$(brew --prefix)/share/zsh"
```

* add to .bashrc/.zshrc: 

```
export PATH="$HOME/.local/homebrew/bin:$PATH"
brew shellenv
```

1. zsh (if not available): 

```
brew install zsh
# add to the end of .bashrc -- as you dont have sudo to change shell
exec zsh
```

2. antigen: `curl -L git.io/antigen > antigen.zsh`
3. bat: `brew install bat`
4. nvm: `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash`
5. ripgrep: `brew install ripgrep`
6. nvim: https://gist.github.com/dipta007/d36792b7c0080f1b919e9d5e2424aa41
7. borders for aerospace:
```
brew tap FelixKratz/formulae
brew install borders
```
8. install aerospace
```
brew install --cask nikitabobko/tap/aerospaces
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer
defaults write com.apple.dock expose-group-apps -bool true && killall dock
```
