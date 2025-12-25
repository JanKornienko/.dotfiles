-- =====
-- THEME
-- =====

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
      -- Use hard contrast for more pronounced theme
      contrast = "hard",
    })
    
    -- Apply the colorscheme
    vim.cmd([[colorscheme gruvbox]])
    
    -- Make signcolumn match background color (transparent/matches Normal background)
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    
    -- Toggle function for switching between light and dark mode
    local function toggle_background()
      if vim.o.background == "dark" then
        vim.o.background = "light"
      else
        vim.o.background = "dark"
      end
      -- Reload colorscheme to apply changes
      vim.cmd([[colorscheme gruvbox]])
    end
    
    -- Function to set background from external command
    local function set_background(mode)
      vim.o.background = mode
      vim.cmd([[colorscheme gruvbox]])
    end
    
    -- Add keymap to toggle between light and dark mode
    vim.keymap.set("n", "<leader>tb", toggle_background, { desc = "Toggle background (light/dark)" })
    
    -- Create a command that can be called from tmux
    vim.api.nvim_create_user_command("SetBackground", function(opts)
      if opts.args == "light" or opts.args == "dark" then
        set_background(opts.args)
      else
        vim.notify("Usage: SetBackground [light|dark]", vim.log.levels.ERROR)
      end
    end, { nargs = 1, desc = "Set background to light or dark" })
  end,
  opts = {
    undercurl = true,
  },
}