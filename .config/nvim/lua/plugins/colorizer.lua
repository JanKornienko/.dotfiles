return {
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        mode = "background",
        names = false,
      },
    },
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
}
