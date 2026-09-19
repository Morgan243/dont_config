-- - - - - -
-- This will clone the package manager if it isn’t already installed and set 
-- the location for plugin definitions to be the .config/nvim/lua/marshmalon/lazy/ folder.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "morgan.lazy",
    change_detection = { notify = false },
    -- no luarocks on this box; image.nvim's magick rock can't build anyway
    rocks = { enabled = false, hererocks = false },
})
-- - - - - -

