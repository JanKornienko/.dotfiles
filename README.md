# Dotfiles

My personal dotfiles configuration for macOS.

## 📋 Table of Contents

- [iTerm Color Schemes](#iterm-color-schemes)
- [Oh My Zsh](#oh-my-zsh)
  - [Theme](#theme)
  - [Plugins](#plugins)
  - [Aliases](#aliases)
- [tmux Configuration](#tmux-configuration)
  - [Key Bindings](#key-bindings)
  - [Plugins](#tmux-plugins)
- [Neovim Configuration](#neovim-configuration)
  - [Key Bindings](#key-bindings-1)
  - [Plugins](#neovim-plugins)
  - [Features](#neovim-features)

---

## 🎨 iTerm Color Schemes

Available iTerm color schemes located in `iterm/`:

### Gruvbox Themes

- **GruvboxDark.itermcolors** - Gruvbox Dark theme
- **GruvboxDarkHard.itermcolors** - Gruvbox Dark Hard variant
- **GruvboxLight.itermcolors** - Gruvbox Light theme
- **GruvboxLightHard.itermcolors** - Gruvbox Light Hard variant
- **GruvboxMaterial.itermcolors** - Gruvbox Material variant

### Kanagawa Themes

- **KanagawaBones.itermcolors** - Kanagawa Bones variant
- **KanagawaDragon.itermcolors** - Kanagawa Dragon variant
- **KanagawaWave.itermcolors** - Kanagawa Wave variant

### Other Themes

- **OneDarkProNightFlat.itermcolors** - One Dark Pro Night Flat theme

### Installation

1. Open iTerm2
2. Go to `Preferences` → `Profiles` → `Colors`
3. Click `Color Presets` → `Import...`
4. Select the desired `.itermcolors` file from the `iterm/` directory
5. Select the imported preset from `Color Presets`

---

## 🐚 Oh My Zsh

### Theme

**Powerlevel10k** - A fast and highly customizable Zsh theme.

- Repository: [romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k)
- Configuration: Run `p10k configure` to customize the prompt
- Config file: `~/.p10k.zsh`

### Plugins

The following Oh My Zsh plugins are installed. Click on any plugin name to view its source code and documentation:

| Plugin                                                                                          | Description                                                                                 |
| ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| [`aliases`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aliases)                     | Helps list the shortcuts that are currently available based on the plugins you have enabled |
| [`brew`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/brew)                           | Adds aliases for common Homebrew commands                                                   |
| [`colored-man-pages`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages) | Adds colors to man pages                                                                    |
| [`command-not-found`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/command-not-found) | Suggests package installation if command not found                                          |
| [`common-aliases`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/common-aliases)       | Provides many useful aliases and functions                                                  |
| [`copyfile`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copyfile)                   | Copies content of a file to clipboard                                                       |
| [`copypath`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copypath)                   | Copies current directory path to clipboard                                                  |
| [`dirhistory`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dirhistory)               | Adds keyboard shortcuts for directory navigation                                            |
| [`git`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)                             | Provides aliases and functions for Git                                                      |
| [`git-prompt`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-prompt)               | Adds Git status info to prompt                                                              |
| [`macos`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/macos)                         | Adds macOS-specific functions and aliases                                                   |
| [`sudo`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)                           | Press ESC twice to add sudo to current command                                              |
| [`tmux`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tmux)                           | Provides aliases for tmux, the terminal multiplexer                                         |
| [`web-search`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/web-search)               | Adds aliases for searching the web from terminal                                            |
| [`yarn`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/yarn)                           | Adds completion and aliases for Yarn                                                        |
| [`you-should-use`](https://github.com/MichaelAquilina/zsh-you-should-use)                       | Reminds you of existing aliases                                                             |
| [`z`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/z)                                 | Jump to frequently used directories                                                         |
| [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)                       | Fish-like autosuggestions                                                                   |
| [`zsh-bat`](https://github.com/fdellwing/zsh-bat)                                               | Syntax highlighting using bat                                                               |
| [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)               | Fish-like syntax highlighting                                                               |

### Custom Aliases

```bash
# File listing
alias la="ls -a"          # List all files including hidden
alias lla="ls -la"        # List all files with details
```

### Additional Configuration

- **NVM**: Node Version Manager is configured and loaded automatically
- **BAT Theme**: Set to `gruvbox-dark` for syntax highlighting
- **Autosuggestions**: Highlight style set to `fg=60`

---

## 🖥️ tmux Configuration

### Key Bindings

**Prefix Key**: `Ctrl-B` (default tmux prefix)

#### Pane Navigation (Vi mode)

- `h` - Move to left pane
- `j` - Move to down pane
- `k` - Move to up pane
- `l` - Move to right pane
- `Ctrl-h/j/k/l` - Navigate seamlessly between tmux panes and Neovim splits (vim-tmux-navigator)

#### Window Management

- `Shift + Left Arrow` - Previous window
- `Shift + Right Arrow` - Next window

#### Pane Splitting

- `|` - Split window horizontally (maintains current directory)
- `-` - Split window vertically (maintains current directory)

#### Configuration

- `r` - Reload tmux configuration

#### Plugin Management

- `Ctrl-B` then `I` - Install plugins
- `Ctrl-B` then `U` - Update plugins
- `Ctrl-B` then `Alt + u` - Uninstall plugins

### Features

- **Mouse Support**: Enabled for clickable windows, panes, and resizable panes
- **Vi Mode Keys**: Enabled for copy mode
- **Window Indexing**: Starts from 1 instead of 0
- **Theme**: Gruvbox Dark Hard color scheme
- **Status Bar**: Shows session name, date, and time

### tmux Plugins

Managed via [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm):

| Plugin                        | Description                                      |
| ----------------------------- | ------------------------------------------------ |
| `tmux-plugins/tpm`            | Tmux Plugin Manager                              |
| `tmux-plugins/tmux-sensible`  | Basic tmux settings everyone can agree on        |
| `tmux-plugins/tmux-resurrect` | Persists tmux environment across system restarts |
| `tmux-plugins/tmux-continuum` | Continuous saving of tmux environment            |
| `tmux-plugins/tmux-yank`      | System clipboard integration                     |

#### Plugin Installation

1. Press `Ctrl-B` then `I` to install plugins
2. Press `Ctrl-B` then `U` to update plugins
3. Press `Ctrl-B` then `alt + u` to uninstall plugins

#### Plugin Features

- **Automatic Restore**: Enabled - tmux sessions are automatically restored on system restart
- **Pane Contents**: Captured and restored with sessions

---

## 🚀 Neovim Configuration

Neovim configuration using Lua, managed with [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager.

### Key Bindings

**Leader Key**: `<Space>`

#### General

- `<leader>nh` - Clear search highlights
- `<leader>?` - Show buffer local keymaps (which-key)
- `<C-d>` - Scroll down and center cursor
- `<C-u>` - Scroll up and center cursor

#### File Management

- `<leader>s` - Save file
- `<leader>q` - Quit
- `<leader>sq` - Save and quit

#### Window Management

- `<leader>sv` - Split window vertically
- `<leader>sh` - Split window horizontally
- `<leader>se` - Make splits equal size
- `<leader>sx` - Close current split

#### Buffer Management

- `<leader>bn` - Next buffer
- `<leader>bp` - Previous buffer
- `<leader>bd` - Delete buffer

#### File Explorer (Neo-tree)

- `<leader>e` - Toggle Neo-tree (filesystem)
- `<leader>bf` - Toggle Neo-tree float
- `<leader>bs` - Toggle Neo-tree sidebar

**Within Neo-tree:**

- `Space` - Toggle node (expand/collapse folder)
- `Enter` or `o` - Open file/folder
- `Esc` - Revert preview
- `P` - Toggle preview in floating window
- `l` - Focus preview
- `S` - Open in horizontal split
- `s` - Open in vertical split
- `t` - Open in new tab
- `w` - Open with window picker
- `C` - Close node (collapse folder)
- `z` - Close all nodes
- `a` - Add file
- `A` - Add directory
- `d` - Delete file/folder
- `r` - Rename file/folder
- `y` - Copy to clipboard
- `x` - Cut to clipboard
- `p` - Paste from clipboard
- `c` - Copy (internal)
- `m` - Move
- `q` - Close window
- `R` - Refresh
- `?` - Show help
- `<` - Previous source
- `>` - Next source

**Filesystem Navigation:**

- `Backspace` - Navigate up one directory
- `.` - Set current directory as root
- `H` - Toggle hidden files
- `/` - Fuzzy finder
- `D` - Fuzzy finder for directories
- `#` - Fuzzy sorter
- `f` - Filter on submit
- `Ctrl-x` - Clear filter
- `[g` - Previous git modified file
- `]g` - Next git modified file

**Buffer View:**

- `bd` - Delete buffer
- `Backspace` - Navigate up
- `.` - Set root

**Git Status View:**

- `A` - Git add all
- `gu` - Git unstage file
- `ga` - Git add file
- `gr` - Git revert file
- `gc` - Git commit
- `gp` - Git push
- `gg` - Git commit and push

#### File Search (FZF)

- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags
- `<leader>fc` - Command history
- `<leader>fs` - Search word under cursor
- `<leader>fl` - Search lines in buffers
- `<leader>ft` - Find tabs
- `<leader>fd` - Document diagnostics
- `<leader>fw` - Workspace diagnostics

**Within FZF:**

- `Ctrl-s` - Open file in horizontal split
- `Ctrl-v` - Open file in vertical split
- `Ctrl-t` - Open file in new tab

#### Git (GitSigns)

- `]h` - Next hunk
- `[h` - Previous hunk
- `]H` - Last hunk
- `[H` - First hunk
- `<leader>ghs` - Stage hunk
- `<leader>ghr` - Reset hunk
- `<leader>ghS` - Stage buffer
- `<leader>ghu` - Undo stage hunk
- `<leader>ghR` - Reset buffer
- `<leader>ghp` - Preview hunk inline
- `<leader>ghb` - Blame line
- `<leader>ghB` - Blame buffer
- `<leader>ghd` - Diff this
- `<leader>ghD` - Diff this ~
- `ih` - Select hunk (visual/operator mode)

#### Git (Diffview)

- `<leader>gv` - Open diffview
- `<leader>gV` - Close diffview
- `<leader>gH` - File history

**Diffview Navigation:**

- `Tab` - Next file
- `Shift-Tab` - Previous file
- `gf` - Open file in previous tab
- `Ctrl-w Ctrl-f` - Open file in new split
- `Ctrl-w gf` - Open file in new tab
- `<leader>e` - Focus file panel
- `<leader>b` - Toggle file panel
- `g Ctrl-x` - Cycle through layouts
- `g?` - Open help panel

**Merge Conflicts:**

- `[x` - Previous conflict
- `]x` - Next conflict
- `<leader>co` - Choose OURS version
- `<leader>ct` - Choose THEIRS version
- `<leader>cb` - Choose BASE version
- `<leader>ca` - Choose all versions
- `dx` - Delete conflict region

**Diff Operations (diff2 view):**

- `do` - Obtain diff hunk from OURS
- `dp` - Put diff hunk to OURS

**Diff Operations (diff3 view):**

- `2do` - Obtain from OURS
- `3do` - Obtain from THEIRS
- `2dp` - Put to OURS
- `3dp` - Put to THEIRS

**Diff Operations (diff4 view):**

- `1do` - Obtain from BASE
- `2do` - Obtain from OURS
- `3do` - Obtain from THEIRS
- `1dp` - Put to BASE
- `2dp` - Put to OURS
- `3dp` - Put to THEIRS

**File Panel:**

- `j` or `Down` - Next entry
- `k` or `Up` - Previous entry
- `Enter` or `o` - Select entry
- `-` - Stage/unstage entry
- `S` - Stage all
- `U` - Unstage all
- `X` - Restore entry
- `L` - Open commit log
- `zo` - Open fold
- `zc` - Close fold
- `za` - Toggle fold
- `zR` - Open all folds
- `zM` - Close all folds
- `Ctrl-b` - Scroll view up
- `Ctrl-f` - Scroll view down
- `i` - Toggle list/tree view
- `f` - Flatten empty subdirectories
- `R` - Refresh files

**File History Panel:**

- `g!` - Options panel
- `Ctrl-Alt-d` - Open entry in diffview
- `y` - Copy commit hash
- `L` - Show commit details
- `zR` - Open all folds
- `zM` - Close all folds
- `j` or `Down` - Next entry
- `k` or `Up` - Previous entry
- `Enter` or `o` - Select entry
- `Ctrl-b` - Scroll view up
- `Ctrl-f` - Scroll view down
- `Tab` - Next file
- `Shift-Tab` - Previous file
- `gf` - Open file in previous tab
- `Ctrl-w Ctrl-f` - Open in split
- `Ctrl-w gf` - Open in tab
- `<leader>e` - Focus files
- `<leader>b` - Toggle files
- `g Ctrl-x` - Cycle layout

**Option Panel:**

- `Tab` - Change option
- `q` - Close panel

**Help Panel:**

- `q` or `Esc` - Close help

#### Code Formatting

- `<leader>lf` - Format buffer (LSP)
- `<leader>f` - Format buffer (LSP, any available formatter)
- `<leader>gf` - Format buffer with null-ls (Prettier/Stylua)

#### LSP (Language Server Protocol)

**Navigation:**

- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Find references
- `gt` - Go to type definition

**Documentation:**

- `K` - Hover documentation
- `Ctrl-k` - Signature help

**Code Actions:**

- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action

**Diagnostics:**

- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `<leader>d` - Show diagnostic in floating window
- `<leader>q` - Diagnostic list (location list)

**Inlay Hints (TypeScript):**

- `<leader>h` - Toggle inlay hints

#### Completion (nvim-cmp)

**Within completion menu:**

- `Ctrl-p` - Select previous item
- `Ctrl-n` - Select next item
- `Ctrl-b` - Scroll documentation up
- `Ctrl-f` - Scroll documentation down
- `Ctrl-Space` - Open completion menu
- `Ctrl-e` - Close completion menu
- `Enter` - Confirm selection
- `Tab` - Select next item or jump to next snippet field
- `Shift-Tab` - Select previous item or jump to previous snippet field

#### Snippets (LuaSnip)

- `Ctrl-j` - Expand snippet or jump to next field
- `Ctrl-k` - Jump to previous snippet field

#### Treesitter (Syntax Selection)

- `Ctrl-Space` - Start incremental selection (normal mode) or expand selection (visual mode)
- `Backspace` - Shrink selection (visual mode)

#### Colorizer

- `<leader>ct` - Toggle colorizer
- `<leader>cr` - Reload colorizer in all buffers

#### Theme

- `<leader>tb` - Toggle background (light/dark)

#### tmux Integration

- `Ctrl-h/j/k/l` - Navigate between Neovim splits and tmux panes seamlessly (via vim-tmux-navigator)

### Neovim Plugins

| Plugin                                                                                | Description                                 |
| ------------------------------------------------------------------------------------- | ------------------------------------------- |
| [`folke/lazy.nvim`](https://github.com/folke/lazy.nvim)                               | Plugin manager                              |
| [`ellisonleao/gruvbox.nvim`](https://github.com/ellisonleao/gruvbox.nvim)             | Gruvbox color scheme                        |
| [`nvim-neo-tree/neo-tree.nvim`](https://github.com/nvim-neo-tree/neo-tree.nvim)       | File explorer                               |
| [`ibhagwan/fzf-lua`](https://github.com/ibhagwan/fzf-lua)                             | Fuzzy finder                                |
| [`lewis6991/gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim)               | Git integration                             |
| [`sindrets/diffview.nvim`](https://github.com/sindrets/diffview.nvim)                 | Git diff viewer                             |
| [`nvim-lualine/lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim)           | Statusline                                  |
| [`folke/which-key.nvim`](https://github.com/folke/which-key.nvim)                     | Key binding helper                          |
| [`christoomey/vim-tmux-navigator`](https://github.com/christoomey/vim-tmux-navigator) | Seamless navigation between Neovim and tmux |
| [`pocco81/auto-save.nvim`](https://github.com/pocco81/auto-save.nvim)                 | Automatic file saving                       |
| [`3rd/image.nvim`](https://github.com/3rd/image.nvim)                                 | Image rendering support                     |

### Neovim Features

- **Theme**: Gruvbox Dark (hard contrast) with toggle for light/dark mode
- **Line Numbers**: Relative line numbers with absolute number on current line
- **Indentation**: 2 spaces, tabs converted to spaces
- **Clipboard**: System clipboard integration (`unnamedplus`)
- **Undo**: Persistent undo across sessions
- **Auto-save**: Files automatically saved on focus lost, insert leave, and text changes
- **Statusline**: Custom lualine configuration showing file info, git status, and diagnostics
- **File Explorer**: Neo-tree with git status indicators
- **Fuzzy Finder**: FZF-lua for fast file and content searching with image previews
- **Git Integration**: GitSigns for inline git indicators and Diffview for git diffs
- **tmux Integration**: Seamless navigation between Neovim splits and tmux panes
- **LSP**: Language Server Protocol support for code formatting and diagnostics
- **Image Support**: View PNG, JPG, GIF, and WebP images inline in markdown files and FZF previews

### Image Support

View images directly in Neovim buffers and FZF previews.

#### Requirements

```bash
# Install via Homebrew
brew install imagemagick  # For inline image rendering
brew install chafa        # For FZF image previews
```

#### Usage

- **FZF Preview**: Press `<leader>ff` and navigate to any image file for automatic preview
- **Markdown**: Images in markdown files (`![alt](image.png)`) render inline automatically
- **Neo-tree**: Open image files directly with `<leader>e`

#### Supported Formats

PNG, JPEG, GIF, WebP, SVG, TIFF, AVIF

#### Configuration

After installing dependencies:

1. Reload tmux: `tmux source ~/.tmux.conf` or press `Ctrl-b` then `r`
2. Sync Neovim plugins: `:Lazy sync`

#### Troubleshooting

- **Images not showing in buffers?** Check `:messages` in Neovim, verify ImageMagick is installed: `magick --version`
- **FZF previews not working?** Verify chafa: `chafa --version`

---

## 📝 Notes

- The tmux configuration uses Gruvbox Dark Hard theme colors
- Powerlevel10k instant prompt is enabled for faster shell startup
- All pane splits maintain the current directory path

---

## 🔗 Useful Links

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [tmux](https://github.com/tmux/tmux)
- [TPM](https://github.com/tmux-plugins/tpm)
- [Neovim](https://neovim.io/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
