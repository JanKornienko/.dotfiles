-- ======
-- THEME
-- ======

return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    -- Set background to dark to match GruvboxDark.itermcolors
    vim.o.background = "dark"
    
    -- Setup gruvbox with configuration
    require("gruvbox").setup({
      undercurl = true,
      -- Ensure terminal colors are enabled for better iTerm integration
      terminal_colors = true,
      -- Use hard contrast for more pronounced dark theme
      contrast = "hard",
    })
    
    -- Apply the colorscheme
    vim.cmd([[colorscheme gruvbox]])
  end,
  opts = {
    undercurl = true,
  },
}