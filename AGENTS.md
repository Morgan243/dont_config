# dont_config — agent operating guide

Personal dotfiles/config repo. Currently one payload: the Neovim config in
`nvim/`. Read this before changing anything; update it when the facts change.

## Deployment model — symlink, no sync step

```
~/.config/nvim  →  ~/Projects/dont_config/nvim    (symlink)
```

- **The working tree IS the live config.** Any edit takes effect on the next
  nvim start — before it is committed. There is no install/deploy step.
- **`dev` is the live branch.** Checking out another branch switches the
  user's editor immediately. Don't check out branches casually.
- Branch map: `dev` = live daily config. `master` = stale 2023 packer-era
  config, kept for history. `modern-nvim` = local-only 2026 experiment
  (blink.cmp / conform / native-LSP stack) built before dev was discovered
  to be the real config; harvest ideas from it, don't deploy it.
- Machine-local, deliberately NOT in the repo: installed plugins
  (`~/.local/share/nvim/lazy/`), mason servers (`~/.local/share/nvim/mason/`),
  undo history (`~/.vim/undodir`), sessions. `nvim/lazy-lock.json` IS in the
  repo and pins plugin versions — fresh machine = clone, symlink, start nvim.

## Working rules

- **Lockfile discipline:** never run a blanket `:Lazy sync`/update to fix one
  plugin — it bumps every pin. Update specific plugins intentionally and
  commit the resulting `lazy-lock.json` diff. (`nvim --headless "+Lazy! clean" +qa`
  is safe for removals and updates the lockfile.)
- **Verify headlessly before declaring done:**
  - startup: `nvim --headless "+q" 2>&1` should print nothing.
  - state probes: `nvim --headless -c 'lua vim.defer_fn(function() ... io.write(...) ; vim.cmd("qa!") end, 3000)' [file]`
  - keymaps: test with `vim.api.nvim_feedkeys(keys, "mx", false)` — a real
    keypress, not a direct Lua call. Lesson learned: stock ftplugins define
    buffer-local maps that shadow globals (python's `]]`/`[[` class/def
    motions shadowed the words-jump maps; fixed via LspAttach re-assert).
- **Keep `nvim/CHEATSHEET.md` in sync** whenever keybindings, plugins, or
  workflows change. It is the user's reference; inaccuracies get found fast.
- Commits: small and topical; end the message with the
  `Co-Authored-By: Claude ...` trailer when an agent authors it. Push to
  `origin dev` (SSH remote `git@github.com:Morgan243/dont_config.git`).

## Config layout (nvim/)

- `init.lua` → `lua/morgan/init.lua` → `lazy_init.lua` (lazy.nvim bootstrap,
  spec dir `lua/morgan/lazy/`), `set.lua` (options), `remap.lua` (keymaps —
  most live here, some in plugin specs). Leader = space.
- LSP: mason + mason-lspconfig v2 auto-enables every installed server
  (basedpyright, ruff, lua_ls, bashls, ts_ls, rust_analyzer). Completion is
  nvim-cmp + minuet. treesitter runs the `main` branch (the old
  `nvim-treesitter.configs` API is gone; needs the `tree-sitter` CLI).
- Explorer is snacks.nvim's (nvim-tree was removed 2026-09); snacks provides
  ~12 enabled modules — see the cheatsheet's Snacks section.

## This box (fractal) — quirks and gates

- Extra tooling lives in `~/.local/bin` (no sudo used): `tree-sitter`,
  `stylua`, `shellcheck`, `fd`. npm globals land in `~/.hermes/node/bin`
  (symlink into `~/.local/bin` to expose).
- No ImageMagick and no working luarocks: `image.nvim` is auto-disabled by a
  gate in its spec; lazy's rocks support is off in `lazy_init.lua`. molten
  additionally needs `jupyter_client` in the python host. Don't "fix" these
  by re-enabling — fix the underlying deps first.

## LLM tooling — everything routes through the arbiter

- Endpoint: `http://fractal:12500/v1` (llm-arbiter front door; use the
  hostname, never an IP — house rule). No auth; clients that insist on a key
  get a dummy value. Model selection = the `model` field; llama-swap loads
  fleet profiles lazily by name.
- Current models: `qwen3.8-27b-q8` (Q8+MTP, 4 slots × 160k, GPU 0; avante
  default `arbiter_q8`) and `qwen3.8-flash-next-ik` (ik flash-next, GPU 0,
  np1 × 128k; minuet default, avante `arbiter_flashnext`). Both are
  REASONING models — send generous max_tokens or completions come back
  empty; llama.cpp returns thinking in `reasoning_content`, content clean.
- **GPU-0 economics:** requesting a GPU-0 model while a vLLM unit owns the
  card triggers drain + engine swap (up to ~3 min) and can evict a dispatched
  agent run; densify owns GPU 0 22:00–06:45. This is WHY minuet is
  manual-trigger-only (`<C-l>`) and avante `auto_suggestions` stays off —
  never wire keystroke-frequency requests at GPU-0 models. For always-on
  completion use a 4080-resident profile (e.g. `qwen3.8-flash-next-4080-mtp`)
  which bypasses arbitration entirely.
- Avante tool permissions: read-only whitelist (`view`/`glob`/`grep`/`ls`);
  write/bash prompt first. Upstream default is auto-approve-everything —
  don't regress this on a box running the live fleet and board.
- Ollama (`fractal:11434`) is DEAD (retired 2026-06). Any config pointing
  there is a bug.
- Deeper context: `~/Projects/canopy_nine_ops/docs/operating.md` (overseer
  runbook), `~/Projects/llm-arbiter` (arbiter implementation), and
  `GET http://fractal:12500/placement` for live GPU ownership.

## User-facing reference

`nvim/CHEATSHEET.md` — full keybinding and plugin reference, organized by
workflow. Keep it truthful; verify claimed defaults against installed plugin
source, not upstream docs or LazyVim conventions (they differ).
