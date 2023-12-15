vim.g.mapleader = ","
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "YY", ":qa!<CR>")
vim.keymap.set("i", "<C-s>", "<esc>:w<CR>")
vim.keymap.set("n", "<C-s>", ":w<CR>")

vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-e>", "<C-o>^")

-- override hihlighted word without losing paste buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
