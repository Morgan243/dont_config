-- plugins/telescope.lua:
-- master branch: the 0.1.x tags predate treesitter's main branch and call
-- the removed ft_to_lang API (broke previewers, e.g. <leader>fc)
return {
    'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' }
    }
