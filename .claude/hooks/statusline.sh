#!/bin/bash
# Claude Code status line (1 line). Reads session JSON on stdin.
# 🕐 clock · 🤖 model · effort 💭 · 📁 dir @ branch · 🧠 context% n/total · 📊 5h · 📆 7d
# Muted 256-color palette for dark terminals, no special font. Portable via $HOME.

input="$(cat)"

model="$(printf '%s' "$input" | jq -r '.model.display_name // "?"')"
dir="$(printf '%s' "$input" | jq -r '.workspace.current_dir // empty')"
[ -z "$dir" ] && dir="$PWD"
proj="$(basename "$dir")"
remain="$(printf '%s' "$input" | jq -r '.context_window.remaining_percentage // empty')"
cw_size="$(printf '%s' "$input" | jq -r '.context_window.context_window_size // empty')"
cw_in="$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // 0')"
cw_out="$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // 0')"
effort="$(printf '%s' "$input" | jq -r '.effort.level // empty')"
thinking="$(printf '%s' "$input" | jq -r 'if .thinking.enabled == null then "" else .thinking.enabled end')"
rl5="$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')"
rl7="$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')"

# Muted 256-color palette, easy on the eyes in dark terminals (same hues, low saturation)
C_GREEN=$'\033[38;5;108m'   # soft sage green
C_YELLOW=$'\033[38;5;179m'  # soft amber
C_RED=$'\033[38;5;174m'     # soft rose
C_GRAY=$'\033[38;5;245m'    # soft gray
C_WHITE=$'\033[38;5;252m'   # soft off-white
C_CYAN=$'\033[38;5;109m'    # muted teal
C_RESET=$'\033[0m'
SEP=" ${C_GRAY}·${C_RESET} "   # thin middle-dot separator, calmer than |

# model color by family, deep-muted tones for dark screens (256-color)
case "$(printf '%s' "$model" | tr '[:upper:]' '[:lower:]')" in
  *haiku*)  C_MODEL=$'\033[38;5;72m'  ;;   # muted sage
  *sonnet*) C_MODEL=$'\033[38;5;173m' ;;   # muted terracotta
  *opus*)   C_MODEL=$'\033[38;5;131m' ;;   # muted rose
  *)        C_MODEL="$C_CYAN"         ;;
esac

# git branch + dirty flag
branch="$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)"
git_part=""
if [ -n "$branch" ]; then
  dirty=""
  [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ] && dirty=" ${C_YELLOW}●${C_RESET}"
  git_part=" ${C_GRAY}@${C_RESET} ${C_GREEN}${branch}${C_RESET}${dirty}"
fi

# context remaining: dim bar + brighter % (green plenty / amber low / rose critical)
ctx_part=""
if [ -n "$remain" ]; then
  pct="$(printf '%.0f' "$remain")"
  # cc = % color (muted level color); bc = bar fill color (dimmer shade of same hue)
  if   [ "$pct" -le 15 ]; then cc="$C_RED";    bc=$'\033[38;5;095m'  # dim rose
  elif [ "$pct" -le 35 ]; then cc="$C_YELLOW"; bc=$'\033[38;5;101m'  # dim amber
  else cc="$C_GREEN";                          bc=$'\033[38;5;065m'; fi  # dim sage
  ce=$'\033[38;5;238m'                        # empty cells: very dim gray
  filled=$(( (pct * 7 + 50) / 100 ))          # 7-cell bar, rounded
  [ "$filled" -gt 7 ] && filled=7
  [ "$filled" -lt 0 ] && filled=0
  bar=""; i=0
  while [ "$i" -lt 7 ]; do
    if [ "$i" -lt "$filled" ]; then bar="${bar}${bc}█"; else bar="${bar}${ce}░"; fi
    i=$((i+1))
  done
  ctx_part="🧠 ${bar}${C_RESET} ${cc}${pct}%${C_RESET}"
  # append remaining/total tokens as numbers (e.g. 786k/1M) when we know the size
  if [ -n "$cw_size" ] && [ "$cw_size" -gt 0 ] 2>/dev/null; then
    used=$(( cw_in ))
    rem_tok=$(( cw_size - used )); [ "$rem_tok" -lt 0 ] && rem_tok=0
    hnum() { # humanize: <1000 as-is, <1M as k, else M
      local n="$1"
      if   [ "$n" -ge 1000000 ]; then awk "BEGIN{printf \"%.1fM\", $n/1000000}"
      elif [ "$n" -ge 1000 ];    then awk "BEGIN{printf \"%dk\", $n/1000}"
      else printf '%d' "$n"; fi
    }
    ctx_part="${ctx_part} ${C_GRAY}$(hnum "$rem_tok")/$(hnum "$cw_size") left${C_RESET}"
  fi
fi

# reasoning effort, color by intensity (absent if model doesn't support it)
effort_part=""
if [ -n "$effort" ]; then
  case "$effort" in
    low)    ec="$C_GRAY"  ;;
    medium) ec="$C_GREEN" ;;
    high)   ec="$C_YELLOW";;
    *)      ec="$C_MODEL" ;;   # xhigh/max -> model accent
  esac
  effort_part="${ec}${effort}${C_RESET}"
  # thinking indicator beside effort: [T] on, [NT] off
  if [ "$thinking" = "true" ]; then
    effort_part="${effort_part} ${C_GRAY}[T]${C_RESET}"
  elif [ "$thinking" = "false" ]; then
    effort_part="${effort_part} ${C_GRAY}[NT]${C_RESET}"
  fi
fi

# rate limit helper: emoji + label + colored used%
rlfmt() { # $1=pct $2=emoji $3=label
  local p="$(printf '%.0f' "$1")" c
  if   [ "$p" -ge 85 ]; then c="$C_RED"
  elif [ "$p" -ge 60 ]; then c="$C_YELLOW"
  else c="$C_GREEN"; fi
  printf '%s %s %s%s%%%s' "$2" "$3" "$c" "$p" "$C_RESET"
}
rl5_part=""; [ -n "$rl5" ] && rl5_part="$(rlfmt "$rl5" "📊" "5h")"
rl7_part=""; [ -n "$rl7" ] && rl7_part="$(rlfmt "$rl7" "📆" "7d")"

# wall clock
clock_part="🕐 ${C_WHITE}$(date +%H:%M)${C_RESET}"

# one line: clock · model · effort · dir+branch · context · 5h · 7d
line="${clock_part}${SEP}${C_MODEL}🤖 ${model}${C_RESET}"
add() { [ -n "$1" ] && line="${line}${SEP}$1"; }
add "$effort_part"
line="${line}${SEP}📁 ${proj}${git_part}"
add "$ctx_part"; add "$rl5_part"; add "$rl7_part"

printf '%s' "$line"
