eval "$(~/.linuxbrew/bin/brew shellenv)"
if [[ $- == *i* ]]; then
    export SHELL="$(brew --prefix)/bin/zsh"
    exec "$(brew --prefix)/bin/zsh" -l
fi


