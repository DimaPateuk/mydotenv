-- Language servers (LSP): go to definition through imports, path aliases
-- (tsconfig/jsconfig "paths"), types and interfaces, in every language that
-- has a server. nvim-lspconfig supplies ready configs for the servers; each
-- server binary is installed separately with Homebrew, and a server whose
-- binary is missing is skipped silently.
--
-- gd (пв) jumps to the definition of the symbol under the cursor, gf (па)
-- also opens the module of an import path. With no server, or when the
-- server finds nothing, both fall back to the built-in gd and gf. Neovim's
-- own LSP keys work too: grr references, gri implementations, grt type
-- definition, grn rename, K documentation.
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { confirm = false })

-- nvim-lspconfig server name = its executable; the Homebrew formula has the
-- server's name. Only installed servers are enabled: a missing one would
-- report a spawn error on every file of its language.
local servers = {
  -- TypeScript and JavaScript; bundles its own TypeScript, so it works even
  -- without the typescript package in node_modules.
  vtsls = "vtsls",
  pyright = "pyright-langserver", -- Python
  jdtls = "jdtls", -- Java
}
for name, executable in pairs(servers) do
  if vim.fn.executable(executable) == 1 then
    vim.lsp.enable(name)
  end
end

local method = "textDocument/definition"

-- Flattens the answers of all servers into quickfix items.
local function to_items(results)
  local items = {}
  for client_id, response in pairs(results) do
    local client = vim.lsp.get_client_by_id(client_id)
    local locations = response.result or {}
    if not vim.islist(locations) then
      locations = { locations }
    end
    if client then
      vim.list_extend(items, vim.lsp.util.locations_to_items(locations, client.offset_encoding))
    end
  end
  return items
end

-- Jumps like vim.lsp.buf.definition(): a single definition opens in the
-- window, several fill the quickfix list.
local function jump(items, win)
  if #items > 1 then
    vim.fn.setqflist({}, " ", { title = "LSP definitions", items = items })
    vim.cmd("botright copen")
    return
  end
  local item = items[1]
  local buf = vim.fn.bufadd(item.filename)
  vim.cmd("normal! m'")
  vim.bo[buf].buflisted = true
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_cursor(win, { item.lnum, item.col - 1 })
  vim.api.nvim_win_call(win, function()
    vim.cmd("normal! zv")
  end)
end

-- Returns a handler that jumps to the LSP definition under the cursor, or
-- runs the built-in fallback key when no server can answer or none finds a
-- definition.
local function definition_or(fallback)
  local function run_fallback()
    vim.api.nvim_feedkeys(fallback, "n", false)
  end

  return function()
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    if not next(vim.lsp.get_clients({ bufnr = buf, method = method })) then
      run_fallback()
      return
    end
    vim.lsp.buf_request_all(buf, method, function(client)
      return vim.lsp.util.make_position_params(win, client.offset_encoding)
    end, function(results)
      local items = to_items(results)
      if #items == 0 then
        run_fallback()
        return
      end
      jump(items, win)
    end)
  end
end

for _, key in ipairs({ "gd", "пв" }) do
  vim.keymap.set("n", key, definition_or("gd"), { desc = "Go to definition" })
end
for _, key in ipairs({ "gf", "па" }) do
  vim.keymap.set("n", key, definition_or("gf"), { desc = "Go to file or definition" })
end
