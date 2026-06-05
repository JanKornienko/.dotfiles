-- Git: gitsigns hunks + lazygit (via snacks, terminal-native).
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = require("gitsigns")
        local function m(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        m("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        m("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        m({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk")
        m({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk")
        m("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
        m("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
        m("n", "<leader>ghB", function() gs.blame() end, "Blame buffer")
        m("n", "<leader>ghd", gs.diffthis, "Diff this")
      end,
    },
  },

  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git file history" },
    },
  },
}
