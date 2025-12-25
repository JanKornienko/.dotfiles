-- =========
-- NONE-LS
-- =========
-- Formatters and linters integration (fork of null-ls)
--
-- NOTE: ESLint support has been removed from none-ls builtins.
-- For ESLint, use the native ESLint LSP server instead:
-- Add 'eslint' to Mason's ensure_installed in mason.lua
-- It will work automatically with lspconfig.

return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    -- Setup sources
    local sources = {
      -- =====================
      -- JavaScript/TypeScript
      -- =====================
      
      -- Prettier for formatting
      formatting.prettier.with({
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "css",
          "scss",
          "less",
          "html",
          "json",
          "jsonc",
          "yaml",
          "markdown",
          "markdown.mdx",
          "graphql",
          "handlebars",
        },
        extra_args = { 
          "--single-quote", 
          "--jsx-single-quote",
          "--use-tabs",
          "--tab-width=2",
          "--no-cache",  -- Prevent creating .prettier-cache files
        },
      }),

      -- =====
      -- Lua
      -- =====
      
      -- StyLua for Lua formatting
      formatting.stylua,
    }

    -- Add PHP sources if available (conditionally check for optional tools)
    if formatting.phpcsfixer then
      table.insert(sources, formatting.phpcsfixer.with({
        extra_args = { 
          "--rules=@PSR12",
          "--using-cache=no",  -- Prevent creating .php-cs-fixer.cache files
        },
      }))
    end

    if diagnostics.phpcs then
      table.insert(sources, diagnostics.phpcs.with({
        args = { "--standard=PSR12", "--report=json", "-s", "-" },
      }))
    end

    null_ls.setup({
      sources = sources,

      -- Format on save is DISABLED to avoid conflicts with autosave
      -- Use <leader>f for manual formatting (configured in lspconfig.lua)
      -- If you want format-on-save back, uncomment the on_attach function below
      
      -- on_attach = function(client, bufnr)
      --   if client.supports_method("textDocument/formatting") then
      --     -- Create autocommand for format on save
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
      --       buffer = bufnr,
      --       callback = function()
      --         vim.lsp.buf.format({
      --           filter = function(format_client)
      --             -- Only use null-ls for formatting
      --             return format_client.name == "null-ls"
      --           end,
      --           bufnr = bufnr,
      --         })
      --       end,
      --     })
      --   end
      -- end,
    })

    -- Manual formatting keybinding (alternative to <leader>f from lspconfig)
    vim.keymap.set("n", "<leader>gf", function()
      vim.lsp.buf.format({ 
        async = true,
        filter = function(client)
          -- Prefer null-ls for formatting
          return client.name == "null-ls"
        end,
      })
    end, { desc = "Format buffer with null-ls" })
  end,
}

