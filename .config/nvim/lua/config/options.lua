-- =======
-- OPTIONS
-- =======

local opt = vim.opt

-- Line numbers
opt.relativenumber = true -- Show relative line numbers
opt.number = true -- Show absolute line number on cursor line

-- Tabs & Indentation
opt.tabstop = 2 -- Tab width
opt.shiftwidth = 2 -- Indentation width
opt.softtabstop = 2 -- Tab stop width
opt.expandtab = true -- Convert tabs to spaces
opt.autoindent = true -- Copy indent from current line when starting new one
opt.smartindent = true -- Smart autoindenting when starting a new line
opt.wrap = false -- Turn off line wrapping

-- Search settings
opt.ignorecase = true -- Ignore case-sensitivity when searching
opt.smartcase = true -- If you include mixed case, case-sensitivity is on
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show search results as you type

-- Appearance
opt.termguicolors = true -- Enable true color support
opt.background = "dark" -- Set dark background
opt.signcolumn = "yes" -- Always show signcolumn
opt.cursorline = true -- Highlight current line
opt.showmode = false -- Don't show mode in command line (shown in statusline)

-- Backspace
opt.backspace = "indent,eol,start" -- Allow backspace on indent, end of line or insert mode start position

-- Split windows
opt.splitright = true -- Split vertical window to the right
opt.splitbelow = true -- Split horizontal window to the bottom

-- File handling
opt.swapfile = false -- Disable swap files
opt.backup = false -- Disable backup files
opt.undofile = true -- Enable persistent undo

-- Scrolling
opt.scrolloff = 8 -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- Performance
opt.updatetime = 250 -- Faster completion

-- Clipboard
opt.clipboard = "unnamedplus" -- Use system clipboard for all yank, delete, change and put operations