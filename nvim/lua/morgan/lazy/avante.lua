--provider = "ollama",
--ollama = {
--  model = "qwq:32b",
---- }
---
--local openai_compat_url = 'http://127.0.0.1:11434/v1/'
--local openai_compat_url = 'http://spencer:11434/v1/'
--local openai_compat_url = 'http://mesh:11434'
local openai_compat_url = 'http://fractal:11434'

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    -- add any opts here
    -- for example
    --provider = "openai",
    provider = "ollama",
    -- TODO: retry this Maybe minuet disabled?
    --auto_suggestions_provider = 'ollama',
    ollama = {
      --endpoint = "http://127.0.0.1:11434/v1/",
      --endpoint = "http://127.0.0.1:11434",
      endpoint = openai_compat_url,
      model = "qwen2.5-coder:7b-instruct-q4_K_M",
      stream = true,
    },
    vendors = {
      ["qwen2.5-coder"] = {
        __inherited_from = "ollama",
        model = "qwen2.5-coder:14b-instruct-q4_K_M",
      }
    },
    behaviour = {
        --auto_suggestions = true,
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      }
    --openai = {
    --  endpoint = "https://api.openai.com/v1",
    --  model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
    --  timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
    --  temperature = 0,
    --  max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --  --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    --},
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
