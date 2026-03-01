# zmodload zsh/zprof
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
# uv/uvx/fd completions pre-cached in fpath 
fpath=(~/.local/share/zsh/completions $fpath)

# compinit once per day, skip rebuild check otherwise
autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
setopt LOCAL_OPTIONS EXTENDED_GLOB
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi
# Compile dump in background for next startup
{ [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]] && zcompile "$ZSH_COMPDUMP" } &!

# --- 6. FZF ---
source <(fzf --zsh)  # modern fzf integration (replaces sourcing ~/.fzf.zsh)
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --extended'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .cache exclude .venv'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- 7. Prefix-based history search (up/down arrows) ---
# zvm_after_init hook runs after zsh-vi-mode so bindings don't get overwritten
function zvm_after_init() {
  bindkey '^[[A' history-beginning-search-backward
  bindkey '^[[B' history-beginning-search-forward
  bindkey '^[OA' history-beginning-search-backward
  bindkey '^[OB' history-beginning-search-forward
}

# --- 8. zoxide for smarter cd (replaces autojump, z.lua, etc.) ---
eval "$(zoxide init zsh)"

# --- 9. Source secrets and common configs ---
. $HOME/.config/bashrc/secret
. $HOME/.config/bashrc/common
. $HOME/.config/bashrc/mutagen

# --- 10. Local overrides (not committed to git) ---
if [[ -f "$HOME/.config/bashrc/local" ]]; then
  . $HOME/.config/bashrc/local
fi
