return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",

    "milanglacier/minuet-ai.nvim",

      -- Try new pandoc cmp
    "aspeddro/cmp-pandoc.nvim",
    'nvim-lua/plenary.nvim',

    "jmbuhr/cmp-pandoc-references",
  },
  lazy = false,

  config = function()
    require("conform").setup({
      formatters_by_ft = {
      }
    })
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local pandoc_lsp = require("cmp-pandoc-references")
    --pandoc_lsp.setup{}

    -- - - - - -
    -- Handle VectorCode plugin --
    -- - It is dependent on a Python package VectorCode
    -- - That may not be available in the env nvim runs information
    -- Set default to no VectorCode support
    local has_vc_exec = false
    local has_vc = false
    local vectorcode_config = nil
    local vectorcode_cacher = nil

    -- Check that a vectorcode executable exists at all
    if vim.fn.executable('vectorcode') == 1 then
      has_vc_exec = true
    end

    if has_vc_exec then
      require('vectorcode').setup {
        -- number of retrieved documents
        n_query = 1,
      }
      -- Now check if there is a config file for vectorcode in this project
      has_vc, vectorcode_config = pcall(require, 'vectorcode.config')
      if has_vc then
        vectorcode_cacher = vectorcode_config.get_cacher_backend()
      end
    end
    -- End VectorCode plugin setup, see how it's used in minuet below --
    -- - - - - -

    -- Minuet -> the fractal arbiter (llm-arbiter front door, :12500).
    -- Chat-style completion (openai_compatible): the fleet has no base/FIM
    -- models anymore, so FIM templates are gone. Both default models are
    -- GPU-0 profiles; completion is MANUAL ONLY (<C-l> in insert mode) so
    -- keystrokes never trigger a GPU-0 engine swap mid-agent-run.
    -- Presets (<leader>l1/l2/l3): flashnext | q8 | flashnext_mtp
    local openai_compat_url = 'http://fractal:12500/v1/'

    local function arbiter_provider(model)
      return {
        openai_compatible = {
          name = 'arbiter',
          stream = true,
          api_key = 'TERM', -- no auth on the arbiter; minuet just wants an env var that exists
          end_point = openai_compat_url .. 'chat/completions',
          model = model,
          optional = {
            -- reasoning models: generous budget or completions come back empty
            max_tokens = 1024,
            top_p = 0.9,
          },
        },
      }
    end

    require('minuet').setup {
      provider = 'openai_compatible',
      notify = 'verbose',
      n_completions = 1,
      context_window = 2048,
      context_ratio = 0.75,
      cmp = {
        enable_auto_complete = false, -- manual <C-l> only, see note above
      },
      provider_options = arbiter_provider('qwen3.8-flash-next-ik'),
      presets = {
        flashnext = {
          provider = 'openai_compatible',
          provider_options = arbiter_provider('qwen3.8-flash-next-ik'),
        },
        q8 = {
          provider = 'openai_compatible',
          provider_options = arbiter_provider('qwen3.8-27b-q8'),
        },
        flashnext_mtp = {
          provider = 'openai_compatible',
          provider_options = arbiter_provider('qwen3.8-flash-next-ik-mtp'),
        },
      },
    }

    -- CAPABILITIES
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    require("fidget").setup({})
    require("mason").setup()
    --require("cmp_pandoc").setup({filetypes = { "pandoc", "markdown", "rmd", 'qmd', 'quarto' }})
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        --"rust_analyzer",
        --"gopls",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,

        zls = function()
          local lspconfig = require("lspconfig")
          lspconfig.zls.setup({
            root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
            settings = {
              zls = {
                enable_inlay_hints = true,
                enable_snippets = true,
                warn_style = true,
              },
            },
          })
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          }
        end,
      }
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        --['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        --['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        --['<C-y>'] = cmp.mapping.confirm({ select = true }),
        --['<Tab>'] = cmp.mapping.confirm({ select = true }),

        ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-l>"] = require("minuet").make_cmp_map(),
        --["<C-p>"] = pandoc_lsp.complete,
      }),
      sources = cmp.config.sources({
        { name = 'pandoc_references'},
        --{ name = 'cmp_pandoc'},
        { name = 'path',     option = {} },
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'luasnip',  group_index = 1 }, -- For luasnip users.
        { name = 'minuet',   group_index = 2 },
      }, {
        { name = 'buffer' },
      }),
      performance = { fetching_timeout = 10000 },

    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
