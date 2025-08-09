-- ===
-- FZF
-- ===

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>ff",
      function()
        require("fzf-lua").files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>fh",
      function()
        require("fzf-lua").help_tags()
      end,
      desc = "Help tags",
    },
    {
      "<leader>fc",
      function()
        require("fzf-lua").command_history()
      end,
      desc = "Command history",
    },
    {
      "<leader>fs",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "Search word under cursor",
    },
    {
      "<leader>fl",
      function()
        require("fzf-lua").lines()
      end,
      desc = "Search lines in buffers",
    },
    {
      "<leader>ft",
      function()
        require("fzf-lua").tabs()
      end,
      desc = "Find tabs",
    },
    {
      "<leader>fd",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "Document diagnostics",
    },
    {
      "<leader>fw",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "Workspace diagnostics",
    },
  },
  config = function()
    require("fzf-lua").setup({
      winopts = {
        height = 0.8,
        width = 0.8,
        row = 0.1,
        col = 0.1,
        border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
        title = "",
        title_pos = "center",
        fullscreen = false,
        preview = {
          default = "bat",
          layout = "vertical",
          vertical = "up:50%",
          horizontal = "right:50%",
          scrollbar = "float",
          scrolloff = "-2",
          scrollchars = { "█", "" },
          delay = 100,
          winopts = {
            number = false,
            relativenumber = false,
            cursorline = false,
            cursorcolumn = false,
            foldcolumn = "0",
            list = false,
            signcolumn = "no",
            foldenable = false,
            foldmethod = "manual",
          },
        },
        on_create = function()
          vim.cmd("startinsert")
        end,
      },
      fzf_opts = {
        ["--layout"] = "reverse",
        ["--border"] = "none",
        ["--info"] = "default",
      },
      files = {
        prompt = "Files> ",
        file_icons = true,
        color_icons = true,
        git_icons = true,
        git_status = true,
        actions = {
          ["default"] = require("fzf-lua").actions.file_edit,
          ["ctrl-s"] = require("fzf-lua").actions.file_split,
          ["ctrl-v"] = require("fzf-lua").actions.file_vsplit,
          ["ctrl-t"] = require("fzf-lua").actions.file_tabedit,
        },
      },
      grep = {
        prompt = "Grep> ",
        file_icons = true,
        color_icons = true,
        git_icons = true,
        actions = {
          ["default"] = require("fzf-lua").actions.file_edit,
          ["ctrl-s"] = require("fzf-lua").actions.file_split,
          ["ctrl-v"] = require("fzf-lua").actions.file_vsplit,
          ["ctrl-t"] = require("fzf-lua").actions.file_tabedit,
        },
      },
      buffers = {
        prompt = "Buffers> ",
        file_icons = true,
        color_icons = true,
        sort_lastused = true,
        actions = {
          ["default"] = require("fzf-lua").actions.buf_edit,
          ["ctrl-s"] = require("fzf-lua").actions.buf_split,
          ["ctrl-v"] = require("fzf-lua").actions.buf_vsplit,
          ["ctrl-t"] = require("fzf-lua").actions.buf_tabedit,
        },
      },
    })
  end,
}
