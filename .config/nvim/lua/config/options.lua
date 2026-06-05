-- Vim options. Loaded before plugins (see lazy.lua).
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true -- truecolor (matches tmux Tc override)
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.showmode = false -- lualine shows it
opt.laststatus = 3 -- global statusline
opt.cmdheight = 1
opt.pumheight = 12 -- completion menu height
opt.winminwidth = 5

-- Splits (open down/right, like tmux | and -)
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "nosplit" -- live :s preview

-- Files / persistence
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false
opt.confirm = true -- ask to save on quit instead of erroring

-- Misc
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.updatetime = 200
opt.timeoutlen = 300 -- which-key popup speed
opt.completeopt = "menu,menuone,noselect"
opt.virtualedit = "block"
opt.fillchars = { eob = " ", fold = " ", foldsep = " " }
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- Folds via treesitter (no auto-close on open)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldtext = ""

-- Use ripgrep for :grep (matches shell tooling)
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end
