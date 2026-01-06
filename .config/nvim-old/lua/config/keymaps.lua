-- =======
-- KEYMAPS
-- =======

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Window management (works with both nvim splits and tmux panes)
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Buffer management
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Quick save and quit
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>sq", ":wq<CR>", { desc = "Save and quit" })

-- Formatting
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })

-- Diffview
vim.keymap.set("n", "<leader>gv", ":DiffviewOpen<CR>", { desc = "Open diffview" })
vim.keymap.set("n", "<leader>gV", ":DiffviewClose<CR>", { desc = "Close diffview" })
vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory<CR>", { desc = "File history" })

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "[[", "[[zz")
vim.keymap.set("n", "]]", "]]zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Paste without overwriting register
vim.keymap.set("x", "<leader>p", "\"_dP")