# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	aliases										# Helps list the shortcuts that are currently available based on the plugins you have enabled
	brew											# Adds aliases for common Homebrew commands
	colored-man-pages					# Adds colors to man pages
	command-not-found					# Suggests package installation if command not found
	common-aliases						# Provides many useful aliases and functions
	copyfile									# Copies content of a file to clipboard
	copypath          				# Copies current directory path to clipboard
	dirhistory        				# Adds keyboard shortcuts for directory navigation
	git               				# Provides aliases and functions for Git
	git-prompt        				# Adds Git status info to prompt
	macos             				# Adds macOS-specific functions and aliases
	sudo              				# Press ESC twice to add sudo to current command
	tmux											# Provides aliases for tmux, the terminal multiplexer
	web-search        				# Adds aliases for searching the web from terminal
	yarn              				# Adds completion and aliases for Yarn
	you-should-use    				# Reminds you of existing aliases
	zsh-autosuggestions			  # Fish-like autosuggestions
	zsh-bat										# Syntax highlighting using bat
	zsh-syntax-highlighting		# Fish-like syntax highlighting
)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=60"

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =====================
# MODERN CLI TOOLS
# =====================

# Every tool below is guarded so the shell still starts on a box where one is
# missing (remote/Coder workspaces install a subset — see install.sh).

# ---- fzf: fuzzy finder (Ctrl-T files, Alt-C cd, ** completion) ----
# Note: Ctrl-R is owned by atuin below, not fzf.
(( $+commands[fzf] )) && source <(fzf --zsh)

# Gruvbox Dark Hard colors for fzf
export FZF_DEFAULT_OPTS="
  --color=bg+:#3c3836,bg:#1d2021,spinner:#fb4934,hl:#928374
  --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fabd2f,hl+:#fb4934"

# ---- atuin: magic shell history (Ctrl-R search). Init after fzf to own Ctrl-R ----
(( $+commands[atuin] )) && eval "$(atuin init zsh)"

# ---- zoxide: smarter cd. Use `z <dir>` to jump, `zi` for interactive pick ----
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# ---- thefuck: fix the previous command. Run `fuck` (or `fk`) after a typo ----
# Not installed on Linux — upstream is broken under Python 3.12.
if (( $+commands[thefuck] )); then
  eval "$(thefuck --alias)"
  alias fk=fuck
fi

# ---- navi: interactive cheatsheet. Ctrl-G pops a fuzzy help/insert menu ----
export NAVI_PATH="$HOME/.dotfiles/.config/navi/cheats"
(( $+commands[navi] )) && eval "$(navi widget zsh)"

# ---- eza: modern ls (icons, git status, tree) ----
alias ll='eza -l --icons --git --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lla='eza -la --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons --group-directories-first'
alias lta='eza --tree --level=2 -a --git --icons --group-directories-first'

# =====================
# LEARNING NUDGES
# Remind to use the new tools when old habits fire (once per session each).
# Delete this block once the muscle memory sticks.
# =====================
typeset -gA _NUDGED
_nudge() {
  local key=$1 msg=$2
  [[ -n ${_NUDGED[$key]} ]] && return
  _NUDGED[$key]=1
  print -P "%F{yellow}💡 ${msg}%f" >&2
}
unalias ls cd 2>/dev/null
ls() { _nudge ls "Modern: %Beza%b — aliases: ll (long+git), la (all), lt (tree)"; command ls "$@"; }
cd() { _nudge cd "Modern: %Bz <dir>%b jumps by frecency, %Bzi%b picks interactively"; builtin cd "$@"; }

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export BAT_THEME="gruvbox-dark"

EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jankornienko/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jankornienko/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jankornienko/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jankornienko/google-cloud-sdk/completion.zsh.inc'; fi

# Added by Antigravity
export PATH="/Users/jankornienko/.antigravity/antigravity/bin:$PATH"
