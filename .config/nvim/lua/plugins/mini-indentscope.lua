-- ================
-- MINI-INDENTSCOPE
-- ================

return {
  "echasnovski/mini.indentscope",
  opts = {
    draw = {
      delay = 100,
      max_lines = 500,
    },
    mappings = {
      object_scope = "ii",
      object_scope_with_border = "ai",
      goto_top = "[i",
      goto_bottom = "]i",
    },
    options = {
      border = "both",
      indent_at_cursor = true,
      try_as_border = false,
    },
    symbol = "▏",
  },
  config = function(_, opts)
    local indentscope = require("mini.indentscope")

    -- Disable animations
    opts.draw.animation = indentscope.gen_animation.none()

    indentscope.setup(opts)

    -- Disable for specific filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "neo-tree",      -- Neo-tree sidebar
        "TelescopePrompt",
        "help",
        "trouble",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}