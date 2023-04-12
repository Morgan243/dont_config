local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>fi', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fw', builtin.lsp_workspace_symbols, {})


vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})

--vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
--vim.keymap.set('n', '<C-p>', builtin.git_files, {})
--
--vim.keymap.set('n', '<leader>ps', function()
--	builtin.grep_string({ search = vim.fn.input("Grep > ") });
--end)
