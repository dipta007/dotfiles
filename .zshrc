# zmodload zsh/zprof
# --- 1. Env vars and PATH (instant, no forks) ---
export EDITOR='nvim'

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY        # append instead of overwrite
# setopt SHARE_HISTORY         # share history across sessions
setopt HIST_IGNORE_DUPS      # skip consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS  # remove older duplicate entries
setopt HIST_IGNORE_SPACE     # skip commands starting with space
setopt HIST_REDUCE_BLANKS    # trim extra whitespace

typeset -U path  # auto-deduplicate PATH entries
path=(
  "$HOME/.local/bin"
  $path
)

# --- Helper: cached eval (binary mtime invalidation) ---
# Usage: _cached_eval <cache_file> <command> [extra_deps...]
# Regenerates cache when binary or any extra dep file is newer than cache.
_cached_eval() {
  local cache="$1" cmd="$2"
  shift 2
  local bin_path="${commands[$cmd]}"
  local needs_regen=0

  if [[ ! -f "$cache" ]]; then
    needs_regen=1
  elif [[ -n "$bin_path" && "$bin_path" -nt "$cache" ]]; then
    needs_regen=1
  else
    for dep in "$@"; do
      if [[ -f "$dep" && "$dep" -nt "$cache" ]]; then
        needs_regen=1
        break
      fi
    done
  fi

  if (( needs_regen )); then
    # Caller sets _CACHED_EVAL_CMD to the full command to run
    eval "$_CACHED_EVAL_CMD" > "$cache"
  fi
  source "$cache"
}

# --- 2. mise — replaces nvm, pyenv, conda ---
if [[ "$OSTYPE" == darwin* ]]; then
  _CACHED_EVAL_CMD="mise activate zsh" _cached_eval ~/.cache/mise-init.zsh mise
else
  path=("$HOME/.local/share/mise/shims" $path)
fi

# --- 3. Sheldon — plugin manager ---
_CACHED_EVAL_CMD="sheldon source" _cached_eval ~/.cache/sheldon-source.zsh sheldon ~/.config/sheldon/plugins.toml

# --- 4. Starship prompt ---
if [[ "$OSTYPE" != darwin* ]]; then
  # Non-Mac: disable expensive modules (NFS, etc.)
  _starship_local=~/.cache/starship-local.toml
  if [[ ! -f "$_starship_local" ]] || [[ ~/.config/starship.toml -nt "$_starship_local" ]]; then
    sed -e '/^\[git_status\]$/a disabled = true' ~/.config/starship.toml > "$_starship_local"
  fi
  export STARSHIP_CONFIG="$_starship_local"
  unset _starship_local
fi
_CACHED_EVAL_CMD="starship init zsh" _cached_eval ~/.cache/starship-init.zsh starship ~/.config/starship.toml

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
_CACHED_EVAL_CMD="fzf --zsh" _cached_eval ~/.cache/fzf-init.zsh fzf
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

# --- 8. zoxide for smarter cd ---
_CACHED_EVAL_CMD="zoxide init zsh" _cached_eval ~/.cache/zoxide-init.zsh zoxide

# --- 9. Source secrets and common configs ---
. $HOME/.config/bashrc/secret
. $HOME/.config/bashrc/common
. $HOME/.config/bashrc/mutagen

# --- 10. Local overrides (not committed to git) ---
if [[ -f "$HOME/.config/bashrc/local" ]]; then
  . $HOME/.config/bashrc/local
fi

# --- 11. Worktrunk (wt) ---
_CACHED_EVAL_CMD="command wt config shell init zsh" _cached_eval ~/.cache/wt-init.zsh wt

# --- Recache: regenerate all cached init scripts ---
zsh-recache() {
  echo "Clearing cached init scripts..."
  rm -f ~/.cache/{mise-init,sheldon-source,starship-init,fzf-init,zoxide-init,wt-init}.zsh
  echo "Reloading shell..."
  exec zsh -l
}
unfunction _cached_eval 2>/dev/null

# Case-insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

