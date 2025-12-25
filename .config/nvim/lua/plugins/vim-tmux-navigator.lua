-- ==================
-- VIM TMUX NAVIGATOR
-- ==================

return {
  "christoomey/vim-tmux-navigator",
  config = function()
    -- Disable default mappings if you want to set custom ones
    vim.g.tmux_navigator_no_mappings = 0
    
    -- Save on focus lost (useful when switching between vim and tmux panes)
    vim.g.tmux_navigator_save_on_switch = 2
    
    -- Disable when in insert mode
    vim.g.tmux_navigator_disable_when_zoomed = 1
  end,
}