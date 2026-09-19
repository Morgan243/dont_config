-- opencode.nvim — in-editor UI for the opencode CLI (the same harness the
-- canopy taskboard dispatches). The plugin spawns `opencode serve` itself;
-- provider/model/auth come from ~/.config/opencode/opencode.json — the
-- "fractal" arbiter provider (http://fractal:12500/v1, 39 models). Do NOT
-- tune that file for nvim: the board shares it. Pick models per session
-- with <leader>op instead.
--
-- ⚠ The global default model there is fractal/qwen3.8-27b-96k — a vLLM
-- GPU-0 engine. If llama-swap owns GPU 0, the first prompt triggers an
-- engine swap (vLLM cold start, minutes). Switch to qwen3.8-27b-q8 for
-- fleet-resident chat (see AGENTS.md, "GPU-0 economics").
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
      context = {
        -- current file, selection, and LSP diagnostics ride along by default
        cursor_data = { enabled = true },
      },
    })
  end,
}
