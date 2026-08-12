#!/usr/bin/env bash
# Claude Code statusline — sci-fi HUD, ASCII + ANSI 256-color
# Layout:  <<ctx:23%>> :: main :: [5h:41% | wk:12%]

C_RESET='\033[0m'
C_SEP='\033[38;5;245m'      # gruvbox gray   (#928374)
C_LABEL='\033[38;5;108m'    # gruvbox aqua   (#8ec07c)
C_GREEN='\033[38;5;142m'    # gruvbox green  (#b8bb26)
C_AMBER='\033[38;5;172m'    # gruvbox yellow (#d79921)
C_RED='\033[38;5;167m'      # gruvbox red    (#fb4934 muted)
C_BRANCH='\033[38;5;175m'   # gruvbox purple (#d3869b)
C_MODEL='\033[38;5;109m'    # gruvbox blue   (#83a598)
C_EFFORT='\033[38;5;208m'   # gruvbox orange (#fe8019)

input=$(cat)

pct_color() {
  local p=$1
  if [ -z "$p" ] || ! echo "$p" | grep -qE '^[0-9]+(\.[0-9]+)?$'; then
    printf '%s' "$C_LABEL"
  elif awk "BEGIN{exit !($p >= 80)}"; then printf '%s' "$C_RED"
  elif awk "BEGIN{exit !($p >= 50)}"; then printf '%s' "$C_AMBER"
  else printf '%s' "$C_GREEN"
  fi
}

fmt_pct() {
  local label=$1 pct=$2 reset=$3 col r rstr=""
  col=$(pct_color "$pct")
  if [ -n "$reset" ] && [ "$reset" != "null" ]; then
    local epoch=""
    if echo "$reset" | grep -qE '^[0-9]+$'; then
      epoch=$reset
    else
      epoch=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" -u "$reset" "+%s" 2>/dev/null \
          || date -d "$reset" "+%s" 2>/dev/null)
    fi
    if [ -n "$epoch" ]; then
      local now diff fmt="+%H:%M"
      now=$(date "+%s")
      diff=$((epoch - now))
      [ "$diff" -gt 86400 ] && fmt="+%a %H:%M"
      rstr=$(date -r "$epoch" "$fmt" 2>/dev/null || date -d "@$epoch" "$fmt" 2>/dev/null)
      rstr=$(echo "$rstr" | tr '[:upper:]' '[:lower:]')
    fi
  fi
  if [ -n "$pct" ]; then
    r=$(printf '%.0f' "$pct" 2>/dev/null || echo "$pct")
    printf "${C_LABEL}%s${C_RESET}${col}%s%%${C_RESET}" "$label" "$r"
  else
    printf "${C_LABEL}%s${C_SEP}--${C_RESET}" "$label"
  fi
  [ -n "$rstr" ] && printf " ${C_SEP}↻%s${C_RESET}" "$rstr"
}

ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // .rate_limits.five_hour.reset_at // empty' 2>/dev/null)
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // .rate_limits.seven_day.reset_at // empty' 2>/dev/null)

model=$(echo "$input" | jq -r '.model.display_name // empty' 2>/dev/null | sed 's/ (.*//; s/Claude //I' | tr '[:upper:]' '[:lower:]')
effort=$(echo "$input" | jq -r '.effort.level // empty' 2>/dev/null)

cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty' 2>/dev/null)
branch=""
[ -n "$cwd" ] && branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

out=""
ctx_str=$(fmt_pct "ctx:" "$ctx_pct")
out="${out}${C_SEP}<<${C_RESET}${ctx_str}${C_SEP}>>${C_RESET}"

if [ -n "$model" ]; then
  out="${out}  ${C_SEP}::${C_RESET}  ${C_MODEL}${model}${C_RESET}"
  [ -n "$effort" ] && out="${out}${C_SEP}·${C_RESET}${C_EFFORT}${effort}${C_RESET}"
fi

if [ -n "$branch" ]; then
  out="${out}  ${C_SEP}::${C_RESET}  ${C_BRANCH} ${branch}${C_RESET}  ${C_SEP}::${C_RESET}"
fi

five_str=$(fmt_pct "5h:" "$five_pct" "$five_reset")
week_str=$(fmt_pct "wk:" "$week_pct" "$week_reset")
out="${out}  ${C_SEP}[${C_RESET}${five_str}  ${C_SEP}|${C_RESET}  ${week_str}${C_SEP}]${C_RESET}"

printf '%b\n' "$out"
