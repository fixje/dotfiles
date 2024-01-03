vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "YY", ":qa!<CR>")
vim.keymap.set("i", "<C-s>", "<esc>:w<CR>")
vim.keymap.set("n", "<C-s>", ":w<CR>")

vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-e>", "<C-o>^")

-- override hihlighted word without losing paste buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>it", "me:r !date +\"\\%Y-\\%m-\\%d \\%H:\\%M\"<CR>A <Esc>0D`ePJx")
vim.keymap.set("i", "<C-g><C-t>", "<C-r>=strftime('%Y-%m-%d %H:%M')<CR>")


local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>gg", function() vim.loop.spawn("git-cola", {}) end)
