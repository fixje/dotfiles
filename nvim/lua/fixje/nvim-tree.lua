-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-web-devicons").setup()
require("nvim-tree").setup()

local api = require("nvim-tree.api")

vim.keymap.set("n", "<leader>ft", api.tree.toggle)
