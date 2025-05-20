--vim.cmd.colorscheme("tokyonight")
vim.cmd.colorscheme("cyberdream")
 
vim.opt.clipboard = 'unnamedplus' -- use system keyboard for yank
 
vim.opt.nu = true                 -- set line numbers -- set line numbers
vim.opt.relativenumber = true     -- use relative line numbers
 
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- set tab size to 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
 
vim.opt.wrap = false
 
vim.opt.incsearch = true -- incremental search
 
vim.opt.termguicolors = true

vim.opt.fillchars = { fold = " " }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
--g.markdown_folding = 1 -- enable markdown folding
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.opt_local.colorcolumn = "80"


-- Yarepl is good, but it's missing some nice features and needs to much scripting to be useful quickly
require('telescope').load_extension('REPLShow')
