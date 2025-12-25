-- ======
-- MASON
-- ======
-- Automatic LSP server, formatter, and linter installer

return {
  -- Mason core
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason integration with lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        -- Automatically install these language servers
        ensure_installed = {
          "ts_ls",        -- TypeScript/JavaScript
          "eslint",       -- ESLint LSP (for linting and code actions)
          "cssls",        -- CSS
          "tailwindcss",  -- Tailwind CSS
          "html",         -- HTML
          "jsonls",       -- JSON
          "intelephense", -- PHP (best for Laravel)
          "lua_ls",       -- Lua (for Neovim config)
        },
        automatic_installation = true,
      })
    end,
  },

  -- Automatically install formatters and linters
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "prettier",    -- JS/TS/CSS/HTML formatter
          "stylua",      -- Lua formatter
          "php-cs-fixer", -- PHP formatter

          -- Linters (Note: eslint is now an LSP, not a standalone tool)
          "phpcs",       -- PHP linter
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },
}

