zmodload zsh/zprof
# --- 1. Env vars and PATH (instant, no forks) ---
export EDITOR='nvim'

typeset -U path  # auto-deduplicate PATH entries
path=(
  "$HOME/.local/bin"
  $path
)

# --- 2. mise — replaces nvm, pyenv, conda (~5ms) ---
eval "$(mise activate zsh)"

# --- 3. Sheldon — plugin manager (~10ms) ---
eval "$(sheldon source)"

# --- 4. Starship prompt (~20ms) ---
eval "$(starship init zsh)"

# --- 5. Completions (cached, ~5ms) ---
# uv/uvx completions pre-cached in fpath 
fpath=(~/.local/share/zsh/completions $fpath)

# compinit once per day, skip rebuild check otherwise
autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi
# Compile dump in background for next startup
{ [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]] && zcompile "$ZSH_COMPDUMP" } &!

# --- 6. Source aliases and functions ---
# source "$HOME/.zsh_aliases"
# [[ -f "$HOME/.zsh_local_aliases" ]] && source "$HOME/.zsh_local_aliases"
# source "$HOME/.zsh_funcs"

# --- 7. FZF ---
source <(fzf --zsh)  # modern fzf integration (replaces sourcing ~/.fzf.zsh)
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --extended'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .cache'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- 8. Vi mode keybinding ---
# bindkey -v
# bindkey -M viins 'kj' vi-cmd-mode

# --- 9. zoxide for smarter cd (replaces autojump, z.lua, etc.) ---
eval "$(zoxide init zsh)"

alias cd='z'


# --- 10. Source secrets and common configs ---
. $HOME/.config/bashrc/secret
. $HOME/.config/bashrc/common
. $HOME/.config/bashrc/mutagen
