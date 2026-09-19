# nvim cheatsheet (dev branch)

Leader = `<Space>`, so `<leader>x` and `<space>x` below are the same key.
Forgot something? `<leader>?` shows buffer-local maps, and which-key pops up
automatically if you pause after any prefix.

Colorscheme: cyberdream (tokyonight and onedarkpro installed). System clipboard
is wired to yank/paste (`unnamedplus`).

## Editor basics

| Key | Action |
|---|---|
| `<C-b>` | Toggle nvim-tree file explorer |
| `<A-,>` / `<A-.>` | Previous / next buffer tab (barbar) |
| `<leader>tT` | "Fullscreen" window via `:tab split` — close the tab to go back |
| `<leader>?` | Which-key: buffer-local keymaps |

## Find (telescope)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |

Snacks is fully enabled too: dashboard on bare `nvim`, `:lua Snacks.picker.pick()`, notifier, indent guides, `bigfile`, LSP-word highlights.

## Harpoon

| Key | Action |
|---|---|
| `<leader>a` | Add file to harpoon list |
| `<C-e>` | Harpoon list as a telescope picker |
| `<C-h>` / `<C-t>` / `<C-n>` / `<C-s>` | Jump to file 1 / 2 / 3 / 4 |
| `<C-S-P>` / `<C-S-N>` | Previous / next harpoon buffer |

## LSP

Servers auto-enable from whatever mason has installed — currently basedpyright + ruff (python), lua_ls, bashls, ts_ls, rust_analyzer. `:LspInfo` to check, `<leader>cm` opens Mason.

| Key | Action |
|---|---|
| `gd` / `gD` | Definition / declaration |
| `gi` | Implementation |
| `gr` | References |
| `K` (also `<leader>K`) | Hover docs |
| `<C-k>` | Signature help |
| `<space>rn` (also `<leader>rn`) | Rename symbol |
| `<space>ca` | Code action |
| `<space>D` | Type definition |
| `<space>f` | LSP format (async) |
| `<space>wl` | List workspace folders |
| `<leader>xx` / `<leader>xX` | Trouble: all / buffer diagnostics |
| `<leader>cs` / `<leader>cl` | Trouble: symbols / LSP panel |
| `<leader>xL` / `<leader>xQ` | Trouble: loclist / quickfix |

⚠ Collision: `<space>wa`/`<space>wr` are bound twice — auto-session (defined later) wins; the LSP workspace-folder add/remove maps are shadowed.

## Completion (nvim-cmp + minuet)

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / previous item |
| `<CR>` | Confirm |
| `<C-Space>` | Trigger completion |
| `<C-b>` / `<C-f>` | Scroll docs |
| `<C-l>` | **Minuet**: fetch LLM completion (qwen2.5-coder FIM via `http://fractal:11434`) |
| `<leader>l1` / `l2` / `l3` | Minuet preset small / med / med (`l3` says med — meant `big`?) |

Sources: LSP, luasnip, path, pandoc references, minuet, buffer. VectorCode RAG context feeds minuet automatically when a `vectorcode` executable + project config exist.

## REPL (iron.nvim) — the data-science loop

`# %%` / `#%%` are cell dividers. Set `vim.g.iron_py_repl = "fractal"` or `"mesh"` before starting to get a remote ssh ipython (uv, MMZ project); unset = local ipython.

| Key | Action |
|---|---|
| `<space>rr` | Toggle REPL (opens split below-right) |
| `<space>rR` | Restart REPL |
| `<space>sb` / `<space>sn` | Send code block / send block and move to next |
| `<space>sl` | Send line |
| `<space>sp` | Send paragraph |
| `<space>sc` | Send motion (n) / selection (v) |
| `<space>su` | Send everything up to cursor |
| `<space>sf` | Send whole file |
| `<space>mc` / `<space>sm` / `<space>md` | Mark motion/visual / send mark / remove mark |
| `<space>s<CR>` | Send Enter to REPL |
| `<space>s<space>` | Interrupt (SIGINT) |
| `<space>cl` | Clear REPL |
| `<space>sq` | Exit REPL |

Quarto (`.qmd`) runs cells through iron as well. yarepl is installed as backup (`:REPLStart` — the `ipythonfractal` meta sshes to fractal); its keymaps are commented out.

## LLM tools

| Key / Command | Action |
|---|---|
| `<C-m>c` | model.nvim: `:Mchat` — chat buffer (`qm` = qwen 7b, `ql` = qwen 14b) |
| `<C-m>m` | model.nvim: `:M` — run prompt |
| `<C-m>s` / `<C-m>d` | `:Mselect` / `:Mdelete` |
| `:AvanteAsk` (`<leader>aa`) | Avante sidebar — cursor-style chat over the buffer (ollama qwen2.5-coder:7b) |
| `<leader>ae` / `<leader>at` | Avante: edit selection / toggle sidebar (default avante maps) |

All point at ollama on `http://fractal:11434` — needs ollama actually serving there.

## Sessions (auto-session)

| Key | Action |
|---|---|
| `<leader>wr` | Session search |
| `<leader>ws` | Save session |
| `<leader>wa` | Toggle autosave (shadows LSP add-workspace-folder) |

Sessions restore per-directory automatically (suppressed in `~`, `~/Projects`, `~/Downloads`, `/`).

## Git

`:Git` (fugitive) — status window: `s` stage, `u` unstage, `=` inline diff, `cc` commit, `g?` help. Gitsigns shows hunks in the signcolumn (via barbar dep).

## Other commands

| Command | What |
|---|---|
| `:Lazy` | Plugin manager (lockfile-less on dev — sync pulls latest) |
| `:Mason` / `<leader>cm` | LSP & tool installer |
| `:TSUpdate` | Update treesitter parsers (main branch, needs `tree-sitter` CLI — installed in `~/.local/bin`) |
| `:RsyncUp` / `:RsyncDown` | rsync.nvim project sync (needs `.nvim-rsync` config) |
| `:Today` | today.nvim daily note |
| `:VectorCode` | RAG index queries (needs `vectorcode` CLI — not installed here) |
| `:checkhealth` | Diagnose anything misbehaving |

## Known-disabled on this box (fractal)

- **image.nvim** — auto-disabled: no ImageMagick installed (gate added in `lazy/image.lua`).
- **molten** — remote plugin present but `jupyter_client` python module missing; iron covers the REPL loop meanwhile.
- luarocks support in lazy is off (`rocks.enabled = false`) — its bundled Lua build fails here and nothing else needs it.
