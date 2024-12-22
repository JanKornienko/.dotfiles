-- =======
-- KEYMAPS
-- =======

vim.g.mapleader = " "																																						-- Setup leader key to ","

local keymap = vim.keymap

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })										-- Split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })									-- Split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })										-- Make split windows equal width & height
keymap.set("n", "<leader>sw", "<cmd>close<CR>", { desc = "Close current split" })								-- Close current split window

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })											-- Open new tab
keymap.set("n", "<leader>tw", "<cmd>tabclose<CR>", { desc = "Close current tab" })							-- Close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })											-- Go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })									-- Go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })	-- Move current buffer to new tab
