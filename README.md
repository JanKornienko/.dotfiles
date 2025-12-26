# Dotfiles

My personal dotfiles configuration for macOS.

## 📖 Documentation

Detailed configuration guides and key bindings are available in the [**Wiki**](https://github.com/jankornienko/.dotfiles/wiki):

- **[iTerm](https://github.com/jankornienko/.dotfiles/wiki/iTerm)** - Color schemes and installation
- **[Oh My Zsh](https://github.com/jankornienko/.dotfiles/wiki/Oh-My-Zsh)** - Shell configuration, theme, and plugins
- **[tmux](https://github.com/jankornienko/.dotfiles/wiki/tmux)** - Terminal multiplexer setup
- **[Neovim](https://github.com/jankornienko/.dotfiles/wiki/Neovim)** - Complete editor setup and key bindings

## 🚀 Quick Overview

### 🎨 iTerm Color Schemes

Available color schemes in `iterm/`:

- **Gruvbox** (Dark, Dark Hard, Light, Light Hard, Material)
- **Kanagawa** (Bones, Dragon, Wave)
- **One Dark Pro** (Night Flat)

[View installation instructions →](https://github.com/jankornienko/.dotfiles/wiki/iTerm)

### 🐚 Oh My Zsh

**Theme:** [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Fast and highly customizable

**Key Plugins:**

- `zsh-autosuggestions` - Fish-like autosuggestions
- `zsh-syntax-highlighting` - Real-time syntax highlighting
- `z` - Jump to frequently used directories
- `git` - Comprehensive Git aliases
- `you-should-use` - Alias reminders

[View all plugins and configuration →](https://github.com/jankornienko/.dotfiles/wiki/Oh-My-Zsh)

### 🖥️ tmux Configuration

**Prefix:** `Ctrl-B`

**Quick Keys:**

- `|` / `-` - Split panes (horizontal/vertical)
- `h/j/k/l` - Navigate panes (Vi-style)
- `Ctrl-h/j/k/l` - Seamless Neovim + tmux navigation
- `r` - Reload configuration

**Features:** Mouse support, Vi mode, Gruvbox theme, session persistence

[View all key bindings →](https://github.com/jankornienko/.dotfiles/wiki/tmux)

### 🚀 Neovim Configuration

**Leader Key:** `<Space>`

**Quick Keys:**

- `<leader>e` - File explorer (Neo-tree)
- `<leader>ff` - Find files (FZF)
- `<leader>fg` - Search in files
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>gv` - Git diff view

**Core Plugins:**

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) - File explorer
- [fzf-lua](https://github.com/ibhagwan/fzf-lua) - Fuzzy finder
- [gitsigns](https://github.com/lewis6991/gitsigns.nvim) - Git integration
- [diffview](https://github.com/sindrets/diffview.nvim) - Git diff viewer

**Features:** LSP support, auto-save, image rendering, tmux integration, Gruvbox theme

[View all key bindings and plugins →](https://github.com/jankornienko/.dotfiles/wiki/Neovim)

## 📦 Installation

### Prerequisites

```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install tmux and dependencies
brew install tmux neovim imagemagick chafa

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Setup

1. Clone this repository
2. Symlink configuration files to your home directory
3. Install tmux plugins: `Ctrl-B` + `I`
4. Configure Powerlevel10k: `p10k configure`
5. Install Neovim plugins: Open Neovim and run `:Lazy sync`

## 📚 Additional Resources

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [tmux](https://github.com/tmux/tmux)
- [Neovim](https://neovim.io/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)

## 📝 Notes

- Configuration uses Gruvbox Dark Hard theme across iTerm, tmux, and Neovim
- Seamless navigation between tmux panes and Neovim splits via `Ctrl-h/j/k/l`
- Image support in Neovim requires ImageMagick and chafa
- All configurations are managed with modern plugin managers (lazy.nvim for Neovim, TPM for tmux)

---

**For detailed configuration, key bindings, and usage instructions, visit the [Wiki](https://github.com/jankornienko/.dotfiles/wiki).**
