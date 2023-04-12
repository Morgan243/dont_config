-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')
--vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Simple plugins can be specified as strings
  -- use 'rstacruz/vim-closer'
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

--Diagnostics
use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
        require("null-ls").setup({
        sources = {
        --require("null-ls").builtins.diagnostics.flake8,
        require("null-ls").builtins.code_actions.shellcheck,
        require("null-ls").builtins.diagnostics.mypy,

        require("null-ls").builtins.code_actions.refactoring,
        require("null-ls").builtins.formatting.black,
        require("null-ls").builtins.diagnostics.pydocstyle,
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.completion.spell}
    })
    end,
    requires = { "nvim-lua/plenary.nvim" },
})

----
-- Colorschemes
use({ 'rose-pine/neovim',
      as = 'rose-pine'
      --config = function()
      --    vim.cmd('colorscheme rose-pine')
      --end
})

use { "ellisonleao/gruvbox.nvim",
  config = function()
          vim.o.background = "dark"
      end
}

use { "kabouzeid/nvim-jellybeans", requires = "rktjmp/lush.nvim" }
vim.cmd('colorscheme jellybeans')
--
------

use( 'skywind3000/asynctasks.vim' )
use( 'skywind3000/asyncrun.vim' )

----
-- Doc and annotations (docstrings)
use {
    "danymat/neogen",
    config = function()
        require('neogen').setup {}
    end,
    requires = "nvim-treesitter/nvim-treesitter",
    -- Uncomment next line if you want to follow only stable versions
    -- tag = "*"
}

----
-- Fancy bar
--use({
--  "arsham/arshamiser.nvim",
--  requires = {
--    "arsham/arshlib.nvim",
--    "famiu/feline.nvim",
--    "rebelot/heirline.nvim",
--    "kyazdani42/nvim-web-devicons",
--  },
--  config = function()
--    -- ignore any parts you don't want to use
--    vim.cmd.colorscheme("arshamiser_light")
--    require("arshamiser.feliniser")
--    -- or:
--    -- require("arshamiser.heirliniser")
--
--    _G.custom_foldtext = require("arshamiser.folding").foldtext
--    vim.opt.foldtext = "v:lua.custom_foldtext()"
--    -- if you want to draw a tabline:
--    vim.api.nvim_set_option("tabline", [[%{%v:lua.require("arshamiser.tabline").draw()%}]])
--  end,
--})

use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}

use( 'rmehri01/onenord.nvim' )

-----

use( 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
use("nvim-treesitter/nvim-treesitter-context");

use( 'nvim-treesitter/playground' )
use( 'ThePrimeagen/harpoon' )
use( 'mbbill/undotree' )
use( 'tpope/vim-fugitive' )
use( 'neovim/nvim-lspconfig' )

use {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v2.x',
	requires = {
		-- LSP Support
		{'neovim/nvim-lspconfig'},             -- Required
		{                                      -- Optional
		'williamboman/mason.nvim',
		run = function()
			pcall(vim.cmd, 'MasonUpdate')
		end,
	},
	{'williamboman/mason-lspconfig.nvim'}, -- Optional

	-- Autocompletion
	{'hrsh7th/nvim-cmp'},     -- Required
	{'hrsh7th/cmp-nvim-lsp'}, -- Required
	{'L3MON4D3/LuaSnip'},     -- Required
}
}

-- Nice completion in ':', search, and help commands
use {
  'gelguy/wilder.nvim',
  config = function()

    -- config goes here
  end,
}

-- Diagnostics
use {
  "folke/trouble.nvim",
  requires = "nvim-tree/nvim-web-devicons",
  config = function()
    require("trouble").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}

--- Folds from nvim-ufo: https://github.com/kevinhwang91/nvim-ufo
use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- Option 2: nvim lsp as LSP client
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
--local capabilities = vim.lsp.protocol.make_client_capabilities()
--capabilities.textDocument.foldingRange = {
--    dynamicRegistration = false,
--    lineFoldingOnly = true
--}
--local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
--for _, ls in ipairs(language_servers) do
--    require('lspconfig')[ls].setup({
--        capabilities = capabilities
--        -- you can add other fields for setting up lsp server in this table
--    })
--end
--require('ufo').setup()
--

  end)
