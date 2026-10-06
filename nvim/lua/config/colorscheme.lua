-- Color scheme: VS Code (vscode.nvim), Dark+ by default. Switch at runtime with
-- :Theme light (Light+) and :Theme dark (Dark+).
vim.pack.add({ "https://github.com/Mofiqul/vscode.nvim" }, { confirm = false })

vim.o.termguicolors = true
vim.o.background = "dark"
require("vscode").setup({})
vim.cmd.colorscheme("vscode")

local styles = { "dark", "light" }

vim.api.nvim_create_user_command("Theme", function(opts)
  if not vim.tbl_contains(styles, opts.args) then
    vim.notify("Theme: expected dark or light, got '" .. opts.args .. "'", vim.log.levels.ERROR)
    return
  end
  require("vscode").load(opts.args)
end, {
  nargs = 1,
  desc = "Switch the VS Code theme: dark (Dark+) or light (Light+)",
  complete = function(arglead)
    return vim.tbl_filter(function(style)
      return vim.startswith(style, arglead)
    end, styles)
  end,
})
