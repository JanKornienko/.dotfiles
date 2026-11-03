#!/usr/bin/env bash
# Claude Code statusline — sci-fi HUD, ASCII + ANSI 256-color
# Layout:  <<ctx:23%>> :: main :: [5h:41% | wk:12%] :: ram:62% dsk:81%

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

# --- host metrics -----------------------------------------------------------

ram_usage() {
  # macOS: used = active + wired + compressed, over hw.memsize
  local total page stats used
  total=$(sysctl -n hw.memsize 2>/dev/null) || return
  [ -n "$total" ] || return
  stats=$(vm_stat 2>/dev/null) || return
  page=$(echo "$stats" | awk 'NR==1{for(i=1;i<=NF;i++) if($i=="size"){print $(i+2); exit}}')
  [ -n "$page" ] || page=4096
  used=$(echo "$stats" | awk -v pg="$page" -v tot="$total" '
    /^Pages active/      {a=$3}
    /^Pages wired down/  {w=$4}
    /^Pages occupied by compressor/ {c=$5}
    END {
      gsub(/\./,"",a); gsub(/\./,"",w); gsub(/\./,"",c)
      if (tot <= 0) exit
      printf "%.0f", (a+w+c)*pg*100/tot
    }')
  echo "$used"
}

disk_usage() {
  local vol=/System/Volumes/Data
  [ -d "$vol" ] || vol=/
  df -Pk "$vol" 2>/dev/null | awk 'NR==2{gsub(/%/,"",$5); print $5}'
}

ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // .rate_limits.five_hour.reset_at // empty' 2>/dev/null)
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // .rate_limits.seven_day.reset_at // empty' 2>/dev/null)

model=$(echo "$input" | jq -r '.model.display_name // empty' 2>/dev/null | sed 's/ (.*//; s/Claude //I' | tr '[:upper:]' '[:lower:]')
effort=$(echo "$input" | jq -r '.effort.level // empty' 2>/dev/null)

ram_pct=$(ram_usage)
dsk_pct=$(disk_usage)

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

if [ -n "$ram_pct" ] || [ -n "$dsk_pct" ]; then
  host_str=""
  [ -n "$ram_pct" ] && host_str=$(fmt_pct "ram:" "$ram_pct")
  if [ -n "$dsk_pct" ]; then
    [ -n "$host_str" ] && host_str="${host_str}  "
    host_str="${host_str}$(fmt_pct "dsk:" "$dsk_pct")"
  fi
  out="${out}  ${C_SEP}::${C_RESET}  ${host_str}"
fi

printf '%b\n' "$out"
