#!/usr/bin/env bash
# Git status for tmux status-right, powerline / k9s style.
# Usage: gitinfo.sh "<path>"   (tmux passes #{pane_current_path})
#
# Output:  <branch>  ⇡ahead ⇣behind ✕conflicts ●staged ✚modified …untracked ⚑stash
# Only non-zero counters are shown. Color codes (#[fg=..]) are embedded so tmux
# renders each counter in its own color. Prints nothing outside a git repo.

p="$1"
[ -d "$p" ] || exit 0
cd "$p" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
[ -n "$b" ] || exit 0

# ahead / behind vs upstream
ahead=0; behind=0
if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  set -- $(git rev-list --left-right --count '@{u}...HEAD' 2>/dev/null)
  behind=${1:-0}; ahead=${2:-0}
fi

# working-tree counts from porcelain (col1 = index/staged, col2 = worktree)
porc=$(git status --porcelain 2>/dev/null)
staged=$(printf '%s\n'   "$porc" | grep -c '^[MARCD]')
modified=$(printf '%s\n' "$porc" | grep -c '^.[MD]')
untracked=$(printf '%s\n' "$porc" | grep -c '^??')
conflict=$(printf '%s\n' "$porc" | grep -cE '^(DD|AU|UD|UA|DU|AA|UU)')
stash=$(git stash list 2>/dev/null | grep -c '')

emit() { awk -v c=$((16#$1)) 'BEGIN{printf "%c%c%c",224+int(c/4096),128+int(c/64)%64,128+c%64}'; }

emit e0a0; printf ' %s' "$b"                                    # branch
[ "$ahead"     -gt 0 ] && printf '#[fg=#b8bb26] \342\207\241%s' "$ahead"      # ⇡ ahead
[ "$behind"    -gt 0 ] && printf '#[fg=#fb4934] \342\207\243%s' "$behind"     # ⇣ behind
[ "$conflict"  -gt 0 ] && printf '#[fg=#fb4934] \342\234\225%s' "$conflict"   # ✕ conflict
[ "$staged"    -gt 0 ] && printf '#[fg=#b8bb26] \342\227\217%s' "$staged"     # ● staged
[ "$modified"  -gt 0 ] && printf '#[fg=#fabd2f] \342\234\232%s' "$modified"   # ✚ modified
[ "$untracked" -gt 0 ] && printf '#[fg=#83a598] \342\200\246%s' "$untracked"  # … untracked
[ "$stash"     -gt 0 ] && printf '#[fg=#8ec07c] \342\232\221%s' "$stash"      # ⚑ stash
