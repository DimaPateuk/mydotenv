-- Neovim config, loaded through the ~/.config/nvim symlink made by install.sh.

-- Leader is set before any module maps <leader> keys. On the Russian layout
-- the same key is б, so modules map their б twins explicitly.
vim.g.mapleader = ","

require("config.colorscheme")
require("config.windows")
require("config.motions")
require("config.search")
require("config.file_tree")
