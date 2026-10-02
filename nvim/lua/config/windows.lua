-- Window management with tmux-style keys: <C-w> plays the role of the tmux
-- prefix C-a and takes the same second keys, plus their Russian-layout twins.

-- Open new windows below and to the right, like tmux splits.
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Zoom opens the current window in its own tab page; unzoom closes that tab
-- and returns to the tab it came from, so the original layout is untouched.
local function unzoom(origin)
  if vim.fn.tabpagenr("$") == 1 then
    vim.t.zoom_origin = nil
    return
  end
  vim.cmd.tabclose()
  if vim.api.nvim_tabpage_is_valid(origin) then
    vim.api.nvim_set_current_tabpage(origin)
  end
end

local function zoom()
  if vim.fn.winnr("$") == 1 then
    return
  end
  local origin = vim.api.nvim_get_current_tabpage()
  vim.cmd("tab split")
  vim.t.zoom_origin = origin
end

local function toggle_zoom()
  local origin = vim.t.zoom_origin
  if origin then
    unzoom(origin)
    return
  end
  zoom()
end

-- Maps <C-w> followed by each of keys: a Latin key and its Russian twin.
local function map(keys, rhs, desc)
  for _, key in ipairs(keys) do
    vim.keymap.set("n", "<C-w>" .. key, rhs, { desc = desc })
  end
end

map({ '"', "Э" }, "<cmd>split<cr>", "Split window below")
map({ "%" }, "<cmd>vsplit<cr>", "Split window right")
map({ "z", "я" }, toggle_zoom, "Toggle window zoom")
map({ "x", "ч" }, "<cmd>close<cr>", "Close window")

-- h/j/k/l already move between windows; add their Russian twins.
map({ "р" }, "<cmd>wincmd h<cr>", "Go to the left window")
map({ "о" }, "<cmd>wincmd j<cr>", "Go to the window below")
map({ "л" }, "<cmd>wincmd k<cr>", "Go to the window above")
map({ "д" }, "<cmd>wincmd l<cr>", "Go to the right window")

-- Built-in split keys are freed for future bindings.
map({ "s", "S", "<C-s>", "v", "<C-v>" }, "<Nop>", "Unbound")
