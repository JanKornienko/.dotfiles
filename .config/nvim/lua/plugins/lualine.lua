-- =======
-- LUALINE
-- =======

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "gruvbox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { 
          "branch", 
          {
            "diff",
            colored = true,
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = false,
            path = 1, -- 0: Just the filename, 1: Relative path, 2: Absolute path
            symbols = {
              modified = "[+]",
              readonly = "[RO]",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " " },
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = false,
            path = 1, -- 0: Just the filename, 1: Relative path, 2: Absolute path
            symbols = {
              modified = "[+]",
              readonly = "[RO]",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
        lualine_y = { 
          "progress",
          {
            function()
              local git_blame = require('gitblame')
              if git_blame.is_blame_text_available() then
                return git_blame.get_current_blame_text()
              end
              return ""
            end,
            cond = function()
              local git_blame = require('gitblame')
              return git_blame.is_blame_text_available()
            end,
          },
        },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { "nvim-tree", "lazy" },
    })
  end,
}
