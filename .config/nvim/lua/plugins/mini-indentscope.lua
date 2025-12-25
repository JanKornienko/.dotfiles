-- ================
-- MINI-INDENTSCOPE
-- ================

return {
  "echasnovski/mini.indentscope",
  version = false,
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local indentscope = require('mini.indentscope')
    
    indentscope.setup({
      -- Draw options
      draw = {
        -- Delay (in ms) between event and start of drawing scope indicator
        delay = 50,
        
        -- Animation rule - set to none for instant display
        animation = indentscope.gen_animation.none(),
        
        -- Symbol priority
        priority = 2,
      },
      
      -- Module mappings
      mappings = {
        -- Textobjects
        object_scope = 'ii',
        object_scope_with_border = 'ai',
        
        -- Motions (jump to respective border line)
        goto_top = '[i',
        goto_bottom = ']i',
      },
      
      -- Options which control scope computation
      options = {
        -- Type of scope's border: 'both', 'top', 'bottom', 'none'
        border = 'both',
        
        -- Whether to use cursor column when computing reference indent
        indent_at_cursor = true,
        
        -- Try to use line as border first (useful for function headers)
        try_as_border = false,
      },
      
      -- Which character to use for drawing scope indicator
      symbol = '▎',
    })
    
    -- Customize highlight color (Gruvbox orange, bold)
    vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { 
      fg = '#fe8019', 
      bold = true 
    })
    
    -- Disable in certain filetypes
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'help',
        'alpha',
        'dashboard',
        'neo-tree',
        'Trouble',
        'lazy',
        'mason',
        'notify',
        'toggleterm',
        'lazyterm',
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}