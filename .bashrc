# brew prefix differs per host: ~/.linuxbrew on corax, /home/linuxbrew on shared boxes.
for __brew in "$HOME/.linuxbrew/bin/brew" /home/linuxbrew/.linuxbrew/bin/brew /opt/homebrew/bin/brew; do
  [ -x "$__brew" ] && { eval "$("$__brew" shellenv)"; break; }
done
unset __brew
if [[ $- == *i* ]] && [ -x "$(brew --prefix)/bin/zsh" ]; then
  export SHELL="$(brew --prefix)/bin/zsh"
  exec "$(brew --prefix)/bin/zsh" -l
fi

export PATH=$HOME/.toolbox/bin:$PATH
