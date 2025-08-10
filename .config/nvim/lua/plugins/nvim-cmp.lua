-- ========
-- NVIM-CMP
-- ========

return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },
  opts = function()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    return {
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<c-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<c-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<c-b>"] = cmp.mapping.scroll_docs(-4),
        ["<c-f>"] = cmp.mapping.scroll_docs(4),
        ["<c-space>"] = cmp.mapping.complete(),
        ["<c-e>"] = cmp.mapping.abort(),
        ["<cr>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<s-cr>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<c-c>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
      sorting = defaults.sorting,
    }
  end,
  ---@param opts cmp.ConfigSchema | {enable: boolean}
  config = function(_, opts)
    -- Set gruvbox theme colors for completion
    vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#928374", default = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#928374", strikethrough = true, default = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#83a598", bold = true, default = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#83a598", bold = true, default = true })
    vim.api.nvim_set_hl(0, "CmpItemKind", { fg = "#b8bb26", default = true })
    vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#928374", italic = true, default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#83a598", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#b8bb26", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#b8bb26", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#b8bb26", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#d3869b", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#d3869b", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#fabd2f", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#fabd2f", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#fabd2f", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#d3869b", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#fabd2f", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#d3869b", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#fabd2f", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#fb4934", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#8ec07c", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#d3869b", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#83a598", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#d3869b", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#83a598", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#d3869b", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#d3869b", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#fabd2f", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#b8bb26", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#b8bb26", default = true })
    vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#fabd2f", default = true })
    
    require("cmp").setup(opts)
  end,
}
