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
| [`you-should-use`](https://github.com/MichaelAquilina/zsh-you-should-use)       | Reminds you of existing aliases                                                             |
| [`z`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/z)                                 | Jump to frequently used directories                                                         |
| [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)                       | Fish-like autosuggestions                                                                   |
| [`zsh-bat`](https://github.com/fdellwing/zsh-bat)                     | Syntax highlighting using bat                                                               |
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

#### Pane Navigation (Vi mode)

- `h` - Move to left pane
- `j` - Move to down pane
- `k` - Move to up pane
- `l` - Move to right pane

#### Window Management

- `Shift + Left Arrow` - Previous window
- `Shift + Right Arrow` - Next window

#### Pane Splitting

- `|` - Split window horizontally
- `-` - Split window vertically

#### Configuration

- `r` - Reload tmux configuration

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
