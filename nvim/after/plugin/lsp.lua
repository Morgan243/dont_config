local lsp = require("lsp-zero")

lsp.preset("recommended")

-- Server names are here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
lsp.ensure_installed({
  'jedi_language_server',
  'bashls',
  'tsserver',
  'rust_analyzer',
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  --['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<CR>"] = cmp.mapping.confirm({select = true}),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = cmp.mapping.select_next_item(cmp_select)
cmp_mappings['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select)
--cmp_mappings['<CR>'] = cmp.mapping.complete()

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

--lsp.set_preferences({
--    suggest_lsp_servers = true,
--    sign_icons = {
--        error = 'E',
--        warn = 'W',
--        hint = 'H',
--        info = 'I'
--    }
--})
--
--local lsp = require('lspconfig')
--lsp.jedi_language_server.setup{}
--require'lspconfig'.jedi_language_server.setup{}

--vim.lsp.start({
--  name = 'JEDI SERVER DUDE',
--  cmd = {'jedi_language_server'},
--  root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1]),
--})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  vim.keymap.set("n", "<leader>FF", function() vim.lsp.buf.format() end, opts)

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})


