-- ===
-- FZF
-- ===

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
    { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Find buffers" },
    { "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "Help tags" },
    { "<leader>fc", function() require("fzf-lua").command_history() end, desc = "Command history" },
    { "<leader>fs", function() require("fzf-lua").grep_cword() end, desc = "Search word under cursor" },
    { "<leader>fl", function() require("fzf-lua").lines() end, desc = "Search lines in buffers" },
    { "<leader>ft", function() require("fzf-lua").tabs() end, desc = "Find tabs" },
    { "<leader>fd", function() require("fzf-lua").diagnostics_document() end, desc = "Document diagnostics" },
    { "<leader>fw", function() require("fzf-lua").diagnostics_workspace() end, desc = "Workspace diagnostics" },
  },
  config = function()
    -- Determine which image preview tool is available
    local preview_cmd
    if vim.fn.executable("chafa") == 1 then
      preview_cmd = "[[ $(file --mime-type -b {}) =~ ^image/ ]] && chafa -f symbols --animate off -s {columns}x{lines} {} || bat --color=always --style=numbers --line-range=:500 {}"
    elseif vim.fn.executable("viu") == 1 then
      preview_cmd = "[[ $(file --mime-type -b {}) =~ ^image/ ]] && viu -w $(({columns} - 2)) {} || bat --color=always --style=numbers --line-range=:500 {}"
    elseif vim.fn.executable("imgcat") == 1 then
      preview_cmd = "[[ $(file --mime-type -b {}) =~ ^image/ ]] && imgcat {} || bat --color=always --style=numbers --line-range=:500 {}"
    else
      preview_cmd = "bat --color=always --style=numbers --line-range=:500 {}"
    end

    require("fzf-lua").setup({
      winopts = {
        height = 0.7,
        width = 0.7,
        row = 0.5,
        col = 0.5,
        border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
        preview = {
          default = "builtin",
          horizontal = "right:50%",
          vertical = "up:50%",
          layout = "flex",
          flip_columns = 120,
          scrollbar = "float",
        },
        on_create = function()
          vim.cmd("startinsert")
        end,
      },
      fzf_opts = {
        ["--layout"] = "reverse",
        ["--height"] = "80%",
        ["--preview-window"] = "right:50%:wrap",
      },
      fzf_colors = {
        pointer = { "fg", "GruvboxRed" },
        marker = { "fg", "GruvboxRed" },
        prompt = { "fg", "GruvboxGreen" },
        hl = { "fg", "GruvboxOrange" },
        ["hl+"] = { "fg", "GruvboxRed" },
      },
      files = {
        prompt = "Files> ",
        cmd = "rg --files --hidden --follow -g '!.git'",
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
      previewers = {
        builtin = {
          extensions = {
            ["png"] = { "chafa", "{file}" },
            ["jpg"] = { "chafa", "{file}" },
            ["jpeg"] = { "chafa", "{file}" },
            ["gif"] = { "chafa", "{file}" },
            ["webp"] = { "chafa", "{file}" },
          },
        },
      },
      grep = {
        prompt = "Grep> ",
        actions = {
          ["default"] = require("fzf-lua").actions.file_edit,
          ["ctrl-s"] = require("fzf-lua").actions.file_split,
          ["ctrl-v"] = require("fzf-lua").actions.file_vsplit,
          ["ctrl-t"] = require("fzf-lua").actions.file_tabedit,
        },
      },
      buffers = {
        prompt = "Buffers> ",
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