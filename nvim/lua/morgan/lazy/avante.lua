-- Avante pointed at the fractal arbiter (llm-arbiter, front door :12500).
-- The "model" field routes: llama-swap fleet profiles load lazily by name
-- (~/.config/llama-swap/config.yaml). Both models below are GPU-0 profiles —
-- a request while vLLM owns the card triggers a drain + engine swap (up to
-- ~180s), and densify owns GPU 0 from 22:00 to ~06:45.
-- Switch at runtime with :AvanteSwitchProvider arbiter_flashnext
local arbiter_url = "http://fractal:12500/v1"

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = "arbiter_q8",
    providers = {
      arbiter_q8 = {
        __inherited_from = "openai",
        endpoint = arbiter_url,
        model = "qwen3.8-27b-q8", -- Q8_0 + MTP, 4 slots x 160k, GPU 0
        api_key_name = "", -- arbiter has no auth
        use_response_api = false, -- llama.cpp servers have no /v1/responses
        context_window = 163840,
        timeout = 120000,
        extra_request_body = {
          temperature = 0.2,
          max_completion_tokens = 16384,
        },
      },
      arbiter_flashnext = {
        __inherited_from = "openai",
        endpoint = arbiter_url,
        model = "qwen3.8-flash-next-ik", -- ik flash-next, GPU 0 only, np1 x 128k
        -- qwen3.8-flash-next-ik-mtp is the same thing ~25% faster on code
        api_key_name = "",
        use_response_api = false,
        context_window = 131072,
        timeout = 120000,
        extra_request_body = {
          temperature = 0.2,
          -- reasoning model: generous budget or completions come back empty
          max_completion_tokens = 16384,
        },
      },
    },
    behaviour = {
      auto_suggestions = false, -- keep off: suggestions would hammer GPU 0
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
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
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
