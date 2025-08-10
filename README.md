# 🚀 Custom Keybindings from .dotfiles

A comprehensive reference for all custom shortcuts and keybindings defined in your `.dotfiles` configuration.

## 📚 Table of Contents

- [Neovim](#neovim)
- [Tmux](#tmux)
- [Zsh](#zsh)
- [FZF](#fzf)

---

## 🎯 Neovim

### Leader Key

- `<Space>` - Leader key
- `\` - Local leader key

### Window Management

| Shortcut     | Action   | Description               |
| ------------ | -------- | ------------------------- |
| `<leader>sv` | `<C-w>v` | Split window vertically   |
| `<leader>sh` | `<C-w>s` | Split window horizontally |
| `<leader>se` | `<C-w>=` | Make splits equal size    |
| `<leader>sx` | `:close` | Close current split       |

### Buffer Management

| Shortcut     | Action       | Description     |
| ------------ | ------------ | --------------- |
| `<leader>bn` | `:bnext`     | Next buffer     |
| `<leader>bp` | `:bprevious` | Previous buffer |
| `<leader>bd` | `:bdelete`   | Delete buffer   |

### File Operations

| Shortcut     | Action | Description   |
| ------------ | ------ | ------------- |
| `<leader>s`  | `:w`   | Save file     |
| `<leader>q`  | `:q`   | Quit          |
| `<leader>sq` | `:wq`  | Save and quit |

### Search & Navigation

| Shortcut     | Action  | Description             |
| ------------ | ------- | ----------------------- |
| `<leader>nh` | `:nohl` | Clear search highlights |

### File Explorer (Neo-tree)

| Shortcut     | Action                  | Description                          |
| ------------ | ----------------------- | ------------------------------------ |
| `<leader>e`  | Toggle Neo-tree         | Toggle file explorer (filesystem)    |
| `<leader>bf` | Toggle Neo-tree float   | Toggle file explorer in float window |
| `<leader>bs` | Toggle Neo-tree sidebar | Toggle file explorer in left sidebar |

#### Neo-tree Navigation

| Shortcut  | Action                  |
| --------- | ----------------------- |
| `<space>` | Toggle node             |
| `<cr>`    | Open file               |
| `P`       | Toggle preview          |
| `l`       | Focus preview           |
| `S`       | Open split              |
| `s`       | Open vsplit             |
| `t`       | Open in new tab         |
| `w`       | Open with window picker |
| `a`       | Add file                |
| `A`       | Add directory           |
| `d`       | Delete                  |
| `r`       | Rename                  |
| `y`       | Copy to clipboard       |
| `x`       | Cut to clipboard        |
| `p`       | Paste from clipboard    |
| `q`       | Close window            |
| `R`       | Refresh                 |
| `?`       | Show help               |

#### Neo-tree Filesystem

| Shortcut | Action                 |
| -------- | ---------------------- |
| `<bs>`   | Navigate up            |
| `.`      | Set root               |
| `H`      | Toggle hidden files    |
| `/`      | Fuzzy finder           |
| `D`      | Fuzzy finder directory |
| `#`      | Fuzzy sorter           |
| `f`      | Filter on submit       |
| `<c-x>`  | Clear filter           |
| `[g`     | Previous git modified  |
| `]g`     | Next git modified      |

### FZF Integration

| Shortcut     | Action                   | Description                  |
| ------------ | ------------------------ | ---------------------------- |
| `<leader>ff` | Find files               | Search for files             |
| `<leader>fg` | Live grep                | Search in files              |
| `<leader>fb` | Find buffers             | Search buffers               |
| `<leader>fh` | Help tags                | Search help                  |
| `<leader>fc` | Command history          | Search command history       |
| `<leader>fs` | Search word under cursor | Search for word under cursor |
| `<leader>fl` | Search lines             | Search lines in buffers      |
| `<leader>ft` | Find tabs                | Search tabs                  |
| `<leader>fd` | Document diagnostics     | Show document diagnostics    |
| `<leader>fw` | Workspace diagnostics    | Show workspace diagnostics   |

#### FZF Actions

| Shortcut | Action    |
| -------- | --------- |
| `<cr>`   | Edit file |
| `ctrl-s` | Split     |
| `ctrl-v` | Vsplit    |
| `ctrl-t` | Tab edit  |

### Which-Key

| Shortcut    | Action       | Description                  |
| ----------- | ------------ | ---------------------------- |
| `<leader>?` | Show keymaps | Display buffer local keymaps |

---

## 🖥️ Tmux

### Configuration Reload

| Shortcut    | Action             |
| ----------- | ------------------ |
| `<Prefix>r` | Reload tmux config |

### Mouse Control

- Mouse enabled for clickable windows, panes, and resizable panes

### Pane Navigation

| Shortcut | Action            |
| -------- | ----------------- |
| `h`      | Select left pane  |
| `j`      | Select down pane  |
| `k`      | Select up pane    |
| `l`      | Select right pane |

### Pane Splitting

| Shortcut | Action                  |
| -------- | ----------------------- |
| `\|`     | Split pane vertically   |
| `-`      | Split pane horizontally |

### Window Navigation

| Shortcut      | Action          |
| ------------- | --------------- |
| `Shift+Left`  | Previous window |
| `Shift+Right` | Next window     |

### Indexing

- Windows start from index 1
- Panes start from index 1

### Plugins

- **tpm**: Plugin manager
- **tmux-sensible**: Sensible defaults
- **tmux-resurrect**: Session persistence
- **tmux-continuum**: Automatic restore
- **tmux-yank**: Copy to clipboard
- **vim-tmux-navigator**: Seamless navigation between vim and tmux

---

## 🐚 Zsh

### Aliases

| Alias | Command  | Description                     |
| ----- | -------- | ------------------------------- |
| `vim` | `nvim`   | Use Neovim instead of Vim       |
| `la`  | `ls -a`  | List all files including hidden |
| `lla` | `ls -la` | List all files with details     |

### FZF Integration

| Shortcut | Action             |
| -------- | ------------------ |
| `Ctrl+F` | FZF file finder    |
| `Ctrl+R` | FZF history search |

### FZF Functions

| Function          | Action                             | Description                           |
| ----------------- | ---------------------------------- | ------------------------------------- |
| `fzf_file_finder` | File search with bat preview       | Search files with syntax highlighting |
| `fzf_dir_finder`  | Directory search with tree preview | Search directories with tree view     |

### FZF Configuration

- **Theme**: Gruvbox dark colors
- **Preview**: Bat syntax highlighting for files
- **Preview**: Tree view for directories
- **Bindings**:
  - `ctrl-v`: Open in Neovim
  - `ctrl-s`: Open in VS Code

### Environment Variables

- **BAT_THEME**: `gruvbox-dark`
- **FZF_TMUX**: Enabled when in tmux
- **FZF_TMUX_OPTS**: `-p 50%,50%`

### Oh My Zsh Plugins

- `aliases` - List available shortcuts
- `brew` - Homebrew aliases
- `colored-man-pages` - Colored man pages
- `command-not-found` - Package suggestions
- `common-aliases` - Common aliases
- `copyfile` - Copy file to clipboard
- `copypath` - Copy path to clipboard
- `dirhistory` - Directory navigation shortcuts
- `git` - Git aliases and functions
- `git-prompt` - Git status in prompt
- `macos` - macOS functions
- `sudo` - ESC twice for sudo
- `tmux` - Tmux aliases
- `web-search` - Web search aliases
- `yarn` - Yarn completion
- `you-should-use` - Alias reminders
- `z` - Directory jumping
- `zsh-autosuggestions` - Fish-like autosuggestions
- `zsh-bat` - Syntax highlighting with bat
- `zsh-syntax-highlighting` - Fish-like syntax highlighting

---

## 🎨 Theme & Appearance

### Neovim

- **Colorscheme**: Gruvbox dark
- **Line Numbers**: Relative + absolute
- **Cursor Line**: Highlighted
- **True Colors**: Enabled
- **Indent**: 2 spaces
- **Scroll**: 8 lines offset

### Tmux

- **Status Bar**: Gruvbox dark theme
- **Colors**:
  - Background: `#3D3836`
  - Foreground: `#ebdbb2`
  - Accent: `#AB9881`
- **Status Left**: Session name
- **Status Right**: Date and time

### FZF

- **Colors**: Gruvbox dark theme
- **Border**: Rounded borders
- **Layout**: Reverse layout
- **Height**: 80% of screen

---

## 🔧 Custom Functions

### Zsh Functions

```bash
# FZF file finder with bat preview
fzf_file_finder() {
  fzf --preview 'bat --style=numbers --color=always --line-range=:500 {}' \
      --preview-window=right:60%:wrap \
      --bind 'ctrl-v:execute(nvim {})' \
      --bind 'ctrl-s:execute(code {})'
}

# FZF directory finder
fzf_dir_finder() {
  fzf --preview 'tree -C {} | head -200' \
      --preview-window=right:60%:wrap
}
```

---

## 📱 Integration Features

### Vim-Tmux Navigator

- Seamless navigation between Neovim splits and tmux panes
- Uses `<C-h/j/k/l>` for navigation

### FZF Integration

- File search with syntax highlighting
- Directory search with tree view
- Integration with Neovim and VS Code
- Tmux-aware when running in tmux

### Git Integration

- Git status in Neo-tree
- Git signs in Neovim
- Git aliases from Oh My Zsh

---

## 🎯 Key Features

### Neovim

- **LSP Support**: Language server protocol
- **Autocompletion**: Nvim-cmp integration
- **File Explorer**: Neo-tree with git status
- **Fuzzy Finder**: FZF integration
- **Buffer Management**: Easy buffer navigation
- **Window Management**: Split and resize shortcuts

### Tmux

- **Session Persistence**: Automatic restore
- **Mouse Support**: Clickable interface
- **Theme Integration**: Gruvbox colors
- **Plugin Ecosystem**: TPM plugin manager

### Zsh

- **Powerlevel10k**: Advanced prompt
- **FZF Integration**: Fuzzy finding
- **Oh My Zsh**: Plugin ecosystem
- **Syntax Highlighting**: Fish-like experience

---

> 💡 **Pro Tip**: These shortcuts are specifically configured for your development environment. Use `<leader>?` in Neovim to see available keymaps!
