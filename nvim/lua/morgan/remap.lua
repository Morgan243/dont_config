vim.g.mapleader = " "

-- AsyncTasks
vim.g.asyncrun_open = 6
vim.g.asynctasks_term_pos = 'TAB'
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pu", "<cmd>AsyncTask push-file<cr>")

vim.keymap.set("n", "<leader>t", ":AsyncTask ")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
