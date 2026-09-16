-- PDF sidebar for LaTeX: the current page, drawn inside a Neovim window.
--
-- Neovim cannot display an image itself, and :terminal cannot host a terminal
-- PDF viewer either — libvterm drops the kitty graphics escapes. image.nvim
-- sidesteps both by writing those escapes straight to the terminal, positioned
-- over the window that is meant to hold the picture. So the window here is an
-- empty scratch buffer whose only job is to reserve the rectangle.
--
-- Pages are rasterised on demand with pdftoppm rather than kept in memory: a
-- thesis is a few hundred pages and only one of them is ever on screen.

local M = {}

local state = {
  win = nil,
  buf = nil,
  image = nil,
  slot = "a",
  png = nil,
  pdf = nil,
  stamp = nil,
  aspect = nil,
  page = 1,
  pages = 1,
  fitting = false,
}

local DPI = 150
local cache_dir = vim.fn.stdpath("cache") .. "/latex-preview"

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.WARN, { title = "PDF preview" })
end

local function is_open()
  return state.win ~= nil and vim.api.nvim_win_is_valid(state.win)
end

-- Path of the PDF latexmk produces for the current document. VimTeX knows it
-- (it accounts for out_dir), but only exposes it through a Vimscript funcref.
local function pdf_path()
  if not vim.b.vimtex then
    return nil, "not a VimTeX buffer"
  end
  local ok, path = pcall(vim.fn.eval, 'b:vimtex.compiler.get_file("pdf")')
  if not ok or type(path) ~= "string" then
    return nil, "could not work out the PDF path"
  end
  return path
end

-- Page count and page shape in one call, since both come from the same header.
local function page_geometry(pdf)
  local pages, aspect = 1, nil
  local out = vim.fn.systemlist({ "pdfinfo", pdf })
  if vim.v.shell_error ~= 0 then
    return pages, aspect
  end
  for _, line in ipairs(out) do
    local n = line:match("^Pages:%s+(%d+)")
    if n then
      pages = tonumber(n)
    end
    local w, h = line:match("^Page size:%s+([%d%.]+) x ([%d%.]+)")
    if w and h and tonumber(h) > 0 then
      aspect = tonumber(w) / tonumber(h)
    end
  end
  return pages, aspect
end

-- The file name carries the PDF's mtime because image.nvim caches by path: a
-- rebuilt page written back to the same name would keep showing the old image.
local function rasterize(pdf, page)
  vim.fn.mkdir(cache_dir, "p")
  local stamp = vim.fn.getftime(pdf)
  local key = vim.fn.sha256(pdf):sub(1, 16)
  local prefix = string.format("%s/%s-%d-%d", cache_dir, key, stamp, page)
  local png = prefix .. ".png"

  -- Every rebuild starts a new generation of page images. Without this the
  -- cache would keep one PNG per page per compile, which over a thesis is
  -- thousands of files nobody will ever look at again.
  for _, stale in ipairs(vim.fn.glob(cache_dir .. "/" .. key .. "-*.png", false, true)) do
    if not stale:match("^" .. vim.pesc(cache_dir .. "/" .. key .. "-" .. stamp .. "-")) then
      vim.fn.delete(stale)
    end
  end

  if vim.fn.filereadable(png) == 0 then
    -- -singlefile keeps the name predictable; without it pdftoppm appends a
    -- zero-padded page number whose width depends on the page count.
    local out = vim.fn.system({
      "pdftoppm", "-png", "-singlefile",
      "-r", tostring(DPI),
      "-f", tostring(page), "-l", tostring(page),
      pdf, prefix,
    })
    if vim.v.shell_error ~= 0 then
      return nil, "pdftoppm failed: " .. out
    end
  end
  return png
end

-- Match the split's width to the shape of the page. The image keeps its aspect
-- ratio, so a portrait page in a window of any other shape is letterboxed —
-- which is what "not filling the split" looks like. Sizing the window to the
-- page instead means the two agree and the page fills it edge to edge.
local function fit_window()
  if not is_open() or not state.aspect or state.fitting then
    return
  end
  local ok, term = pcall(require, "image.utils.term")
  if not ok then
    return
  end
  local size = term.get_size()
  if not size or not size.cell_width or size.cell_width == 0 or size.cell_height == 0 then
    return
  end

  local rows = vim.api.nvim_win_get_height(state.win)
  local cols = math.floor((rows * size.cell_height * state.aspect) / size.cell_width + 0.5)
  -- Never squeeze the source below roughly a third of the screen.
  cols = math.max(20, math.min(cols, math.floor(vim.o.columns * 0.66)))

  state.fitting = true
  pcall(vim.api.nvim_win_set_width, state.win, cols)
  state.fitting = false
end

local function draw()
  if not is_open() or not state.png then
    return
  end

  local ok, image = pcall(require, "image")
  if not ok then
    return notify("image.nvim is not available")
  end

  -- Two alternating ids so the new page can be put on screen before the old
  -- one is taken off. Clearing first leaves the window blank for a frame,
  -- which during continuous compilation reads as a constant blink.
  local previous = state.image
  state.slot = state.slot == "a" and "b" or "a"

  local img = image.from_file(state.png, {
    id = "latex-preview-" .. state.slot,
    window = state.win,
    buffer = state.buf,
    x = 0,
    y = 0,
    -- Both percentages have to be given: the plugin caps images at half the
    -- window height by default (lua/image/init.lua).
    max_width_window_percentage = 100,
    max_height_window_percentage = 100,
  })
  if not img then
    return notify("could not build the image")
  end

  img:render()
  state.image = img
  if previous then
    pcall(function()
      previous:clear()
    end)
  end

  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_set_name(state.buf, string.format("PDF %d/%d", state.page, state.pages))
  end
end

local function show_page(page)
  if not state.pdf then
    return
  end
  state.page = math.max(1, math.min(page, state.pages))
  local png, err = rasterize(state.pdf, state.page)
  if not png then
    return notify(err)
  end
  state.png = png
  draw()
end

function M.next_page()
  show_page(state.page + 1)
end

function M.prev_page()
  show_page(state.page - 1)
end

-- Called after every successful compile. latexmk runs continuously and
-- auto-save fires on TextChanged, so this is hit constantly while typing;
-- redrawing an unchanged page would be a visible blink for nothing.
function M.refresh()
  if not is_open() or not state.pdf then
    return
  end
  if vim.fn.filereadable(state.pdf) == 0 then
    return
  end

  local stamp = vim.fn.getftime(state.pdf)
  if stamp == state.stamp then
    return
  end
  state.stamp = stamp

  -- The page count can change, and the current page may no longer exist if the
  -- document got shorter.
  state.pages, state.aspect = page_geometry(state.pdf)
  fit_window()
  show_page(state.page)
end

local function forget_window()
  state.win, state.buf, state.png = nil, nil, nil
end

local function clear_image()
  if state.image then
    pcall(function()
      state.image:clear()
    end)
    state.image = nil
  end
end

function M.close()
  clear_image()
  if is_open() then
    vim.api.nvim_win_close(state.win, true)
  end
  forget_window()
end

local function setup_buffer(buf)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "pdfpreview"

  local map = function(lhs, fn, desc)
    vim.keymap.set("n", lhs, fn, { buffer = buf, desc = desc })
  end
  map("j", M.next_page, "PDF: next page")
  map("<Down>", M.next_page, "PDF: next page")
  map("k", M.prev_page, "PDF: previous page")
  map("<Up>", M.prev_page, "PDF: previous page")
  map("r", M.refresh, "PDF: refresh")
  map("q", M.close, "PDF: close preview")
end

function M.open()
  if is_open() then
    return
  end

  local pdf, err = pdf_path()
  if not pdf then
    return notify(err)
  end
  if vim.fn.filereadable(pdf) == 0 then
    return notify("No PDF yet — start the compiler with \\ll first.")
  end

  local source_win = vim.api.nvim_get_current_win()
  vim.cmd("vsplit") -- splitright is set, so this lands on the right
  state.win = vim.api.nvim_get_current_win()
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(state.win, state.buf)
  setup_buffer(state.buf)

  -- Chrome would eat into the rectangle the page is drawn in.
  local wo = vim.wo[state.win]
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = "no"
  wo.cursorline = false
  wo.list = false
  wo.wrap = false
  wo.winfixwidth = true
  wo.spell = false

  state.pdf = pdf
  state.stamp = vim.fn.getftime(pdf)
  state.pages, state.aspect = page_geometry(pdf)
  state.page = 1

  -- Typing continues in the source; the preview is looked at, not worked in.
  vim.api.nvim_set_current_win(source_win)
  fit_window()
  show_page(1)
end

function M.toggle()
  if is_open() then
    M.close()
  else
    M.open()
  end
end

-- Redraw when the rectangle moves or changes size, and whenever VimTeX
-- finishes a compile.
function M.attach_autocmds()
  local group = vim.api.nvim_create_augroup("latex_preview", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VimtexEventCompileSuccess",
    callback = function()
      M.refresh()
    end,
  })

  vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    group = group,
    callback = function()
      -- fit_window resizes a window, which raises WinResized again; the guard
      -- inside it keeps that from recursing.
      if is_open() then
        fit_window()
        draw()
      end
    end,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    callback = function(ev)
      if is_open() and tonumber(ev.match) == state.win then
        clear_image()
        forget_window()
      end
    end,
  })
end

return M
