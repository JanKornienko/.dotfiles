-- =====
-- MASON
-- =====

return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      max_concurrent_installers = 4,
      auto_update = false,
      automatic_installation = true,
    })

    -- Setup mason-lspconfig
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "clangd",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
      },
      automatic_installation = true,
    })
  end,
}
