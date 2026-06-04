#!/usr/bin/env bash
# Time-of-day icon for tmux status-right.
# Sun glyphs by hour (Nerd Font weather icons); real moon phase at night.
# Codepoints are stored as hex and encoded to UTF-8 at runtime, so this file
# stays pure-ASCII (editors / tools won't strip the Private-Use glyphs).
# Wrong/blank glyph? Edit the hex codes below (Nerd Font cheat sheet: nf-weather).

# Encode a hex Unicode codepoint (e.g. e34c) in the U+0800..U+FFFF range to UTF-8.
emit() {
  awk -v c=$((16#$1)) 'BEGIN{
    printf "%c%c%c", 224+int(c/4096), 128+int(c/64)%64, 128+c%64
  }'
}

h=$((10#$(date +%H)))

if   [ "$h" -ge 5 ]  && [ "$h" -lt 8 ];  then emit e34c   # dawn / sunrise
elif [ "$h" -ge 8 ]  && [ "$h" -lt 11 ]; then emit e30d   # morning sun
elif [ "$h" -ge 11 ] && [ "$h" -lt 16 ]; then emit e36b   # midday (hot)
elif [ "$h" -ge 16 ] && [ "$h" -lt 19 ]; then emit e34d   # sunset
elif [ "$h" -ge 19 ] && [ "$h" -lt 21 ]; then emit e32e   # dusk (night clear)
else
  # Night: compute moon phase (0=new .. 4=full .. ) and pick a glyph.
  now=$(date +%s)
  ref=947182440            # 2000-01-06 18:14 UTC, a known new moon (epoch sec)
  syn=2551442.861          # synodic month in seconds (29.530588853 * 86400)
  idx=$(awk -v n="$now" -v r="$ref" -v s="$syn" \
        'BEGIN{a=((n-r)%s)/s; if(a<0)a+=1; print int(a*8+0.5)%8}')
  # 8 Nerd Font wi-moon-alt codepoints: new -> waxing -> full -> waning
  moons=(e3e0 e3e3 e3e7 e3ea e3ee e3f1 e3f5 e3f8)
  emit "${moons[$idx]}"
fi
