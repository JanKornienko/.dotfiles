-- =========
-- NULL-LS
-- =========

return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "williamboman/mason.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    -- Configure null-ls
    null_ls.setup({
      debug = false,
      sources = {
        -- Formatting
        formatting.prettier.with({
          -- Use project-specific Prettier config if available
          prefer_local = true,
          -- Fallback to Mason-installed Prettier
          fallback = true,
          -- Only format files that Prettier supports
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "json",
            "jsonc",
            "css",
            "scss",
            "less",
            "html",
            "vue",
            "yaml",
            "markdown",
            "graphql",
            "mdx",
          },
          -- Use project-specific .prettierrc, .prettierrc.json, etc.
          condition = function(utils)
            return utils.root_has_file({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.yaml",
              ".prettierrc.yml",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
              "package.json",
            })
          end,
        }),

      },
      -- Auto-format on save
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(client)
                  -- Only use null-ls for formatting
                  return client.name == "null-ls"
                end,
              })
            end,
          })
        end
      end,
    })
  end,
}
