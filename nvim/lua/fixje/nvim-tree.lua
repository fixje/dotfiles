-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-web-devicons").setup()
require("nvim-tree").setup()

local api = require("nvim-tree.api")

vim.keymap.set("n", "<leader>ft", api.tree.toggle)
-- replacement to open URLs because netrw is disabled
vim.keymap.set("n", "gx", ":execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>")
