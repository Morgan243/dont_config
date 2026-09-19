-- Extra colorschemes for the <leader>fc live-preview picker. Loaded eagerly
-- (rtp-only until applied, a few ms total): telescope's picker builds its
-- list from getcompletion, which can't see lazy-loaded themes. Keepers get
-- promoted to the top of set.lua.
return {
  -- 4 flavors: catppuccin-latte/-frappe/-macchiato/-mocha
  { 'catppuccin/nvim', name = 'catppuccin', lazy = false, priority = 900 },
  -- kanagawa-wave/-dragon/-lotus
  { 'rebelot/kanagawa.nvim', lazy = false, priority = 900 },
  -- a 7-scheme pack: nightfox, duskfox, dawnfox, dayfox, nordfox, terafox, carbonfox
  { 'EdenEast/nightfox.nvim', lazy = false, priority = 900 },
  -- rose-pine (main), rose-pine-moon, rose-pine-dawn
  { 'rose-pine/neovim', name = 'rose-pine', lazy = false, priority = 900 },
  { 'ellisonleao/gruvbox.nvim', lazy = false, priority = 900 },
  -- lua everforest port; soft/medium/hard via setup, default medium
  { 'neanias/everforest-nvim', lazy = false, priority = 900 },
  -- IBM carbon-inspired, oled-dark
  { 'nyoom-engineering/oxocarbon.nvim', lazy = false, priority = 900 },
}
