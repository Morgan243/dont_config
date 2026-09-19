-- Sticky scope lines pinned at the top of the window: shows the signature
-- of every enclosing class/def/loop while you're inside its body.
return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  opts = {
    max_lines = 4, -- cap stacked scopes so deep nesting doesn't eat the view
    min_window_height = 10,
  },
  keys = {
    { '<leader>tc', '<cmd>TSContext toggle<cr>', desc = 'Toggle sticky scope context' },
  },
}
