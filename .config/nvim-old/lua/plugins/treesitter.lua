-- ==========
-- TREESITTER
-- ==========

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false, -- treesitter should not be lazy-loaded
    config = function()
      -- Configure installation directory
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Install language parsers
      local parsers_to_install = {
        "bash",
        "c",
        "css",
        "dockerfile",
        "gitignore",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      }

      -- Install parsers asynchronously
      require("nvim-treesitter").install(parsers_to_install)

      -- Enable treesitter highlighting for all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Enable treesitter-based indentation
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Enable folding
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldenable = false -- Start with folds open
        end,
      })

      -- Incremental selection keymaps (built-in to Neovim's treesitter)
      vim.keymap.set("n", "<C-space>", function()
        vim.cmd("normal! v")
        vim.treesitter.select.select_incremental()
      end, { noremap = true, silent = true, desc = "Treesitter incremental selection" })

      vim.keymap.set("v", "<C-space>", function()
        vim.treesitter.select.select_incremental()
      end, { noremap = true, silent = true, desc = "Treesitter expand selection" })

      vim.keymap.set("v", "<BS>", function()
        vim.treesitter.select.select_decremental()
      end, { noremap = true, silent = true, desc = "Treesitter shrink selection" })
    end,
  },
}
