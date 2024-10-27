-- =======
-- OPTIONS
-- =======

vim.cmd("let g:netrw_liststyle = 3")	-- file explorer (Netrw) tree view

local opt = vim.opt

opt.relativenumber = true							-- relative numbers
opt.number = true											-- current line number

-- Tabs & Indentation
opt.tabstop = 2												-- tab width
opt.shiftwidth = 2										-- indentation width
opt.softtabstop = 2										-- tab stop width
opt.autoindent = true									-- copy indent from current line when starting new one
opt.smartindent = true								-- smart autoindenting when starting a new line

opt.wrap = false											-- turn off line wrapping

-- Search settings
opt.ignorecase = true									-- ignore case-sensitivity when searching
opt.smartcase = true									-- if you include mixed case, case-sensitivity is on

-- Turn on termguicolors for tokyonight cOlorscheme to work
-- (have to use iterm2 or any other true Color terminal)
opt. termguicolors = true
opt. background = "dark"							-- colorschemes that can be light or dark will be made dark
opt. signcolumn = "yes"								-- show sign column so that text doesn't

-- Backspace
opt.backspace = "indent,eol,start"		-- allow backspace on indent, end of line or insert mode start position

-- Clipboard
opt.clipboard:append("unnamedplus")		-- use system clipboard as default register

-- Split windows
opt.splitright = true									-- split vertical window to the right
opt.splitbelow = true									-- split horizontal window to the bottom
