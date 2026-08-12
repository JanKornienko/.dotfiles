#!/usr/bin/env bash
# Next sun event (sunrise OR sunset, whichever comes next) for tmux status-right.
# Reads the cache written by weather.sh (no own network call). Prints nothing
# until weather.sh has populated it.
#
# The cached times are in the *location's* local time. When weather.sh also
# recorded that location's UTC offset (3rd field), "now" is derived from UTC
# instead of the server clock -- otherwise a server in a different timezone
# (e.g. a VPS on UTC) would pick the wrong next event.

f="$HOME/.cache/tmux-weather/sun"
[ -f "$f" ] || exit 0
read -r sr ss off < "$f"
[ -n "$sr" ] && [ -n "$ss" ] || exit 0

emit() { awk -v c=$((16#$1)) 'BEGIN{printf "%c%c%c",224+int(c/4096),128+int(c/64)%64,128+c%64}'; }
mins() { IFS=: read -r h m <<EOF
$1
EOF
  echo $((10#$h * 60 + 10#$m)); }

case "$off" in
  -[0-9]*|[0-9]*) now=$(( ( $(mins "$(date -u +%H:%M)") + off / 60 ) % 1440 ))
                  now=$(( (now + 1440) % 1440 )) ;;   # negative offsets
  *)              now=$(mins "$(date +%H:%M)") ;;     # no offset cached: server clock
esac

if   [ "$now" -lt "$(mins "$sr")" ]; then emit e34c; printf ' %s' "$sr"   # before sunrise -> sunrise
elif [ "$now" -lt "$(mins "$ss")" ]; then emit e34d; printf ' %s' "$ss"   # daytime -> sunset
else                                      emit e34c; printf ' %s' "$sr"   # after sunset -> next sunrise
fi
