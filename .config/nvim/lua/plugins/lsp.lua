-- LSP: mason installs servers, lspconfig ships configs, blink adds capabilities.
return {
  { "mason-org/mason.nvim", cmd = "Mason", opts = { ui = { border = "rounded" } } },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason-lspconfig.nvim" },
      "mason-org/mason.nvim",
      "saghen/blink.cmp",
    },
    opts = {
      -- servers managed by mason-lspconfig + enabled below
      servers = {
        vtsls = {},
        intelephense = {},
        html = {},
        cssls = {},
        tailwindcss = {},
        jsonls = {},
        emmet_language_server = {},
        bashls = {},
        yamlls = {},
        marksman = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim", "Snacks" } },
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- Global capabilities from blink for every server.
      local caps = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = caps })

      -- Per-server settings.
      for name, cfg in pairs(opts.servers) do
        if next(cfg) ~= nil then
          vim.lsp.config(name, cfg)
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        automatic_enable = true,
      })

      -- Diagnostics UI
      vim.diagnostic.config({
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      -- Buffer-local keymaps on attach. (gd/gr/gI/symbols live in snacks.)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local function m(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = ev.buf, desc = desc })
          end
          m("K", vim.lsp.buf.hover, "Hover")
          m("gD", vim.lsp.buf.declaration, "Goto declaration")
          m("gy", vim.lsp.buf.type_definition, "Goto type definition")
          m("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          m("<leader>cr", vim.lsp.buf.rename, "Rename")
          m("<leader>cs", vim.lsp.buf.signature_help, "Signature help")
          m("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
        end,
      })
    end,
  },
}
