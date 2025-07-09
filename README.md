# .dotfiles

Personal dotfiles configuration with One Dark Pro Night Flat theme consistency across tmux, nvim, and terminal.

## Installation

```sh
cd ~
git clone git@github.com:JanKornienko/.dotfiles.git
cd .dotfiles
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
```

## 🖥️ Tmux Configuration

### Basic Usage

- **Prefix key**: `Ctrl + B`
- **Reload config**: `Prefix + r`

### Window Management

- **New window**: `Prefix + c`
- **Switch windows**: `Shift + ←/→` (no prefix needed)
- **Rename window**: `Prefix + ,`
- **Kill window**: `Prefix + &`

### Pane Management

- **Split horizontally**: `Prefix + -`
- **Split vertically**: `Prefix + |`
- **Navigate panes**: `Prefix + h/j/k/l` (vim-like)
- **Resize panes**: `Prefix + Ctrl + h/j/k/l`
- **Kill pane**: `Prefix + x`

### Session Management

- **Detach session**: `Prefix + d`
- **List sessions**: `tmux ls`
- **Attach session**: `tmux attach -t <session-name>`

### Mouse Support

- Mouse clicking, scrolling, and pane resizing are enabled

## 📝 Neovim Configuration

### Leader Key

- **Leader**: `Space`

### File Management

- **Toggle file tree**: `<leader>e`
- **Focus file tree**: `<leader>o`
- **Find files**: `<leader>ff`
- **Live grep (search in files)**: `<leader>fg`
- **Find buffers**: `<leader>fb`
- **Recent files**: `<leader>fr`
- **Find help**: `<leader>fh`

### Quick Actions

- **Save file**: `<leader>w`
- **Quit**: `<leader>q`
- **Save and quit**: `<leader>wq`
- **Clear search highlights**: `<leader>nh`

### Window Management

- **Split vertically**: `<leader>sv`
- **Split horizontally**: `<leader>sh`
- **Make splits equal**: `<leader>se`
- **Close split**: `<leader>sx`

### Buffer Management

- **Next buffer**: `<leader>bn`
- **Previous buffer**: `<leader>bp`
- **Delete buffer**: `<leader>bd`

### Navigation (Tmux Integration)

- **Move between vim/tmux panes**: `Ctrl + h/j/k/l`

### Telescope (File Search)

- **Navigate results**: `Ctrl + k/j` (in search mode)
- **Send to quickfix**: `Ctrl + q` (in search mode)

## 🎨 Theme

Both tmux and nvim use the **One Dark Pro Night Flat** colorscheme for a consistent dark theme experience.

### Colors

- **Background**: `#16191d` (dark)
- **Foreground**: `#abb2bf` (light grey)
- **Accent**: `#4aa5f0` (blue)
- **Selection**: `#3e4451` (grey)

## 🔧 Features

### Tmux

- ✅ Vim-like pane navigation
- ✅ Mouse support
- ✅ Custom split keybindings
- ✅ One Dark theme
- ✅ Plugin management with TPM

### Neovim

- ✅ Minimal configuration for quick edits
- ✅ File tree (nvim-tree)
- ✅ Fuzzy file search (Telescope)
- ✅ Syntax highlighting (Treesitter)
- ✅ Tmux integration
- ✅ One Dark Pro theme
