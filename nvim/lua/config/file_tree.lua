-- File tree (nvim-tree): <leader>m (бь on the Russian layout) opens the tree
-- with the current file selected, or closes it when already in the tree.
-- While open, the tree follows the edited file, e.g. one opened from search.

-- nvim-tree replaces netrw; its docs advise disabling netrw before it loads.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-tree.lua", version = vim.version.range("1") },
}, { confirm = false })

local api = require("nvim-tree.api")

require("nvim-tree").setup({
  hijack_cursor = true,
  update_focused_file = { enable = true },
  -- Show gitignored files too, dimmed by their git status like in search;
  -- hide only the .git directory, as search does.
  filters = { git_ignored = false, custom = { "^\\.git$" } },
  renderer = {
    highlight_git = "name",
    -- Terminal fonts usually lack Nerd Font glyphs: show plain arrows only.
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = true,
        git = false,
        bookmarks = false,
        diagnostics = false,
      },
      glyphs = { folder = { arrow_closed = "▸", arrow_open = "▾" } },
    },
  },
})

local function toggle_tree()
  if vim.bo.filetype == "NvimTree" then
    api.tree.close()
    return
  end
  api.tree.find_file({ open = true, focus = true })
end

for _, key in ipairs({ "<leader>m", "бь" }) do
  vim.keymap.set("n", key, toggle_tree, { desc = "File tree: show current file" })
end
