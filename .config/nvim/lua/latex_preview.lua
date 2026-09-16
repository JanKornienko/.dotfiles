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
  png = nil,
  pdf = nil,
  page = 1,
  pages = 1,
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

local function page_count(pdf)
  local out = vim.fn.systemlist({ "pdfinfo", pdf })
  if vim.v.shell_error ~= 0 then
    return 1
  end
  for _, line in ipairs(out) do
    local n = line:match("^Pages:%s+(%d+)")
    if n then
      return tonumber(n)
    end
  end
  return 1
end

-- The file name carries the PDF's mtime because image.nvim caches by path: a
-- rebuilt page written back to the same name would keep showing the old image.
local function rasterize(pdf, page)
  vim.fn.mkdir(cache_dir, "p")
  local stamp = vim.fn.getftime(pdf)
  local key = vim.fn.sha256(pdf):sub(1, 16)
  local prefix = string.format("%s/%s-%d-%d", cache_dir, key, stamp, page)
  local png = prefix .. ".png"

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

local function clear_image()
  if state.image then
    pcall(function()
      state.image:clear()
    end)
    state.image = nil
  end
end

local function draw()
  if not is_open() or not state.png then
    return
  end
  clear_image()

  local ok, image = pcall(require, "image")
  if not ok then
    return notify("image.nvim is not available")
  end

  local width = vim.api.nvim_win_get_width(state.win)
  local height = vim.api.nvim_win_get_height(state.win)

  -- Only the height is constrained. Giving both would stretch the page, and a
  -- thesis page is taller than it is wide, so height is the binding dimension.
  local img = image.from_file(state.png, {
    id = "latex-preview",
    window = state.win,
    buffer = state.buf,
    x = 0,
    y = 0,
    height = height,
  })
  if not img then
    return notify("could not build the image")
  end
  state.image = img
  img:render()

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

-- Re-read the PDF after a rebuild: the page count can change, and the current
-- page may no longer exist if the document got shorter.
function M.refresh()
  if not is_open() or not state.pdf then
    return
  end
  if vim.fn.filereadable(state.pdf) == 0 then
    return
  end
  state.pages = page_count(state.pdf)
  show_page(state.page)
end

function M.close()
  clear_image()
  if is_open() then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win, state.buf, state.png = nil, nil, nil
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
  state.pages = page_count(pdf)
  state.page = 1

  -- Typing continues in the source; the preview is looked at, not worked in.
  vim.api.nvim_set_current_win(source_win)
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
      if is_open() then
        draw()
      end
    end,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    callback = function(ev)
      if is_open() and tonumber(ev.match) == state.win then
        clear_image()
        state.win, state.buf, state.png = nil, nil, nil
      end
    end,
  })
end

return M
