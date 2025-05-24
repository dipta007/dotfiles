# antigen load and configuration
# run this on root: curl -L git.io/antigen > antigen.zsh
source ~/antigen.zsh
antigen init ~/.antigenrc


# If NVIM is available then nvim is the editor, else vim
if command -v nvim &> /dev/null; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi


# the things we want to do in MAC
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
  if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
    ##### WHAT YOU WANT TO DISABLE FOR WARP - BELOW

    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

    ##### WHAT YOU WANT TO DISABLE FOR WARP - ABOVE
  fi
fi


. "$HOME/.local/bin/env"


# if local zshrc is here, source it
if [[ -f "$HOME/.local_zshrc" ]]; then
  echo "sourcing local"
  . $HOME/.local_zshrc
fi


# source the common ones
. $HOME/.bashrc.secret
. $HOME/.bashrc.common

