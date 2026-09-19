return {
  "nvim-treesitter/nvim-treesitter",
  -- the old master branch (and its nvim-treesitter.configs API) is frozen;
  -- main needs the tree-sitter CLI on PATH
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter").install({
      "c", "lua", "vim", "vimdoc", "elixir", "javascript", "html", "python", "typescript"
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
