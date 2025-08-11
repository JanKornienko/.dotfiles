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
        "tailwindcss",
      },
      automatic_installation = true,
    })

    -- Setup LSP servers
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Helper function for better go-to-definition behavior
    local function goto_definition()
      local params = vim.lsp.util.make_position_params(0, 'utf-8')
      vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
        if err then
          vim.notify('Error getting definition: ' .. err.message, vim.log.levels.ERROR)
          return
        end
        
        if not result or vim.tbl_isempty(result) then
          vim.notify('No definition found', vim.log.levels.WARN)
          return
        end
        
        -- If there's only one result, jump directly
        if #result == 1 then
          vim.lsp.util.show_document(result[1], 'utf-8', {focus = true})
        else
          -- If multiple results, use the default handler which shows the list
          vim.lsp.buf.definition()
        end
      end)
    end

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

    -- TypeScript/JavaScript LSP with enhanced settings
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      settings = {
        typescript = {
          preferences = {
            -- Prefer go-to-source-definition over compiled .d.ts files
            includePackageJsonAutoImports = "off",
          },
        },
        javascript = {
          preferences = {
            includePackageJsonAutoImports = "off",
          },
        },
      },
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

    -- Tailwind CSS LSP
    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              "cva\\(([^)]*)\\)",
              "[\"'`]([^\"'`]*).*?[\"'`]",
            },
          },
          lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidConfigPath = "error",
            invalidScreen = "error",
            invalidTailwindDirective = "error",
            invalidVariant = "error",
            recommendedVariantOrder = "warning",
          },
        },
      },
    })

    -- Global LSP keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        
        -- Enhanced navigation keymaps
        vim.keymap.set("n", "gd", goto_definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        
        -- Alternative keymaps for different definition behaviors
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts) -- Always show list
        vim.keymap.set("n", "<leader>gs", function()
          -- Try to go to source definition (TypeScript specific)
          vim.lsp.buf_request(0, 'typescript/goToSourceDefinition', vim.lsp.util.make_position_params(0, 'utf-8'), 
            function(err, result, ctx, config)
              if err or not result or vim.tbl_isempty(result) then
                -- Fallback to regular definition
                goto_definition()
              else
                vim.lsp.util.show_document(result[1], 'utf-8', {focus = true})
              end
            end)
        end, opts)
        
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        
        -- Safer hover function that won't break the screen
        vim.keymap.set("n", "K", function()
          local ok, result = pcall(vim.lsp.buf.hover)
          if not ok then
            vim.notify("Hover not available", vim.log.levels.WARN)
          end
        end, opts)
        
        -- Disable LSP formatting for null-ls to handle
        if client and client.name ~= "null-ls" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end,
    })
  end,
}