# ==========
# .ZPROFILE
# Login shells only. Keep this to PATH/env bootstrap — interactive config
# (prompt, aliases, plugins) belongs in .zshrc.
# ==========

# ---- Homebrew ----
# Checked in order: Apple Silicon, Intel macOS, Linuxbrew (system), Linuxbrew
# (per-user). `brew shellenv` sets HOMEBREW_PREFIX, PATH, MANPATH and INFOPATH,
# which .zshrc relies on to find things like nvm.
for _brew in \
  /opt/homebrew/bin/brew \
  /usr/local/bin/brew \
  /home/linuxbrew/.linuxbrew/bin/brew \
  "$HOME/.linuxbrew/bin/brew"
do
  if [ -x "$_brew" ]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew

# ---- user binaries ----
# install.sh drops standalone binaries (fzf, nvim, atuin, navi) here on Linux.
export PATH="$HOME/.local/bin:$PATH"

# ---- per-machine overrides ----
[ -f "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
