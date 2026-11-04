# mydotenv navigation

Paths are relative to the repository root.

```text
tmux/tmux.conf   tmux configuration (plugins via TPM, not vendored)
tmux/install.sh  writes ~/.tmux.conf that sources tmux/tmux.conf by its
                 resolved absolute path; backs up an existing ~/.tmux.conf;
                 installs missing TPM and plugins; reloads a running tmux
tmux/russian-layout.sh
                 run last by tmux.conf; binds each Cyrillic letter to the
                 command of the Latin key in the same physical position
nvim/init.lua    Neovim entry point: sets <leader> to "," (б on the Russian
                 layout) and requires the modules below
nvim/lua/config/options.lua
                 general editor options: line numbers
nvim/lua/config/colorscheme.lua
                 VS Code theme (vscode.nvim), Dark+ by default; :Theme dark|light
nvim/lua/config/windows.lua
                 tmux-style window keys after <C-w>: " and % split, z zooms
                 (via a tab page), x closes; native s/v split keys unbound
nvim/lua/config/motions.lua
                 Russian twins р/о/л/д of the h/j/k/l cursor motions
                 Ctrl+J / Ctrl+K scroll half a page, cursor centered
nvim/lua/config/clipboard.lua
                 system clipboard: <leader>y copies, <leader>d cuts,
                 <leader>p pastes; з twins plain p
nvim/lua/config/search.lua
                 fzf-lua project search: Ctrl+P files, Ctrl+F text
nvim/lua/config/buffer_search.lua
                 search in the current file: Visual // searches for the
                 selection; Esc in Normal mode also runs :nohlsearch
nvim/lua/config/file_tree.lua
                 nvim-tree file tree: <leader>m / бь shows the current file;
                 the tree follows the edited file; gitignored files dimmed
nvim/lua/config/lsp.lua
                 language servers via nvim-lspconfig (TS/JS, Python, Java):
                 gd / пв go to definition, gf / па also opens import paths;
                 both fall back to the built-in keys without a server
nvim/lua/config/markdown.lua
                 Markdown preview: render-markdown.nvim in the buffer
                 (:RenderMarkdown toggle), live-preview.nvim in the browser
                 (:LivePreview start / close); no Nerd Font icons
nvim/scripts/project-search.sh
                 feeds both pickers: results respecting .gitignore first,
                 gitignored ones after, dimmed (text matches there capped);
                 text query "TEXT -- src *.ts !dist" filters files by globs
nvim/nvim-pack-lock.json
                 vim.pack lockfile: pinned plugin revisions; do not edit
nvim/install.sh  makes ~/.config/nvim (or $XDG_CONFIG_HOME/nvim) a symlink
                 to nvim/; backs up an existing config directory
mydotenv-ai-agent/
                 agent files: rules, checklists, project description, skills
```
