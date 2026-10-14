-- Russian-layout twins of the built-in h/j/k/l cursor motions: the Cyrillic
-- letter on the same physical key moves the same way in Normal, Visual and
-- Operator-pending mode, so counts and operators work too (5о, dл, vдд).
-- Select mode is left out so typing over a selection still inserts letters.
local twins = { h = "р", j = "о", k = "л", l = "д" }

for latin, russian in pairs(twins) do
  vim.keymap.set({ "n", "x", "o" }, russian, latin, { desc = "Same as " .. latin })
end

-- Ctrl+J / Ctrl+K scroll half a page down / up and center the cursor line in
-- the window. Ctrl+letter keys need no Russian twins, as in search.lua.
vim.keymap.set({ "n", "x" }, "<C-j>", "<C-d>zz", { desc = "Scroll down, cursor centered" })
vim.keymap.set({ "n", "x" }, "<C-k>", "<C-u>zz", { desc = "Scroll up, cursor centered" })
