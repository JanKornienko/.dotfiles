#!/usr/bin/env bash
# Dotfiles bootstrap. Idempotent — safe to re-run.
# Works on Ubuntu/Debian (Coder workspaces, remote boxes) and macOS (Homebrew).
# Coder runs this automatically via `coder dotfiles <repo>`.
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BIN="$HOME/.local/bin"
mkdir -p "$BIN"
export PATH="$BIN:$PATH"

log() { printf '\033[1;33m==>\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

case "$(uname -s)" in
  Linux)  OS=linux ;;
  Darwin) OS=macos ;;
  *) echo "unsupported OS"; exit 1 ;;
esac

# Release assets were x86_64-only below, which broke every ARM box (Graviton /
# Ampere cloud VMs, Ubuntu on Apple Silicon). Four naming conventions are in
# play, so each gets its own variable rather than one guessed string:
#   ARCH        atuin, delta      aarch64        / x86_64
#   GOARCH      fzf               arm64          / amd64
#   NVIM_ARCH   neovim            arm64          / x86_64
#   NAVI_TRIPLE navi              …-linux-gnu    / …-linux-musl  (differs by arch)
case "$(uname -m)" in
  x86_64|amd64)
    ARCH=x86_64;  GOARCH=amd64; NVIM_ARCH=x86_64
    NAVI_TRIPLE=x86_64-unknown-linux-musl ;;
  aarch64|arm64)
    ARCH=aarch64; GOARCH=arm64; NVIM_ARCH=arm64
    NAVI_TRIPLE=aarch64-unknown-linux-gnu ;;
  *) echo "unsupported architecture: $(uname -m)"; exit 1 ;;
esac

# Root in a container has no sudo and needs none; a locked-down box may have no
# sudo at all, in which case package installs are skipped rather than fatal.
SUDO=""
CAN_INSTALL_PKGS=1
if [ "$(id -u)" = 0 ]; then
  :                       # already root
elif have sudo; then
  SUDO="sudo"
else
  CAN_INSTALL_PKGS=0
  log "no sudo and not root — skipping system packages"
fi

# Latest release tag for a GitHub repo, without needing jq.
gh_latest() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" |
    sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1
}

# ---------------------------------------------------------------- packages
if [ "$OS" = linux ]; then
  if [ "$CAN_INSTALL_PKGS" = 1 ]; then
    log "apt packages"
    export DEBIAN_FRONTEND=noninteractive
    $SUDO apt-get update -qq
    # git-delta backs the pager configured in .gitconfig. eza and git-delta are
    # missing from Ubuntu < 24.04 (noble); `|| true` on the second call keeps a
    # single unavailable package from aborting the whole run.
    $SUDO apt-get install -y -qq \
      zsh tmux git curl wget unzip tar ca-certificates \
      zoxide bat fd-find ripgrep jq \
      command-not-found build-essential python3-pip locales >/dev/null
    $SUDO apt-get install -y -qq eza git-delta >/dev/null 2>&1 || true

    # Ubuntu ships these under alternate names.
    [ -x /usr/bin/batcat ] && ln -sf /usr/bin/batcat "$BIN/bat"
    [ -x /usr/bin/fdfind ] && ln -sf /usr/bin/fdfind "$BIN/fd"

    $SUDO locale-gen en_US.UTF-8 >/dev/null 2>&1 || true
  fi
else
  have brew || { echo "install Homebrew first"; exit 1; }
  log "brew packages"
  brew install -q zsh tmux eza zoxide bat fd ripgrep jq fzf neovim atuin navi thefuck git-delta || true
  # Powerlevel10k draws its separators and icons from a Nerd Font. Without one
  # the prompt renders as tofu boxes — set the font in iTerm/Terminal after this.
  brew install -q --cask font-meslo-lg-nerd-font || true
fi

# ---------------------------------------------------------------- binaries (linux only)
if [ "$OS" = linux ]; then
  # fzf — apt version is too old for `fzf --zsh` (needs >= 0.48)
  if ! have fzf || [ "$(fzf --version | cut -d. -f2)" -lt 48 ] 2>/dev/null; then
    log "fzf"
    v=$(gh_latest junegunn/fzf); v=${v#v}
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${v}/fzf-${v}-linux_${GOARCH}.tar.gz" |
      tar xz -C "$BIN"
  fi

  # neovim — apt version predates current LazyVim requirements
  if ! have nvim; then
    log "neovim"
    tmp=$(mktemp -d)
    base=https://github.com/neovim/neovim/releases/latest/download
    # Assets are nvim-linux-x86_64.tar.gz / nvim-linux-arm64.tar.gz. The old
    # nvim-linux64.tar.gz fallback is gone from current releases.
    curl -fsSL "$base/nvim-linux-${NVIM_ARCH}.tar.gz" | tar xz -C "$tmp"
    rm -rf "$HOME/.local/nvim"
    mv "$tmp"/nvim-linux* "$HOME/.local/nvim"
    ln -sf "$HOME/.local/nvim/bin/nvim" "$BIN/nvim"
    rm -rf "$tmp"
  fi

  # atuin — shell history sync (Ctrl-R)
  if ! have atuin; then
    log "atuin"
    v=$(gh_latest atuinsh/atuin)
    tmp=$(mktemp -d)
    curl -fsSL "https://github.com/atuinsh/atuin/releases/download/${v}/atuin-${ARCH}-unknown-linux-gnu.tar.gz" |
      tar xz -C "$tmp"
    find "$tmp" -name atuin -type f -exec install -m755 {} "$BIN/atuin" \;
    rm -rf "$tmp"
  fi

  # navi — interactive cheatsheets (Ctrl-G)
  if ! have navi; then
    log "navi"
    v=$(gh_latest denisidoro/navi)
    tmp=$(mktemp -d)
    # Upstream ships musl for x86_64 but gnu for aarch64 — see NAVI_TRIPLE.
    curl -fsSL "https://github.com/denisidoro/navi/releases/download/${v}/navi-${v}-${NAVI_TRIPLE}.tar.gz" |
      tar xz -C "$tmp"
    find "$tmp" -name navi -type f -exec install -m755 {} "$BIN/navi" \;
    rm -rf "$tmp"
  fi

  # git-delta — pager configured in .gitconfig. Present in apt only from Ubuntu
  # 24.04 on, so fall back to the release tarball.
  if ! have delta; then
    log "git-delta"
    v=$(gh_latest dandavison/delta)
    tmp=$(mktemp -d)
    curl -fsSL "https://github.com/dandavison/delta/releases/download/${v}/delta-${v}-${ARCH}-unknown-linux-gnu.tar.gz" |
      tar xz -C "$tmp" || true
    find "$tmp" -name delta -type f -exec install -m755 {} "$BIN/delta" \; 2>/dev/null || true
    rm -rf "$tmp"
  fi
  # NOTE: thefuck is skipped on Linux — it is broken under Python 3.12.
  # .zshrc guards the eval, so nothing breaks by its absence.
fi

# ---------------------------------------------------------------- claude code
if ! have claude; then
  log "claude code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

# ---------------------------------------------------------------- symlinks
# Runs before oh-my-zsh on purpose. Its installer writes a template .zshrc when
# it finds none, which the link below would then shove aside as .zshrc.bak —
# junk on every fresh machine. With ours already in place, KEEP_ZSHRC=yes makes
# the installer leave it alone.
log "symlinks"

# Replacing a pre-existing real file (a machine's own .gitconfig, for instance)
# with a symlink used to discard it silently. Move it aside first — once, so
# re-running never overwrites the first backup.
link() {
  local src=$1 dst=$2
  [ -e "$src" ] || return 0
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    if [ ! -e "$dst.bak" ]; then
      mv "$dst" "$dst.bak"
      log "  backed up $dst -> $dst.bak"
    else
      rm -rf "$dst"
    fi
  fi
  ln -sfn "$src" "$dst"
}

mkdir -p "$HOME/.config"
link "$DOTFILES/.zshrc"                   "$HOME/.zshrc"
link "$DOTFILES/.zprofile"                "$HOME/.zprofile"
link "$DOTFILES/.p10k.zsh"                "$HOME/.p10k.zsh"
link "$DOTFILES/.tmux.conf"               "$HOME/.tmux.conf"
link "$DOTFILES/.gitconfig"               "$HOME/.gitconfig"
link "$DOTFILES/.config/nvim"             "$HOME/.config/nvim"
link "$DOTFILES/.config/git/ignore"       "$HOME/.config/git/ignore"
link "$DOTFILES/.config/htop/htoprc"      "$HOME/.config/htop/htoprc"
link "$DOTFILES/.config/atuin/config.toml" "$HOME/.config/atuin/config.toml"
link "$DOTFILES/.config/gh/config.yml"    "$HOME/.config/gh/config.yml"
chmod +x "$DOTFILES/.config/tmux/"*.sh 2>/dev/null || true

# ---------------------------------------------------------------- claude code
# Appearance and tooling only -- see claude/README.md for what is deliberately
# left out (plugin cache, session state, ~/.claude.json).
link "$DOTFILES/claude/settings.json"     "$HOME/.claude/settings.json"
link "$DOTFILES/claude/statusline.sh"     "$HOME/.claude/statusline.sh"
link "$DOTFILES/claude/keybindings.json"  "$HOME/.claude/keybindings.json"
chmod +x "$DOTFILES/claude/statusline.sh" 2>/dev/null || true

# Skills: the real content lives in ~/.agents/skills, and ~/.claude/skills holds
# relative symlinks into it. Link the store, then recreate one link per skill so
# Claude Code discovers them -- and so installing a skill on either machine shows
# up as a change in this repo.
link "$DOTFILES/agents" "$HOME/.agents"
if [ -d "$DOTFILES/agents/skills" ]; then
  mkdir -p "$HOME/.claude/skills"
  for s in "$DOTFILES/agents/skills"/*/; do
    [ -d "$s" ] || continue
    n=$(basename "$s")
    ln -sfn "../../.agents/skills/$n" "$HOME/.claude/skills/$n"
  done
fi

# ---------------------------------------------------------------- git identity
# .gitconfig includes this file; it stays out of the repo so no email address is
# committed. Prompts only when attached to a terminal — unattended runs (Coder
# provisioning) get a commented stub to fill in later.
GITLOCAL="$HOME/.gitconfig.local"
if [ ! -f "$GITLOCAL" ]; then
  log "git identity -> $GITLOCAL"
  if [ -t 0 ]; then
    printf '  name  : '; read -r _gname
    printf '  email : '; read -r _gmail
  fi
  if [ -n "${_gname:-}" ] && [ -n "${_gmail:-}" ]; then
    printf '[user]\n\tname = %s\n\temail = %s\n' "$_gname" "$_gmail" > "$GITLOCAL"
  else
    printf '# Fill in, then git will pick it up (included from ~/.gitconfig).\n[user]\n#\tname = \n#\temail = \n' > "$GITLOCAL"
    log "  no input — stub written, edit it before committing"
  fi
fi

# ---------------------------------------------------------------- oh-my-zsh
clone() { [ -d "$2" ] || git clone --depth=1 "$1" "$2"; }

ZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$ZSH_DIR" ]; then
  log "oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

CUSTOM="$ZSH_DIR/custom"
log "zsh theme + plugins"
clone https://github.com/romkatv/powerlevel10k.git          "$CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions      "$CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting  "$CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/fdellwing/zsh-bat                  "$CUSTOM/plugins/zsh-bat"
clone https://github.com/MichaelAquilina/zsh-you-should-use "$CUSTOM/plugins/you-should-use"

# ---------------------------------------------------------------- tmux plugins
TPM="$HOME/.tmux/plugins/tpm"
clone https://github.com/tmux-plugins/tpm "$TPM"
log "tmux plugins"
"$TPM/bin/install_plugins" >/dev/null 2>&1 || true

# ---------------------------------------------------------------- neovim plugins
if have nvim; then
  log "neovim plugins (lazy sync)"
  nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || true
fi

# ---------------------------------------------------------------- default shell
ZSH_BIN=$(command -v zsh || true)
if [ -n "$ZSH_BIN" ] && [ "${SHELL:-}" != "$ZSH_BIN" ]; then
  log "default shell -> zsh"
  ${SUDO:+$SUDO} chsh -s "$ZSH_BIN" "$(whoami)" 2>/dev/null ||
    chsh -s "$ZSH_BIN" 2>/dev/null ||
    echo "  could not chsh — run: sudo chsh -s $ZSH_BIN $(whoami)"
fi

log "done. open a new shell (or run: exec zsh)"
