--vim.cmd.colorscheme("tokyonight")
--vim.cmd.colorscheme("cyberdream")
vim.cmd.colorscheme("wildcharm")
 
vim.opt.clipboard = 'unnamedplus' -- use system keyboard for yank

-- Over SSH (kitty ssh kitten) there's no display for wl-copy/xclip, so
-- yanks silently never reached the local clipboard. OSC 52 writes the
-- LOCAL machine's clipboard through the tty (kitty allows writes by
-- default). Copy-only: '+p mirrors the unnamed register instead of an
-- OSC 52 read, which would trigger kitty's clipboard-read prompt —
-- paste from outside stays on the local terminal's Ctrl+Shift+V.
if vim.env.SSH_TTY then
  local osc52 = require('vim.ui.clipboard.osc52')
  local function paste_from_unnamed()
    return { vim.fn.split(vim.fn.getreg('"'), '\n'), vim.fn.getregtype('"') }
  end
  vim.g.clipboard = {
    name = 'OSC 52 (copy-only)',
    copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
    paste = { ['+'] = paste_from_unnamed, ['*'] = paste_from_unnamed },
  }
end
 
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
-- when wrap IS on (prose filetypes below, or <leader>tw), make it pretty:
-- break at word boundaries, keep the indent on continuation lines
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = '↪ '
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'gitcommit', 'quarto', 'rmd', 'mchat' },
  callback = function()
    vim.opt_local.wrap = true
  end,
})
 
vim.opt.incsearch = true -- incremental search
 
vim.opt.termguicolors = true

vim.opt.fillchars = { fold = " " }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
--g.markdown_folding = 1 -- enable markdown folding
vim.opt.cursorline = true
-- cursorcolumn redraws a full column on every cursor move — measurable
-- input lag with treesitter + statuscolumn active; re-enable if missed
vim.opt.cursorcolumn = false

vim.opt_local.colorcolumn = "80"


-- Yarepl is good, but it's missing some nice features and needs to much scripting to be useful quickly
require('telescope').load_extension('REPLShow')

-- Clearer separators between splits, whatever the colorscheme (most themes,
-- cyberdream included, make WinSeparator nearly invisible). Re-applied on
-- every :colorscheme so trying themes with <leader>fc keeps visible borders.
local function bright_separators()
  vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#7aa2f7', bg = 'NONE', bold = true })
end
bright_separators()
vim.api.nvim_create_autocmd('ColorScheme', { callback = bright_separators })
