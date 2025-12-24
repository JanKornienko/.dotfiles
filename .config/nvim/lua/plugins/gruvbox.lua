-- Add gruvbox colorscheme and configure LazyVim to use it
return {
  -- Add the gruvbox plugin
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to use gruvbox as the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}

