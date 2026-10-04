eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
if [[ $- == *i* ]] && [ -x "$(brew --prefix)/bin/zsh" ]; then
  export SHELL="$(brew --prefix)/bin/zsh"
  exec "$(brew --prefix)/bin/zsh" -l
fi

export PATH=$HOME/.toolbox/bin:$PATH
