-- =========
-- GITBLAME
-- =========

return {
  "f-person/git-blame.nvim",
  lazy = false,
  config = function()
    -- Disable virtual text globally
    vim.g.gitblame_display_virtual_text = 0
    
    require("gitblame").setup({
      -- Enable gitblame by default
      enabled = true,
      
      -- Message template
      message_template = "<author> • <date> • <summary>",
      
      -- Date format
      date_format = "%Y-%m-%d %H:%M",
      
      -- Highlight group for the blame message
      highlight_group = "Comment",
      
      -- Delay before showing blame info (in milliseconds)
      delay = 1000,
      
      -- Show blame info in virtual text
      virtual_text = false,
      
      -- Show blame info in statusline
      statusline = true,
      
      -- Force disable virtual text completely
      display_virtual_text = 0,
      
      -- Statusline integration
      statusline_format = "  %{gitblame#get_current_blame_text()}",
      
      -- Show blame info in command line
      command_line = false,
      
      -- Show blame info in popup
      popup = true,
      
      -- Popup options
      popup_options = {
        relative = "cursor",
        row = 1,
        col = 0,
        width = 60,
        height = 1,
        border = "rounded",
        style = "minimal",
      },
    })
  end,
  keys = {
    { "<leader>gb", "<cmd>GitBlameToggle<CR>", desc = "Toggle Git Blame" },
    { "<leader>gbs", "<cmd>GitBlameOpenFileURL<CR>", desc = "Open file URL in browser" },
    { "<leader>gbl", "<cmd>GitBlameCopySHA<CR>", desc = "Copy commit SHA" },
    { "<leader>gbr", "<cmd>GitBlameCopyFileURL<CR>", desc = "Copy file URL" },
  },
}
