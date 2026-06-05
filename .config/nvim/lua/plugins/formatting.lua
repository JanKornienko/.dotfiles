-- Format (conform) + lint (nvim-lint). Biome primary for web; prettier fills gaps.
return {
  -- Auto-install formatters/linters via mason.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "biome",
        "prettier",
        "stylua",
        "shfmt",
        "shellcheck",
        "pint",
        "php-cs-fixer",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true }) end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = { timeout_ms = 1500, lsp_format = "fallback" },
      formatters_by_ft = {
        javascript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "biome", "prettier", stop_after_first = true },
        jsonc = { "biome", "prettier", stop_after_first = true },
        css = { "biome", "prettier", stop_after_first = true },
        scss = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        php = { "pint", "php_cs_fixer", stop_after_first = true },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "biomejs" },
        javascriptreact = { "biomejs" },
        typescript = { "biomejs" },
        typescriptreact = { "biomejs" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
      local grp = vim.api.nvim_create_augroup("dotfiles_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = grp,
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
