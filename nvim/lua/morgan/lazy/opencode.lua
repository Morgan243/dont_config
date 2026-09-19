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
        -- in canopy_nine_ops); binds the tailnet — no auth
        url = 'http://fractal',
        port = 12530,
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
