# Dotfiles

My personal dotfiles for **macOS and Ubuntu/Debian**, on both x86_64 and ARM.
One command bootstraps a fresh machine:

```bash
git clone git@github.com:JanKornienko/.dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

`install.sh` is idempotent — re-run it any time. It installs packages (apt or
Homebrew), fetches the tools apt ships too old or not at all, clones the zsh and
tmux plugins, symlinks every config below, and asks once for the git identity.
Coder workspaces pick it up automatically via `coder dotfiles <repo>`.

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
- `git` - Comprehensive Git aliases
- `you-should-use` - Alias reminders

[View all plugins and configuration →](https://github.com/jankornienko/.dotfiles/wiki/Oh-My-Zsh)

### ⚡ Modern CLI Tools

A set of modern replacements wired into the shell:

| Tool | Replaces | Key usage |
| --- | --- | --- |
| [`eza`](https://github.com/eza-community/eza) | `ls` | `ll`, `la`, `lla`, `lt` (tree), `lta` (tree+all+git) |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | `cd`/`z` | `z <dir>` jump by frecency, `zi` interactive |
| [`fzf`](https://github.com/junegunn/fzf) | — | `Ctrl-T` files, `Alt-C` cd, `**<Tab>` completion |
| [`atuin`](https://github.com/atuinsh/atuin) | shell history | `Ctrl-R` searchable history (own `Ctrl-S` to scope) |
| [`git-delta`](https://github.com/dandavison/delta) | git pager | automatic on `git diff`/`show`/`log -p` |
| [`thefuck`](https://github.com/nvbn/thefuck) | — | `fuck` / `fk` to fix the previous command |
| [`navi`](https://github.com/denisidoro/navi) | — | `Ctrl-G` interactive cheatsheet (custom cheats in `.config/navi/`) |

**Learning nudges:** typing `ls` or `cd` prints a one-time-per-session reminder pointing to the modern equivalent. Remove the `LEARNING NUDGES` block in `.zshrc` once habits stick.

### 🖥️ tmux Configuration

**Prefix:** `Ctrl-B`

**Quick Keys:**

- `|` / `-` - Split panes (horizontal/vertical)
- `h/j/k/l` - Navigate panes (Vi-style)
- `Ctrl-h/j/k/l` - Seamless Neovim + tmux navigation
- `r` - Reload configuration
- `?` - Cheatsheet popup · `Space` - which-key menu · `F` - fuzzy menu

**Features:** Mouse support, Vi mode, Gruvbox theme, session persistence, rich status bar (git status with P10k-style signs, directory, weather, sun times, time-of-day icon)

[View all key bindings →](https://github.com/jankornienko/.dotfiles/wiki/tmux)

### 🚀 Neovim Configuration

Hand-rolled config (no distro) on `lazy.nvim`. Web-first: TypeScript, JavaScript, PHP, HTML/CSS/Tailwind, JSON — plus Lua, shell, YAML/TOML/Markdown.

**Leader Key:** `<Space>`

**Quick Keys:**

- `<leader>e` - File explorer (snacks)
- `<leader>ff` - Find files · `<leader>fg` - Grep
- `gd` - Go to definition · `gr` - References · `K` - Hover
- `<leader>ca` - Code action · `<leader>cr` - Rename · `<leader>cf` - Format
- `<leader>gg` - Lazygit · `]h`/`[h` - Next/prev hunk
- `Ctrl-h/j/k/l` - Seamless Neovim + tmux navigation
- `<leader>qs` - Restore session

**Core Plugins:**

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Picker, explorer, dashboard, notifier, lazygit
- [blink.cmp](https://github.com/saghen/blink.cmp) - Completion
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax & textobjects
- [mason](https://github.com/mason-org/mason.nvim) + [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP (vtsls, intelephense, tailwindcss, lua_ls, …)
- [conform.nvim](https://github.com/stevearc/conform.nvim) + [nvim-lint](https://github.com/mfussenegger/nvim-lint) - Format (Biome) & lint
- [gitsigns](https://github.com/lewis6991/gitsigns.nvim) - Git hunks
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) - Seamless pane navigation

**Features:** Hand-rolled modular config, LSP via Mason, Biome formatting/linting, auto-save, session persistence, tmux integration, Gruvbox Dark Hard theme

[View all key bindings and plugins →](https://github.com/jankornienko/.dotfiles/wiki/Neovim)

## 📦 Installation

```bash
git clone git@github.com:JanKornienko/.dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
exec zsh
```

On macOS, Homebrew must already be present (`install.sh` refuses to guess);
everything else is handled. On Linux it needs `sudo` for apt — without it, system
packages are skipped and the user-local binaries still install into
`~/.local/bin`.

### What gets symlinked

| Repo path | Symlinked to |
| --- | --- |
| `.zshrc` | `~/.zshrc` |
| `.zprofile` | `~/.zprofile` |
| `.p10k.zsh` | `~/.p10k.zsh` |
| `.tmux.conf` | `~/.tmux.conf` |
| `.gitconfig` | `~/.gitconfig` |
| `.config/nvim/` | `~/.config/nvim` |
| `.config/git/ignore` | `~/.config/git/ignore` |
| `.config/htop/htoprc` | `~/.config/htop/htoprc` |
| `.config/atuin/config.toml` | `~/.config/atuin/config.toml` |
| `.config/gh/config.yml` | `~/.config/gh/config.yml` |

`.config/tmux/` (status-bar scripts) and `.config/navi/` (cheats) are read
straight out of the repo — `.tmux.conf` and `$NAVI_PATH` point at `~/.dotfiles`,
so they need no link.

An existing real file at a link target is moved to `<file>.bak` before being
replaced, once — a re-run never clobbers the first backup.

### Per-machine files (never committed)

| File | Holds |
| --- | --- |
| `~/.gitconfig.local` | git `user.name` / `user.email`. Created by `install.sh`, `include`d from `.gitconfig`. |
| `~/.zshrc.local` | host-specific PATH entries, tokens, work-only settings. Sourced last by `.zshrc`. |
| `~/.zprofile.local` | login-shell env for this host only. |
| `~/.config/gh/hosts.yml` | the GitHub CLI token. Run `gh auth login` per machine. |

Anything an app installer appends to `~/.zshrc` belongs in `~/.zshrc.local`
instead — otherwise it lands in the tracked file and breaks the next machine.

### After the first run

1. Set a Nerd Font in the terminal (macOS gets `font-meslo-lg-nerd-font`
   installed) — Powerlevel10k renders as tofu boxes without one.
2. `gh auth login`, if the GitHub CLI is used.
3. tmux plugins install automatically; `Ctrl-B` + `I` to redo it by hand.
4. Neovim plugins sync headlessly on install; `:Lazy sync` to redo.
5. `p10k configure` only to change the prompt — `.p10k.zsh` is already tuned.

## 📚 Additional Resources

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [tmux](https://github.com/tmux/tmux)
- [Neovim](https://neovim.io/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)

## 📝 Notes

- Configuration uses Gruvbox Dark Hard theme across iTerm, tmux, and Neovim
- Seamless navigation between tmux panes and Neovim splits via `Ctrl-h/j/k/l`
- Neovim LSP servers, formatters, and linters auto-install on first launch via Mason
- All configurations are managed with modern plugin managers (lazy.nvim for Neovim, TPM for tmux)

---

**For detailed configuration, key bindings, and usage instructions, visit the [Wiki](https://github.com/jankornienko/.dotfiles/wiki).**
