-- snacks (picker/explorer/dashboard/notifier/lazygit), which-key, noice, icons.
return {
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      scope = { enabled = true },
      words = { enabled = true },
      dashboard = { enabled = true },
      notifier = {
        enabled = true,
        top_down = false, -- bottom-up, like tmux messages
      },
      explorer = { enabled = true, replace_netrw = true },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            layout = { layout = { position = "right", width = 40 } },
          },
          files = { hidden = true, ignored = true },
          grep = { hidden = true, ignored = true },
        },
      },
    },
    keys = {
      -- Explorer / files
      { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word", mode = { "n", "x" } },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },
      -- Search
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todos" },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      -- LSP nav
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto definition" },
      { "gr", function() Snacks.picker.lsp_references() end, desc = "References", nowait = true },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto implementation" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Symbols" },
      -- Misc
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notifications" },
      { "<leader>bD", function() Snacks.bufdelete() end, desc = "Delete buffer (snacks)" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find/file" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>w", group = "window" },
        { "<leader>x", group = "diagnostics/quickfix" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
}
