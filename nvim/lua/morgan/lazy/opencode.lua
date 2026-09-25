-- opencode.nvim — in-editor UI for the opencode CLI (the same harness the
-- canopy taskboard dispatches). The plugin spawns `opencode serve` itself;
-- provider/model/auth come from ~/.config/opencode/opencode.json — the
-- "fractal" arbiter provider (http://fractal:12500/v1, 39 models). Do NOT
-- tune that file for nvim: the board shares it. Pick models per session
-- with <leader>op instead.
--
-- Default model: fractal/qwen3.8-27b-q8 (set in opencode.json 2026-09-19,
-- aligned with the board's GPU-0 fleet workhorse — llama-swap resident, no
-- engine swap). Attaches to the persistent opencode-server.service
-- (fractal:12530) instead of spawning its own `opencode serve`.
return {
  'sudo-tee/opencode.nvim',
  -- the system opencode CLI jumped to v2 (2026-09-24 reboot); the v1 API
  -- routes are gone, and plugin main still speaks v1 — v2 support lives
  -- on this branch. Fold back to main once upstream merges it.
  branch = 'v2',
  event = 'VeryLazy',
  dependencies = {
    'folke/snacks.nvim', -- picker
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'Avante', 'opencode_output' },
      opts = { file_types = { 'markdown', 'Avante', 'opencode_output' } },
    },
  },
  config = function()
    require('opencode').setup({
      keymap_prefix = '<leader>o', -- <leader>o* namespace was free
      default_mode = 'build',
      server = {
        -- the household's persistent server (units/opencode-server.service
        -- in canopy_nine_ops). opencode v2 requires auth: the password is
        -- pinned machine-locally in ~/.config/opencode/server.env (unit)
        -- and read here from its sibling file — never committed
        url = 'http://fractal',
        port = 12530,
        password_file = vim.fn.expand('~/.config/opencode/server.password'),
      },
      ui = {
        output = {
          -- long sessions locked nvim up while scrolling history: the pane
          -- lazy-loads + markdown-renders older turns unbounded by default
          max_messages = 60,
          rendering = {
            markdown_on_idle = true, -- defer markdown passes while streaming
          },
          tools = {
            -- qwen3.8 reasoning is 1k+ chars per turn; skip rendering it
            show_reasoning_output = false,
          },
        },
      },
      context = {
        -- nothing auto-attaches: opt in per message with the # menu
        -- (toggle back on) or @ mentions; <CR> in the popup confirms
        current_file = { enabled = false },
        selection = { enabled = false },
        diagnostics = { enabled = false },
        cursor_data = { enabled = false },
      },
    })
  end,
}
