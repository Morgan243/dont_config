return {
  'RRethy/vim-illuminate',
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {
    'lsp',
    'treesitter',
    'regex',
  },
  -- delay: delay in milliseconds
  delay = 150,
  large_file_cutoff = 10000,
}
