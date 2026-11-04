-- Markdown preview, two ways:
-- * render-markdown.nvim draws headings, lists, checkboxes, tables and code
--   blocks right in the buffer, using the markdown parsers bundled with
--   Neovim. It renders in Normal mode; the cursor line and Insert mode show
--   the raw text. :RenderMarkdown toggle turns it off and on.
-- * live-preview.nvim shows the file in the browser at 127.0.0.1:5500 and
--   updates the page while you type: :LivePreview start / :LivePreview close.
vim.pack.add({
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/brianhuster/live-preview.nvim",
}, { confirm = false })

local render_markdown = require("render-markdown")

-- Terminal fonts usually lack Nerd Font glyphs, as in file_tree.lua, so the
-- default icons are replaced: headings keep their # marks, checkboxes use
-- plain Unicode, links get no icon, and callouts such as > [!NOTE] show only
-- their title, with the leading icon cut off.
local callouts = {}
for name, callout in pairs(render_markdown.default.callout) do
  callouts[name] = { rendered = (callout.rendered:gsub("^%S+ ", "")) }
end

render_markdown.setup({
  heading = { sign = false, icons = {} },
  checkbox = {
    unchecked = { icon = "☐ " },
    checked = { icon = "☑ " },
    custom = { todo = { rendered = "◐ " } },
  },
  link = { enabled = false },
  callout = callouts,
})
