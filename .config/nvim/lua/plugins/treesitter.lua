-- Treesitter (stable master branch): highlight, indent, textobjects, autotag.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSBufEnable", "TSModuleInfo" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "bash",
        "bibtex",
        "css",
        "scss",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "php",
        "phpdoc",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      auto_install = true,
      -- The latex parser is deliberately excluded, not merely left out of
      -- ensure_installed: auto_install would otherwise retry it on every .tex
      -- buffer and fail every time, because this branch calls `tree-sitter
      -- generate --no-bindings` and the CLI dropped that flag in 0.27. Nothing
      -- is lost — VimTeX owns tex syntax, folds and textobjects, and its
      -- conceal only works when treesitter highlighting stays out of the way.
      ignore_install = { "latex" },
      highlight = { enable = true, disable = { "latex" } },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]m"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_previous_start = { ["[m"] = "@function.outer", ["[c"] = "@class.outer" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master", lazy = true },

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "tsx", "jsx", "php", "xml", "vue", "svelte", "markdown" },
    opts = {},
  },
}
