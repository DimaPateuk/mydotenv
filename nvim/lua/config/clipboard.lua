-- System clipboard: <leader>y copies, <leader>d cuts and <leader>p pastes
-- through the "+ register (бн, бв and бз on the Russian layout). Like y and d
-- they take a motion in Normal mode (<leader>yy line, <leader>yiw word) and
-- act on the selection in Visual mode. Plain y, d and p keep using Vim's own
-- registers; з is the Russian twin of plain p.

local function map(keys, modes, rhs, desc)
  for _, key in ipairs(keys) do
    vim.keymap.set(modes, key, rhs, { desc = desc })
  end
end

map({ "<leader>y", "бн" }, { "n", "x" }, '"+y', "Copy to clipboard")
map({ "<leader>d", "бв" }, { "n", "x" }, '"+d', "Cut to clipboard")
map({ "<leader>p", "бз" }, { "n", "x" }, '"+p', "Paste from clipboard")
map({ "з" }, { "n", "x" }, "p", "Paste from register")

-- The doubled Latin operator already means the whole line; the Russian one
-- needs its own mapping, since н and в are not y and d to Vim.
map({ "бнн" }, "n", '"+yy', "Copy line to clipboard")
map({ "бвв" }, "n", '"+dd', "Cut line to clipboard")
