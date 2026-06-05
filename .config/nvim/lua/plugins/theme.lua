-- Gruvbox Dark Hard — matches tmux/shell/fzf/bat. Plus statusline + bufferline.
return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000, -- load before everything else
    opts = {
      contrast = "hard", -- match tmux/shell background #1d2021
      transparent_mode = false,
      bold = true,
      italic = { strings = false, comments = true, folds = true },
      overrides = {
        SignColumn = { bg = "NONE" },
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.o.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    opts = function()
      return {
        options = {
          theme = "gruvbox",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            { "diagnostics" },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1 },
          },
          lualine_x = {
            { "diff" },
            { "encoding" },
            { "fileformat" },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "lazy", "mason", "trouble", "quickfix" },
      }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          { filetype = "snacks_layout_box", text = "Explorer", highlight = "Directory", separator = true },
        },
      },
    },
  },
}
