-- Extra colorschemes for the <leader>fc live-preview picker. All lazy: they
-- cost nothing at startup — lazy.nvim loads one automatically when its name
-- is :colorscheme'd (which is exactly what the picker preview does).
-- Keepers get promoted to the top of set.lua.
return {
  -- 4 flavors: catppuccin-latte/-frappe/-macchiato/-mocha
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  -- kanagawa-wave/-dragon/-lotus
  { 'rebelot/kanagawa.nvim', lazy = true },
  -- a 7-scheme pack: nightfox, duskfox, dawnfox, dayfox, nordfox, terafox, carbonfox
  { 'EdenEast/nightfox.nvim', lazy = true },
  -- rose-pine (main), rose-pine-moon, rose-pine-dawn
  { 'rose-pine/neovim', name = 'rose-pine', lazy = true },
  { 'ellisonleao/gruvbox.nvim', lazy = true },
  -- lua everforest port; soft/medium/hard via setup, default medium
  { 'neanias/everforest-nvim', lazy = true },
  -- IBM carbon-inspired, oled-dark
  { 'nyoom-engineering/oxocarbon.nvim', lazy = true },
}
