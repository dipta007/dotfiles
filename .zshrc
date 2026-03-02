# zmodload zsh/zprof
# --- 1. Env vars and PATH (instant, no forks) ---
export EDITOR='nvim'

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY        # append instead of overwrite
setopt SHARE_HISTORY         # share history across sessions
setopt HIST_IGNORE_DUPS      # skip consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS  # remove older duplicate entries
setopt HIST_IGNORE_SPACE     # skip commands starting with space
setopt HIST_REDUCE_BLANKS    # trim extra whitespace

typeset -U path  # auto-deduplicate PATH entries
path=(
  "$HOME/.local/bin"
  $path
)

# --- 2. mise — replaces nvm, pyenv, conda ---
if [[ "$OSTYPE" == darwin* ]]; then
  eval "$(mise activate zsh)"
else
  path=("$HOME/.local/share/mise/shims" $path)
fi

# --- 3. Sheldon — plugin manager (cached on non-Mac) ---
if [[ "$OSTYPE" == darwin* ]]; then
  eval "$(sheldon source)"
else
  [[ ! -f ~/.cache/sheldon-source.zsh ]] && sheldon source > ~/.cache/sheldon-source.zsh
  source ~/.cache/sheldon-source.zsh
fi

# --- 4. Starship prompt (cached on non-Mac) ---
if [[ "$OSTYPE" == darwin* ]]; then
  eval "$(starship init zsh)"
else
  # Auto-generate platform config: disable expensive modules on non-Mac (NFS, etc.)
  _starship_local=~/.cache/starship-local.toml
  if [[ ! -f "$_starship_local" ]] || [[ ~/.config/starship.toml -nt "$_starship_local" ]]; then
    sed -e '/^\[git_status\]$/a disabled = true' ~/.config/starship.toml > "$_starship_local"
  fi
  export STARSHIP_CONFIG="$_starship_local"
  unset _starship_local

  _starship_cache=~/.cache/starship-init.zsh
  if [[ ! -f "$_starship_cache" ]] || [[ ~/.config/starship.toml -nt "$_starship_cache" ]]; then
    starship init zsh > "$_starship_cache"
  fi
  source "$_starship_cache"
  unset _starship_cache
fi

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

# --- 6. FZF (cached on non-Mac) ---
if [[ "$OSTYPE" == darwin* ]]; then
  source <(fzf --zsh)
else
  [[ ! -f ~/.cache/fzf-init.zsh ]] && fzf --zsh > ~/.cache/fzf-init.zsh
  source ~/.cache/fzf-init.zsh
fi
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

# --- 8. zoxide for smarter cd (cached on non-Mac) ---
if [[ "$OSTYPE" == darwin* ]]; then
  eval "$(zoxide init zsh)"
else
  [[ ! -f ~/.cache/zoxide-init.zsh ]] && zoxide init zsh > ~/.cache/zoxide-init.zsh
  source ~/.cache/zoxide-init.zsh
fi

# --- 9. Source secrets and common configs ---
. $HOME/.config/bashrc/secret
. $HOME/.config/bashrc/common
. $HOME/.config/bashrc/mutagen

# --- 10. Local overrides (not committed to git) ---
if [[ -f "$HOME/.config/bashrc/local" ]]; then
  . $HOME/.config/bashrc/local
fi
