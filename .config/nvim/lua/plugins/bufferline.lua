-- ==========
-- BUFFERLINE
-- ==========

return {
  "akinsho/bufferline.nvim",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
  },
  opts = {
    options = {
      -- stylua: ignore
      close_command = function(n) vim.api.nvim_buf_delete(n, { force = true }) end,
      -- stylua: ignore
      right_mouse_command = function(n) vim.api.nvim_buf_delete(n, { force = true }) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_buffer_icons = true,
      show_tab_indicators = true,
      diagnostics_indicator = function(_, _, diag)
        local icons = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        }
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
      },
      -- Gruvbox theme colors for bufferline
      highlights = {
        fill = {
          fg = { attribute = "fg", highlight = "GruvboxBg2" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
        },
        background = {
          fg = { attribute = "fg", highlight = "GruvboxFg1" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        tab = {
          fg = { attribute = "fg", highlight = "GruvboxFg1" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        tab_selected = {
          fg = { attribute = "fg", highlight = "GruvboxFg1" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
        },
        tab_close = {
          fg = { attribute = "fg", highlight = "GruvboxRed" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        close_button = {
          fg = { attribute = "fg", highlight = "GruvboxFg1" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        close_button_selected = {
          fg = { attribute = "fg", highlight = "GruvboxRed" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
        },
        buffer_selected = {
          fg = { attribute = "fg", highlight = "GruvboxFg1" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
          bold = true,
        },
        buffer_visible = {
          fg = { attribute = "fg", highlight = "GruvboxFg1" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        separator = {
          fg = { attribute = "bg", highlight = "GruvboxBg0" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        separator_selected = {
          fg = { attribute = "bg", highlight = "GruvboxBg0" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
        },
        separator_visible = {
          fg = { attribute = "bg", highlight = "GruvboxBg0" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        modified = {
          fg = { attribute = "fg", highlight = "GruvboxOrange" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        modified_selected = {
          fg = { attribute = "fg", highlight = "GruvboxOrange" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
        },
        modified_visible = {
          fg = { attribute = "fg", highlight = "GruvboxOrange" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        duplicate_selected = {
          fg = { attribute = "fg", highlight = "GruvboxFg1" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
          italic = true,
        },
        duplicate_visible = {
          fg = { attribute = "fg", highlight = "GruvboxFg1" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
          italic = true,
        },
        duplicate = {
          fg = { attribute = "fg", highlight = "GruvboxFg1" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
          italic = true,
        },
        pick = {
          fg = { attribute = "fg", highlight = "GruvboxBg0" },
          bg = { attribute = "fg", highlight = "GruvboxGreen" },
        },
        pick_selected = {
          fg = { attribute = "fg", highlight = "GruvboxBg0" },
          bg = { attribute = "fg", highlight = "GruvboxGreen" },
        },
        pick_visible = {
          fg = { attribute = "fg", highlight = "GruvboxBg0" },
          bg = { attribute = "fg", highlight = "GruvboxGreen" },
        },
        error = {
          fg = { attribute = "fg", highlight = "GruvboxRed" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        error_selected = {
          fg = { attribute = "fg", highlight = "GruvboxRed" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
        },
        error_visible = {
          fg = { attribute = "fg", highlight = "GruvboxRed" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        warning = {
          fg = { attribute = "fg", highlight = "GruvboxOrange" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        warning_selected = {
          fg = { attribute = "fg", highlight = "GruvboxOrange" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
        },
        warning_visible = {
          fg = { attribute = "fg", highlight = "GruvboxOrange" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        info = {
          fg = { attribute = "fg", highlight = "GruvboxBlue" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        info_selected = {
          fg = { attribute = "fg", highlight = "GruvboxBlue" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
        },
        info_visible = {
          fg = { attribute = "fg", highlight = "GruvboxBlue" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        hint = {
          fg = { attribute = "fg", highlight = "GruvboxGray" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
        hint_selected = {
          fg = { attribute = "fg", highlight = "GruvboxGray" },
          bg = { attribute = "bg", highlight = "GruvboxBg0" },
        },
        hint_visible = {
          fg = { attribute = "fg", highlight = "GruvboxGray" },
          bg = { attribute = "bg", highlight = "GruvboxBg1" },
        },
      },
      ---@param opts bufferline.IconFetcherOpts
      get_element_icon = function(opts)
        local icon_map = {
          lua = "",
          vim = "",
          js = "",
          ts = "",
          jsx = "",
          tsx = "",
          json = "",
          yaml = "",
          yml = "",
          markdown = "",
          md = "",
          python = "",
          rust = "",
          html = "",
          css = "",
          scss = "",
          sql = "",
          sh = "",
          zsh = "",
          git = "",
        }
        return icon_map[opts.filetype] or ""
      end,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    
    -- Force bufferline to show
    vim.opt.showtabline = 2
    
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(require, "bufferline")
        end)
      end,
    })
    
    -- Ensure bufferline is visible on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.schedule(function()
          require("bufferline").refresh()
        end)
      end,
    })
  end,
}
