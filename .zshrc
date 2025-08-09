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
	z                 				# Jump to frequently used directories
	zsh-autosuggestions			  # Fish-like autosuggestions
	zsh-bat										# Syntax highlighting using bat
	zsh-syntax-highlighting		# Fish-like syntax highlighting
)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=60"

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias vim="nvim"
alias	la="ls -a"
alias	lla="ls -la"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# FZF Tmux Integration
# Use tmux popup for fzf when inside tmux
if [[ -n "$TMUX" ]]; then
  export FZF_TMUX_OPTS="-p 80%,80%"
  export FZF_TMUX=1
fi

# FZF configuration for tmux
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --margin=1,4"
