-- LaTeX: VimTeX drives latexmk, the PDF shows up next to the editor.
--
-- Two viewers, because neither does the other's job:
--   \lp  a sidebar inside Neovim — image.nvim draws the page over a window
--   \lv  Skim — the only one that speaks SyncTeX, so the only one that can
--        jump between a source line and its place on the page
-- Neither works through tmux: it has no kitty graphics support (tmux#4902),
-- and its passthrough returns the terminal's replies to whatever pane is
-- active, which types them into the document as text. Run nvim directly in
-- iTerm2 for the sidebar; see lua/latex_preview.lua.
--
-- Why VimTeX and not the texlab build: texlab rebuilds on save only, VimTeX
-- keeps latexmk running in continuous mode, so the PDF refreshes while typing.
-- texlab is still enabled (see lsp.lua) for \cite/\ref completion and chktex.
--
-- Written in Czech, so spell checking, hyphenation and conceal all assume cs.

local function tex_buffer_setup()
  local opt = vim.opt_local

  -- Prose, not code: wrap at the window edge on word boundaries and keep the
  -- indent, instead of the hard `nowrap` used everywhere else.
  opt.wrap = true
  opt.linebreak = true
  opt.breakindent = true
  opt.textwidth = 0

  -- Wrapped lines make j/k jump whole paragraphs; move by screen line instead.
  vim.keymap.set({ "n", "x" }, "j", "gj", { buffer = true, desc = "Down (screen line)" })
  vim.keymap.set({ "n", "x" }, "k", "gk", { buffer = true, desc = "Up (screen line)" })

  -- VimTeX conceals \alpha, \ldots, math delimiters etc. Needs conceallevel 2
  -- and concealcursor unset, or the line under the cursor renders differently
  -- from the rest and the text jumps as you move.
  opt.conceallevel = 2
  opt.concealcursor = ""

  -- Czech first, English second: both dictionaries are consulted, so English
  -- terms in the text are not flagged. cs.utf-8.spl is vendored in spell/.
  opt.spell = true
  opt.spelllang = { "cs", "en_us" }
  opt.spelloptions = "camel"
end

return {
  {
    "lervag/vimtex",
    dependencies = { "3rd/image.nvim" },
    -- VimTeX must not be lazy-loaded (upstream requirement): its ftplugin has
    -- to be on the runtimepath before the first *.tex file is read.
    lazy = false,
    -- Pinned: master (since 2026-07-22) refuses to load on anything below
    -- Neovim 0.12.4, and brew ships 0.11.x. v2.18 is the last release that
    -- still requires only 0.10. Drop the pin once Neovim 0.12 is on stable.
    version = "v2.18",
    init = function()
      -- ---------------------------------------------------------- viewer
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1 -- forward search after every compile
      vim.g.vimtex_view_skim_activate = 1 -- raise Skim on \lv
      vim.g.vimtex_view_skim_reading_bar = 1 -- highlight the synced line

      -- ---------------------------------------------------------- compiler
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        -- Keeps .aux/.log/.bbl/.synctex.gz out of the thesis repo. Skim still
        -- finds the PDF because VimTeX passes it the resolved path.
        out_dir = "build",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-shell-escape", -- some thesis templates need it (minted, pgfplots externalize)
        },
      }

      -- ---------------------------------------------------------- quickfix
      -- A thesis produces hundreds of box-badness warnings. Left unfiltered
      -- they bury the actual errors, so the noise is dropped.
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull \\\\hbox",
        "Overfull \\\\hbox",
        "LaTeX Warning: .\\+ float specifier changed to",
        "Package hyperref Warning: Token not allowed in a PDF string",
        "Font shape declaration has incorrect series value",
        "Package typearea Warning",
      }

      -- ---------------------------------------------------------- editing
      vim.g.vimtex_toc_config = {
        name = "TOC",
        layers = { "content", "todo", "include" },
        split_width = 40,
        show_help = 0,
        todo_sorted = 0,
      }
      -- Insert-mode `]]` closes the current environment; the rest of VimTeX's
      -- insert maps (``a -> alpha) stay on, they are handy for maths.
      vim.g.vimtex_imaps_enabled = 1
      vim.g.vimtex_matchparen_enabled = 1
      -- No default \l mappings we do not want; the prefix is localleader-l.
      vim.g.vimtex_mappings_prefix = "<localleader>l"

      -- ---------------------------------------------------------- buffers
      -- Registered here rather than in `config`: lazy.nvim can run `config`
      -- after FileType has already fired for a file passed on the command
      -- line, and the settings would then silently miss the first buffer.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("tex_prose", { clear = true }),
        pattern = { "tex", "plaintex", "bib" },
        callback = tex_buffer_setup,
      })

      -- Words added with `zg` land in the repo, so the personal dictionary of
      -- thesis-specific terms follows the dotfiles to every machine.
      local spelldir = vim.fn.stdpath("config") .. "/spell"
      vim.fn.mkdir(spelldir, "p")
      vim.opt.spellfile = spelldir .. "/cs.utf-8.add"

      require("latex_preview").attach_autocmds()
    end,
    keys = {
      { "<localleader>ll", "<cmd>VimtexCompile<cr>", ft = "tex", desc = "LaTeX: toggle continuous compile" },
      { "<localleader>lv", "<cmd>VimtexView<cr>", ft = "tex", desc = "LaTeX: forward search to cursor (Skim)" },
      {
        "<localleader>lp",
        function()
          require("latex_preview").toggle()
        end,
        ft = "tex",
        desc = "LaTeX: toggle PDF sidebar",
      },
      { "<localleader>lt", "<cmd>VimtexTocToggle<cr>", ft = "tex", desc = "LaTeX: table of contents" },
      { "<localleader>le", "<cmd>VimtexErrors<cr>", ft = "tex", desc = "LaTeX: errors" },
      { "<localleader>lc", "<cmd>VimtexClean<cr>", ft = "tex", desc = "LaTeX: clean aux files" },
      { "<localleader>ls", "<cmd>VimtexStop<cr>", ft = "tex", desc = "LaTeX: stop compiler" },
      { "<localleader>lw", "<cmd>VimtexCountWords<cr>", ft = "tex", desc = "LaTeX: word count" },
    },
  },

  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend = "kitty", -- iTerm2 speaks this protocol too, despite the name
      -- Avoids the ImageMagick luarock, which needs a luarocks toolchain on
      -- every machine; the CLI is already a poppler/texlive neighbour.
      processor = "magick_cli",
      integrations = {
        markdown = { enabled = false },
        neorg = { enabled = false },
        html = { enabled = false },
        css = { enabled = false },
      },
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true,
      tmux_show_only_in_active_window = true,
    },
  },
}
