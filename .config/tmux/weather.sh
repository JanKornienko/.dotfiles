#!/usr/bin/env bash
# Weather segment for tmux status-right: Nerd Font condition icon + temp in C.
#
# Location  : auto-detected from public IP (ip-api.com), cached, refreshed
#             at most once per day.
# Weather   : open-meteo.com (no API key), cached, refreshed at most every 30m.
#             Falls back to wttr.in when open-meteo can't be reached -- some
#             hosts (e.g. datacenter/VPS egress) blackhole it, and then the
#             segment would silently stay empty forever.
# Non-blocking: tmux always gets the cached value instantly; stale data is
#             refreshed in a detached background job so the status bar never hangs.
#
# No data yet (first run / offline) -> prints nothing.

cache="$HOME/.cache/tmux-weather"
loc="$cache/location"      # line1: YYYY-MM-DD   line2: "lat lon"
wx="$cache/weather"        # "weather_code temperature"
lock="$cache/.refresh.lock"
mkdir -p "$cache"

# ---- location: pinned config wins over IP detection ----
# weather.conf pins the coordinates so every host reports the same place; see the
# comments there. The .local sibling is sourced second so a single host can
# override without touching the tracked file.
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
[ -f "$here/weather.conf" ] && . "$here/weather.conf"
[ -f "$HOME/.config/tmux/weather.local.conf" ] && . "$HOME/.config/tmux/weather.local.conf"

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

code_for_desc() { # wttr.in condition text -> nearest WMO code, so icon_for
                  # stays the single source of truth for glyphs.
                  # Order matters: "Light snow showers" must hit snow, not showers.
  case "$(printf '%s' "$1" | tr 'A-Z' 'a-z')" in
    *thunder*)                    echo 95 ;;
    *snow*|*sleet*|*blizzard*|*ice*) echo 71 ;;
    *shower*)                     echo 80 ;;
    *drizzle*)                    echo 51 ;;
    *rain*)                       echo 61 ;;
    *fog*|*mist*)                 echo 45 ;;
    *overcast*)                   echo 3 ;;
    *cloud*)                      echo 2 ;;
    *)                            echo 0 ;;  # sunny / clear
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
if [ -n "${WEATHER_LATLON:-}" ]; then
  # Pinned coordinates: keep the cache in sync without ever calling ip-api.
  # Rewritten only when it actually differs -- this runs on every status refresh.
  want="$today
$WEATHER_LATLON"
  [ "$(cat "$loc" 2>/dev/null)" = "$want" ] || printf '%s\n' "$want" > "$loc"
else
  [ -f "$loc" ] && [ "$(head -n1 "$loc" 2>/dev/null)" = "$today" ] || loc_stale=1
fi
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

  # ---- provider 1: open-meteo (WMO codes; weather + sun in one call) ----
  resp=$(curl -fs --max-time 5 \
    "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code&daily=sunrise,sunset&timezone=auto" 2>/dev/null)
  temp=$(printf '%s' "$resp" | grep -Eo '"temperature_2m":-?[0-9]+(\.[0-9]+)?' | head -n1 | cut -d: -f2)
  code=$(printf '%s' "$resp" | grep -Eo '"weather_code":[0-9]+' | head -n1 | cut -d: -f2)
  # sunrise/sunset are in the *location's* local time, so keep its UTC offset
  # too -- the server clock may be on a different zone (VPS on UTC).
  sr=$(printf '%s' "$resp" | grep -Eo '"sunrise":\["[0-9-]+T[0-9:]+' | head -n1 | sed 's/.*T//')
  ss=$(printf '%s' "$resp" | grep -Eo '"sunset":\["[0-9-]+T[0-9:]+'  | head -n1 | sed 's/.*T//')
  off=$(printf '%s' "$resp" | grep -Eo '"utc_offset_seconds":-?[0-9]+' | head -n1 | cut -d: -f2)

  # ---- provider 2: wttr.in, only if open-meteo gave us nothing ----
  # %t temp, %C condition text, %S sunrise, %s sunset, %T local time + offset.
  if [ -z "$temp" ] || [ -z "$code" ]; then
    resp=$(curl -fs --max-time 8 \
      "https://wttr.in/$lat,$lon?format=%t|%C|%S|%s|%T" 2>/dev/null)
    IFS='|' read -r w_temp w_cond w_sr w_ss w_now <<EOF
$resp
EOF
    # "+28<degree>C" -> "28"  (strip the sign and the multi-byte degree sign)
    temp=$(printf '%s' "$w_temp" | LC_ALL=C tr -cd '0-9.-')
    [ -n "$w_cond" ] && code=$(code_for_desc "$w_cond")
    sr=$(printf '%s' "$w_sr" | cut -c1-5)   # "06:02:14" -> "06:02"
    ss=$(printf '%s' "$w_ss" | cut -c1-5)
    # "14:30:50+0200" -> 7200
    hhmm=$(printf '%s' "$w_now" | grep -Eo '[+-][0-9]{4}$')
    if [ -n "$hhmm" ]; then
      off=$(( 10#$(printf '%s' "$hhmm" | cut -c2-3) * 3600 \
            + 10#$(printf '%s' "$hhmm" | cut -c4-5) * 60 ))
      [ "$(printf '%s' "$hhmm" | cut -c1)" = "-" ] && off=$(( -off ))
    fi
  fi

  [ -n "$temp" ] && [ -n "$code" ] && printf '%s %s\n' "$code" "$temp" > "$wx"

  # sun cache for suntimes.sh: "HH:MM HH:MM UTC_OFFSET_SECONDS" (location-local
  # times; the offset lets suntimes.sh work on a server in any timezone)
  [ -n "$sr" ] && [ -n "$ss" ] && printf '%s %s %s\n' "$sr" "$ss" "$off" > "$cache/sun"
) >/dev/null 2>&1 &
exit 0
