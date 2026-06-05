-- Global keymaps. Plugin-specific maps live in their plugin spec.
-- Leader = Space. Picker/explorer/git maps are defined in plugins/*.
local map = vim.keymap.set

-- Clear search highlight
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlight" })

-- Better up/down on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window splits (mirror tmux | and -)
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })

-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- Buffers (Shift-arrows like tmux windows)
map("n", "<S-Left>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-Right>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Last buffer" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Stay in visual mode when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Save / quit (q* group is shared with session restore in navigation.lua)
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
