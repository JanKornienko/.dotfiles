#!/usr/bin/env bash
# Git branch (+ dirty marker) of a directory, for tmux status-left.
# Usage: gitinfo.sh "<path>"   (tmux passes #{pane_current_path})
# Prints nothing outside a git repo.

p="$1"
[ -d "$p" ] || exit 0
cd "$p" 2>/dev/null || exit 0

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
[ -n "$b" ] || exit 0

dirty=""
git diff --quiet --ignore-submodules HEAD 2>/dev/null || dirty="*"

emit() { awk -v c=$((16#$1)) 'BEGIN{printf "%c%c%c",224+int(c/4096),128+int(c/64)%64,128+c%64}'; }
emit e0a0                 # branch glyph
printf ' %s%s' "$b" "$dirty"
