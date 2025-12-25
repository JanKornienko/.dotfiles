-- =====
-- IMAGE
-- =====

return {
  "3rd/image.nvim",
  dependencies = {
    "leafo/magick",
  },
  opts = {
    backend = "kitty", -- kitty backend works with iTerm2
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
      neorg = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "norg" },
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = false,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = true, -- Important for tmux
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  },
  config = function(_, opts)
    -- Check if we're in tmux and if passthrough is enabled
    local in_tmux = vim.env.TMUX ~= nil
    
    if in_tmux then
      -- Try to setup with better error handling
      local ok, err = pcall(require("image").setup, opts)
      if not ok then
        vim.notify(
          "image.nvim failed to load. Make sure tmux has 'allow-passthrough on' in .tmux.conf\n" ..
          "Run: tmux set -g allow-passthrough on\n" ..
          "Or reload your tmux config: tmux source ~/.tmux.conf",
          vim.log.levels.WARN
        )
      end
    else
      -- Not in tmux, should work fine
      require("image").setup(opts)
    end
    
    -- Hide binary content when viewing image files
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.bmp", "*.ico" },
      callback = function()
        -- Hide the buffer content
        vim.opt_local.conceallevel = 3
        vim.opt_local.concealcursor = "nvic"
        
        -- Make buffer unmodifiable and hide line numbers
        vim.opt_local.modifiable = false
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        
        -- Hide the actual buffer lines by replacing with empty space
        vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
        
        -- Set filetype to image for better recognition
        vim.bo.filetype = "image"
      end,
    })
  end,
}