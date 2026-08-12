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

# Latest release tag for a GitHub repo, without needing jq.
gh_latest() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" |
    sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1
}

# ---------------------------------------------------------------- packages
if [ "$OS" = linux ]; then
  log "apt packages"
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq
  sudo apt-get install -y -qq \
    zsh tmux git curl wget unzip tar ca-certificates \
    eza zoxide bat fd-find ripgrep jq \
    command-not-found build-essential python3-pip locales >/dev/null

  # Ubuntu ships these under alternate names.
  [ -x /usr/bin/batcat ] && ln -sf /usr/bin/batcat "$BIN/bat"
  [ -x /usr/bin/fdfind ] && ln -sf /usr/bin/fdfind "$BIN/fd"

  sudo locale-gen en_US.UTF-8 >/dev/null 2>&1 || true
else
  have brew || { echo "install Homebrew first"; exit 1; }
  log "brew packages"
  brew install -q zsh tmux eza zoxide bat fd ripgrep jq fzf neovim atuin navi thefuck || true
fi

# ---------------------------------------------------------------- binaries (linux only)
if [ "$OS" = linux ]; then
  # fzf — apt version is too old for `fzf --zsh` (needs >= 0.48)
  if ! have fzf || [ "$(fzf --version | cut -d. -f2)" -lt 48 ] 2>/dev/null; then
    log "fzf"
    v=$(gh_latest junegunn/fzf); v=${v#v}
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${v}/fzf-${v}-linux_amd64.tar.gz" |
      tar xz -C "$BIN"
  fi

  # neovim — apt version predates current LazyVim requirements
  if ! have nvim; then
    log "neovim"
    tmp=$(mktemp -d)
    url=https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    curl -fsSL "$url" | tar xz -C "$tmp" ||
      curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | tar xz -C "$tmp"
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
    curl -fsSL "https://github.com/atuinsh/atuin/releases/download/${v}/atuin-x86_64-unknown-linux-gnu.tar.gz" |
      tar xz -C "$tmp"
    find "$tmp" -name atuin -type f -exec install -m755 {} "$BIN/atuin" \;
    rm -rf "$tmp"
  fi

  # navi — interactive cheatsheets (Ctrl-G)
  if ! have navi; then
    log "navi"
    v=$(gh_latest denisidoro/navi)
    tmp=$(mktemp -d)
    curl -fsSL "https://github.com/denisidoro/navi/releases/download/${v}/navi-${v}-x86_64-unknown-linux-musl.tar.gz" |
      tar xz -C "$tmp"
    find "$tmp" -name navi -type f -exec install -m755 {} "$BIN/navi" \;
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

# ---------------------------------------------------------------- oh-my-zsh
ZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$ZSH_DIR" ]; then
  log "oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

CUSTOM="$ZSH_DIR/custom"
clone() { [ -d "$2" ] || git clone --depth=1 "$1" "$2"; }

log "zsh theme + plugins"
clone https://github.com/romkatv/powerlevel10k.git          "$CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions      "$CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting  "$CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/fdellwing/zsh-bat                  "$CUSTOM/plugins/zsh-bat"
clone https://github.com/MichaelAquilina/zsh-you-should-use "$CUSTOM/plugins/you-should-use"

# ---------------------------------------------------------------- symlinks
log "symlinks"
mkdir -p "$HOME/.config"
link() { [ -e "$1" ] && ln -sfn "$1" "$2"; }
link "$DOTFILES/.zshrc"        "$HOME/.zshrc"
link "$DOTFILES/.tmux.conf"    "$HOME/.tmux.conf"
link "$DOTFILES/.config/nvim"  "$HOME/.config/nvim"
link "$DOTFILES/.p10k.zsh"     "$HOME/.p10k.zsh"
chmod +x "$DOTFILES/.config/tmux/"*.sh 2>/dev/null || true

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
ZSH_BIN=$(command -v zsh)
if [ "${SHELL:-}" != "$ZSH_BIN" ]; then
  log "default shell -> zsh"
  sudo chsh -s "$ZSH_BIN" "$(whoami)" 2>/dev/null ||
    chsh -s "$ZSH_BIN" 2>/dev/null ||
    echo "  could not chsh — run: sudo chsh -s $ZSH_BIN $(whoami)"
fi

log "done. open a new shell (or run: exec zsh)"
