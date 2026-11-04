-- Search inside the current file. / is not a letter, so no Russian twins.

-- // in Visual mode searches forward for the selected text, using Neovim's
-- built-in Visual * (:help v_star-default): the text is matched literally,
-- every match is highlighted, and n / N repeat the search. remap is needed
-- because that * is a default mapping, not a built-in key.
vim.keymap.set("x", "//", "*", { remap = true, desc = "Search for the selection" })

-- Esc in Normal mode does its usual job and also hides the search highlight
-- until the next search (:nohlsearch).
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "Clear search highlight" })
