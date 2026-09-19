vim.keymap.set('n', '<leader>l1', '<Cmd>Minuet change_preset flashnext<CR>')
vim.keymap.set('n', '<leader>l2', '<Cmd>Minuet change_preset q8<CR>')
vim.keymap.set('n', '<leader>l3', '<Cmd>Minuet change_preset flashnext_mtp<CR>')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Hack to sort of full screen a window by copying it to it's own tab
-- Then can just close the tab to go back
vim.keymap.set('n', '<leader>tT', ':tab split<CR>', { desc = 'Slit buffer to new tab'})

-- Use LSP to rename symbols and pull up docs
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol'})
vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, { desc = 'Symbol hover'})

local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)


-- Snacks explorer (replaced nvim-tree 2026-09: same tree, plus live fuzzy
-- filter and picker-consistent UI; also auto-opens when nvim starts on a dir)
vim.keymap.set("n", "<C-b>", function() Snacks.explorer() end, { desc = "Toggle file explorer" })


-- Harpoon
local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
--vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })


vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
-- - - Harpoon - - 

-- BarBar
-- Move to previous/next
vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>')
-- Close the current buffer (an entry in the top bar; these are buffers, not tab pages)
vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>')


-- 
-- auto session
vim.keymap.set('n', '<leader>wr', '<cmd>SessionSearch<CR>', { desc = 'Session search' } )
vim.keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', { desc = 'Save session' } )
vim.keymap.set('n', '<leader>wa', '<cmd>SessionToggleAutoSave<CR>', { desc = 'Toggle autosave' })

--vim.keymap.set('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
--vim.api.nvim_buf_set_option('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { noremap=true, silent=true })

-- Quarto + Iron repl mappings
--local runner = require("quarto.runner")
--vim.keymap.set("n", "<localleader>rc", runner.run_cell,  { desc = "run cell", silent = true })
--vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
--vim.keymap.set("n", "<localleader>rA", runner.run_all,   { desc = "run all cells", silent = true })
--vim.keymap.set("n", "<localleader>rl", runner.run_line,  { desc = "run line", silent = true })
--vim.keymap.set("v", "<localleader>r",  runner.run_range, { desc = "run visual range", silent = true })
--vim.keymap.set("n", "<localleader>RA", function()
--  runner.run_all(true)
--end, { desc = "run all cells of all languages", silent = true })


-- YAREPL mappigns that are lis iron vims - but i like iron vim a bit better right now
--vim.keymap.set('n', '<leader>rs', '<cmd>REPLStart<CR>', { desc = 'Start REPL' })
--vim.keymap.set('n', '<leader>rf', '<cmd>REPLFocus<CR>', { desc = 'REPL Focus' })
--vim.keymap.set('n', '<leader>rr', '<cmd>REPLHideOrFocus<CR>', { desc = 'Hide or Focus REPL' })
--vim.keymap.set('n', '<leader>rR', '<cmd>REPLClose<CR><cmd>REPLStart<CR>', { desc = 'Close and start new REPL' })
--
--vim.keymap.set('n', '<leader>sl', '<cmd>REPLSendLine<CR>', { desc = 'Send line to REPL' })
--vim.keymap.set('v', '<leader>sc', '<cmd>REPLSendVisual<CR>', { desc = 'Send visual to REPL' })
