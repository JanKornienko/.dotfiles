-- ========
-- NVIM-CMP
-- ========

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- LSP completion source
    "hrsh7th/cmp-nvim-lsp",
    
    -- Buffer completion source
    "hrsh7th/cmp-buffer",
    
    -- Path completion source
    "hrsh7th/cmp-path",
    
    -- Snippet completion source
    "saadparwaiz1/cmp_luasnip",
    
    -- Snippet engine
    "L3MON4D3/LuaSnip",
    
    -- VSCode-like pictograms for completion menu
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- Key mappings
      mapping = cmp.mapping.preset.insert({
        -- Select previous/next item
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        
        -- Scroll documentation window
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        
        -- Open completion menu
        ["<C-Space>"] = cmp.mapping.complete(),
        
        -- Close completion menu
        ["<C-e>"] = cmp.mapping.abort(),
        
        -- Confirm selection
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        
        -- Tab to select next item or jump to next snippet field
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        
        -- Shift-Tab to select previous item or jump to previous snippet field
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      -- Completion sources (in priority order)
      sources = cmp.config.sources({
        { name = "nvim_lsp" },  -- LSP
        { name = "luasnip" },   -- Snippets
        { name = "path" },      -- File paths
      }, {
        { name = "buffer" },    -- Buffer words
      }),

      -- Formatting with icons
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          
          -- Show source in menu
          menu = {
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            buffer = "[Buf]",
            path = "[Path]",
          },
        }),
      },

      -- Window appearance
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      -- Experimental features
      experimental = {
        ghost_text = true,  -- Show ghost text for completion
      },
    })
  end,
}