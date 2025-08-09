-- =======
-- FZF-LUA
-- =======

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "vijaymarupudi/nvim-fzf",
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
      -- Global options
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
          -- Enter insert mode when fzf opens
          vim.cmd("startinsert")
        end,
      },
      fzf_opts = {
        ["--layout"] = "reverse",
        ["--border"] = "none",
        ["--info"] = "default",
      },
      -- Keymap for fzf actions
      actions = {
        files = {
          ["default"] = "edit",
          ["ctrl-s"] = "split",
          ["ctrl-v"] = "vsplit",
          ["ctrl-t"] = "tabedit",
          ["ctrl-q"] = "send_to_qflist",
          ["alt-q"] = "send_to_locationlist",
        },
        buffers = {
          ["default"] = "edit",
          ["ctrl-s"] = "split",
          ["ctrl-v"] = "vsplit",
          ["ctrl-t"] = "tabedit",
          ["ctrl-x"] = "delete_buffers",
        },
      },
      -- Files command options
      files = {
        cmd = nil,
        git_icons = true,
        file_icons = true,
        color_icons = true,
        git_status_cmd = nil,
        git_status_cmd_on_file = nil,
        git_status_cmd_on_dir = nil,
        git_status_cmd_on_file_symlink = nil,
        git_status_cmd_on_dir_symlink = nil,
        git_icons_colors = {
          added = "#a7c080",
          modified = "#dbbc7f",
          deleted = "#ff9999",
          renamed = "#7fdbca",
          unmerged = "#f4a261",
          untracked = "#e67e80",
          ignored = "#6c7086",
          staged = "#b5e8e0",
          conflict = "#ff9999",
        },
        previewer = {
          _ctor = require("fzf-lua.previewer").bat,
          cmd = "bat",
          args = "--style=numbers,changes --color always",
          theme = "Catppuccin-mocha",
          config = nil,
        },
        prompt = "Files> ",
        multiprocess = true,
        set_esc = true,
        do_file_arg = false,
        file_icons = true,
        color_icons = true,
        git_icons = true,
        git_status = true,
        fzf_opts = {
          ["--tiebreak"] = "index",
        },
        fzf_colors = {
          ["fg"] = { "fg", "FzfLuaNormal" },
          ["bg"] = { "bg", "FzfLuaNormal" },
          ["hl"] = { "fg", "FzfLuaMatch" },
          ["fg+"] = { "fg", "FzfLuaCursorLine" },
          ["bg+"] = { "bg", "FzfLuaCursorLine" },
          ["hl+"] = { "fg", "FzfLuaMatch" },
          ["info"] = { "fg", "FzfLuaInfo" },
          ["prompt"] = { "fg", "FzfLuaPrompt" },
          ["pointer"] = { "fg", "FzfLuaPointer" },
          ["marker"] = { "fg", "FzfLuaMarker" },
          ["spinner"] = { "fg", "FzfLuaSpinner" },
          ["header"] = { "fg", "FzfLuaHeader" },
          ["gutter"] = { "bg", "FzfLuaGutter" },
          ["border"] = { "fg", "FzfLuaBorder" },
        },
      },
      -- Grep command options
      grep = {
        cmd = nil,
        tools = { "grep", "rg", "git", "ugrep" },
        silent_err_pattern = "^.*\\.git/.*\\.lock$",
        input_prompt = "Grep> ",
        multiprocess = true,
        git_icons = true,
        file_icons = true,
        color_icons = true,
        grep_opts = "-n --column --color=always",
        rg_opts = "-n --column --color=always --no-heading --smart-case",
        git_opts = "grep --column --line-number --color=always",
        ugrep_opts = "-n --column --color=always",
        fzf_opts = {
          ["--tiebreak"] = "index",
        },
        fzf_colors = {
          ["fg"] = { "fg", "FzfLuaNormal" },
          ["bg"] = { "bg", "FzfLuaNormal" },
          ["hl"] = { "fg", "FzfLuaMatch" },
          ["fg+"] = { "fg", "FzfLuaCursorLine" },
          ["bg+"] = { "bg", "FzfLuaCursorLine" },
          ["hl+"] = { "fg", "FzfLuaMatch" },
          ["info"] = { "fg", "FzfLuaInfo" },
          ["prompt"] = { "fg", "FzfLuaPrompt" },
          ["pointer"] = { "fg", "FzfLuaPointer" },
          ["marker"] = { "fg", "FzfLuaMarker" },
          ["spinner"] = { "fg", "FzfLuaSpinner" },
          ["header"] = { "fg", "FzfLuaHeader" },
          ["gutter"] = { "bg", "FzfLuaGutter" },
          ["border"] = { "fg", "FzfLuaBorder" },
        },
      },
      -- Buffers command options
      buffers = {
        prompt = "Buffers> ",
        file_icons = true,
        color_icons = true,
        sort_lastused = true,
        fzf_opts = {
          ["--tiebreak"] = "index",
        },
        fzf_colors = {
          ["fg"] = { "fg", "FzfLuaNormal" },
          ["bg"] = { "bg", "FzfLuaNormal" },
          ["hl"] = { "fg", "FzfLuaMatch" },
          ["fg+"] = { "fg", "FzfLuaCursorLine" },
          ["bg+"] = { "bg", "FzfLuaCursorLine" },
          ["hl+"] = { "fg", "FzfLuaMatch" },
          ["info"] = { "fg", "FzfLuaInfo" },
          ["prompt"] = { "fg", "FzfLuaPrompt" },
          ["pointer"] = { "fg", "FzfLuaPointer" },
          ["marker"] = { "fg", "FzfLuaMarker" },
          ["spinner"] = { "fg", "FzfLuaSpinner" },
          ["header"] = { "fg", "FzfLuaHeader" },
          ["gutter"] = { "bg", "FzfLuaGutter" },
          ["border"] = { "fg", "FzfLuaBorder" },
        },
      },
      -- Colors
      fzf_colors = {
        ["fg"] = { "fg", "FzfLuaNormal" },
        ["bg"] = { "bg", "FzfLuaNormal" },
        ["hl"] = { "fg", "FzfLuaMatch" },
        ["fg+"] = { "fg", "FzfLuaCursorLine" },
        ["bg+"] = { "bg", "FzfLuaCursorLine" },
        ["hl+"] = { "fg", "FzfLuaMatch" },
        ["info"] = { "fg", "FzfLuaInfo" },
        ["prompt"] = { "fg", "FzfLuaPrompt" },
        ["pointer"] = { "fg", "FzfLuaPointer" },
        ["marker"] = { "fg", "FzfLuaMarker" },
        ["spinner"] = { "fg", "FzfLuaSpinner" },
        ["header"] = { "fg", "FzfLuaHeader" },
        ["gutter"] = { "bg", "FzfLuaGutter" },
        ["border"] = { "fg", "FzfLuaBorder" },
      },
    })
  end,
}
