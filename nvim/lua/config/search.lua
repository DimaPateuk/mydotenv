-- Project search with fzf-lua: Ctrl+P finds files, Ctrl+F finds text.
-- scripts/project-search.sh lists results that respect .gitignore first and
-- gitignored ones after, dimmed. macOS terminals usually send Ctrl+letter as
-- the same control code on any keyboard layout, so no Russian twins are mapped.
vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" }, { confirm = false })

local fzf = require("fzf-lua")
fzf.setup({ defaults = { file_icons = false, git_icons = false } })

local script = vim.fn.shellescape(vim.fn.stdpath("config") .. "/scripts/project-search.sh")

-- The script always lists ignored and hidden files, and fzf-lua's toggles for
-- them would inject flags into its command line, so they are disabled.
local file_actions = vim.tbl_extend("force", fzf.defaults.actions.files, {
  ["alt-i"] = false,
  ["alt-h"] = false,
  ["alt-f"] = false,
})

local function find_files()
  fzf.fzf_exec(script .. " files", {
    prompt = "Files❯ ",
    previewer = "builtin",
    actions = file_actions,
    -- On equal match scores keep the script's order: non-ignored files first.
    fzf_opts = { ["--ansi"] = true, ["--multi"] = true, ["--scheme"] = "path", ["--tiebreak"] = "index" },
  })
end

local function find_text()
  fzf.fzf_live(script .. " grep <query>", {
    prompt = "Text❯ ",
    previewer = "builtin",
    actions = file_actions,
    fzf_opts = { ["--ansi"] = true, ["--multi"] = true },
  })
end

-- Normal and Visual mode only: in Insert mode Ctrl+P is keyword completion.
-- Ctrl+F replaces the built-in page-down scroll.
vim.keymap.set({ "n", "x" }, "<C-p>", find_files, { desc = "Find files" })
vim.keymap.set({ "n", "x" }, "<C-f>", find_text, { desc = "Find text" })
