-- ==========
-- COLORSCHEME
-- ==========

return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    require("onedark").setup({
      style = "darker", -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = false,
      term_colors = true,
      ending_tildes = false,
      cmp_itemkind_reverse = false,
      
      -- Custom colors to match One Dark Pro Night Flat
      colors = {
        bg0 = "#16191d",
        bg1 = "#1e2329",
        bg2 = "#282c34",
        bg3 = "#3e4451",
        bg_d = "#16191d",
        bg_blue = "#4c566a",
        bg_yellow = "#e5c07b",
        fg = "#abb2bf",
        purple = "#dd72e0",
        green = "#8cc165",
        orange = "#d19a66",
        blue = "#4aa5f0",
        yellow = "#f0df8a",
        cyan = "#4ec9b0",
        red = "#e05561",
        grey = "#4f5666",
        light_grey = "#6b727e",
        dark_cyan = "#2b6f77",
        dark_red = "#993939",
        dark_yellow = "#93691d",
        dark_purple = "#8a3fa0",
        diff_add = "#31392b",
        diff_delete = "#382b2c",
        diff_change = "#1c3448",
        diff_text = "#2c5372",
      },
      
      highlights = {
        ["@comment"] = { fg = "$grey", fmt = "italic" },
        ["@keyword"] = { fg = "$purple" },
        ["@string"] = { fg = "$green" },
        ["@number"] = { fg = "$orange" },
        ["@boolean"] = { fg = "$orange" },
        ["@function"] = { fg = "$blue" },
        ["@variable"] = { fg = "$fg" },
        ["@type"] = { fg = "$yellow" },
      }
    })
    
    vim.cmd.colorscheme("onedark")
  end,
} 