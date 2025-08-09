-- ==============
-- NVIM-LSPCONFIG
-- ==============

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Configure diagnostics
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    -- Setup mason-lspconfig
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "rust_analyzer",
        "jsonls",
        "yamlls",
        "html",
        "cssls",
        "bashls",
      },
      automatic_installation = true,
    })

    -- Setup LSP servers
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Lua LSP
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          codeLens = {
            enable = true,
          },
          completion = {
            callSnippet = "Replace",
          },
          doc = {
            privateName = { "^_" },
          },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      },
    })

    -- TypeScript/JavaScript LSP
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
    })

    -- Python LSP
    lspconfig.pyright.setup({
      capabilities = capabilities,
    })

    -- Rust LSP
    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
    })

    -- JSON LSP
    lspconfig.jsonls.setup({
      capabilities = capabilities,
    })

    -- YAML LSP
    lspconfig.yamlls.setup({
      capabilities = capabilities,
    })

    -- HTML LSP
    lspconfig.html.setup({
      capabilities = capabilities,
    })

    -- CSS LSP
    lspconfig.cssls.setup({
      capabilities = capabilities,
    })

    -- Bash LSP
    lspconfig.bashls.setup({
      capabilities = capabilities,
    })

    -- Global LSP keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      end,
    })
  end,
}
