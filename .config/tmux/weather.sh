#!/usr/bin/env bash
# Weather segment for tmux status-right: Nerd Font condition icon + temp in C.
#
# Location  : auto-detected from public IP (ip-api.com), cached, refreshed
#             at most once per day.
# Weather   : open-meteo.com (no API key), cached, refreshed at most every 30m.
# Non-blocking: tmux always gets the cached value instantly; stale data is
#             refreshed in a detached background job so the status bar never hangs.
#
# No data yet (first run / offline) -> prints nothing.

cache="$HOME/.cache/tmux-weather"
loc="$cache/location"      # line1: YYYY-MM-DD   line2: "lat lon"
wx="$cache/weather"        # "weather_code temperature"
lock="$cache/.refresh.lock"
mkdir -p "$cache"

emit() { # hex codepoint (U+0800..U+FFFF) -> UTF-8 bytes
  awk -v c=$((16#$1)) 'BEGIN{printf "%c%c%c",224+int(c/4096),128+int(c/64)%64,128+c%64}'
}

icon_for() { # WMO weather_code -> Nerd Font wi codepoint
  case "$1" in
    0)                              emit e30d ;; # clear
    1|2)                            emit e302 ;; # partly cloudy
    3)                              emit e312 ;; # overcast
    45|48)                          emit e313 ;; # fog
    51|53|55|56|57|61|63|65|66|67)  emit e318 ;; # drizzle / rain
    71|73|75|77|85|86)              emit e31a ;; # snow
    80|81|82)                       emit e319 ;; # rain showers
    95|96|99)                       emit e31d ;; # thunderstorm
    *)                              emit e30d ;;
  esac
}

# ---- print cached value (instant) ----
if [ -f "$wx" ]; then
  read -r code temp < "$wx"
  if [ -n "$temp" ]; then
    icon_for "$code"
    printf ' %.0f' "$temp"
    printf '\302\260C'                       # degree sign + C
  fi
fi

# ---- decide whether a refresh is due ----
today=$(date +%Y-%m-%d)
loc_stale=0; wx_stale=0
[ -f "$loc" ] && [ "$(head -n1 "$loc" 2>/dev/null)" = "$today" ] || loc_stale=1
[ -f "$wx" ] && [ -z "$(find "$wx" -mmin +30 2>/dev/null)" ] || wx_stale=1
[ "$loc_stale" = 0 ] && [ "$wx_stale" = 0 ] && exit 0

# ---- detached background refresh (single-flight via lock dir) ----
# Drop a stale lock first: a refresh killed by SIGHUP (ssh disconnect, crash)
# never runs its EXIT trap, and the leftover dir would block refreshes forever.
[ -d "$lock" ] && [ -n "$(find "$lock" -maxdepth 0 -mmin +5 2>/dev/null)" ] && rmdir "$lock" 2>/dev/null
mkdir "$lock" 2>/dev/null || exit 0   # another refresh already running
(
  trap 'rmdir "$lock" 2>/dev/null' EXIT
  trap '' HUP   # survive ssh disconnect; the refresh is short (<10s)

  if [ "$loc_stale" = 1 ]; then
    d=$(curl -fs --max-time 5 'http://ip-api.com/json/?fields=lat,lon' 2>/dev/null)
    lat=$(printf '%s' "$d" | grep -o '"lat":[-0-9.]*' | cut -d: -f2)
    lon=$(printf '%s' "$d" | grep -o '"lon":[-0-9.]*' | cut -d: -f2)
    [ -n "$lat" ] && [ -n "$lon" ] && printf '%s\n%s %s\n' "$today" "$lat" "$lon" > "$loc"
  fi

  [ -f "$loc" ] || exit 0
  coords=$(sed -n 2p "$loc"); lat=${coords%% *}; lon=${coords##* }
  [ -n "$lat" ] && [ -n "$lon" ] || exit 0

  resp=$(curl -fs --max-time 5 \
    "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code&daily=sunrise,sunset&timezone=auto" 2>/dev/null)
  temp=$(printf '%s' "$resp" | grep -Eo '"temperature_2m":-?[0-9]+(\.[0-9]+)?' | head -n1 | cut -d: -f2)
  code=$(printf '%s' "$resp" | grep -Eo '"weather_code":[0-9]+' | head -n1 | cut -d: -f2)
  [ -n "$temp" ] && [ -n "$code" ] && printf '%s %s\n' "$code" "$temp" > "$wx"

  # daily sunrise/sunset (local time, "HH:MM HH:MM") for suntimes.sh
  sr=$(printf '%s' "$resp" | grep -Eo '"sunrise":\["[0-9-]+T[0-9:]+' | head -n1 | sed 's/.*T//')
  ss=$(printf '%s' "$resp" | grep -Eo '"sunset":\["[0-9-]+T[0-9:]+'  | head -n1 | sed 's/.*T//')
  [ -n "$sr" ] && [ -n "$ss" ] && printf '%s %s\n' "$sr" "$ss" > "$cache/sun"
) >/dev/null 2>&1 &
exit 0
