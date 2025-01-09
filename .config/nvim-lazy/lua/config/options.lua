-- =======
-- OPTIONS
-- =======

local opt = vim.opt

-- Tabs & Indentation
opt.tabstop = 2 -- Tab width
opt.shiftwidth = 2 -- Indentation width
opt.softtabstop = 2 -- Tab stop width
opt.autoindent = true -- Copy indent from current line when starting new one
opt.smartindent = true -- Smart autoindenting when starting a new line
opt.wrap = false -- Turn off line wrapping

-- Search settings
opt.ignorecase = true -- Ignore case-sensitivity when searching
opt.smartcase = true -- If you include mixed case, case-sensitivity is on

-- Backspace
opt.backspace = "indent,eol,start" -- Allow backspace on indent, end of line or insert mode start position

-- Split windows
opt.splitright = true -- Split vertical window to the right
opt.splitbelow = true -- Split horizontal window to the bottom

-- Colorscheme
opt.termguicolors = true
opt.background = "dark" -- Colorschemes that can be light or dark will be made dark
