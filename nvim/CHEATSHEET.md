# nvim cheatsheet (dev branch)

Leader = `<Space>`, so `<leader>x` and `<space>x` below are the same key.
Forgot something? `<leader>?` shows buffer-local maps, and which-key pops up
automatically if you pause after any prefix.

Colorscheme: wildcharm (builtin; ~65 more via `<leader>fc`). System clipboard
is wired to yank/paste (`unnamedplus`).

## Editor basics

| Key | Action |
|---|---|
| `<C-b>` | Toggle snacks explorer (also auto-opens when nvim starts on a directory) |
| `<A-,>` / `<A-.>` | Previous / next entry in the top bar (barbar — these are **buffers**, not tab pages) |
| `<A-c>` | Close current buffer (`:BufferClose`) — how you close an entry in the top bar |
| `<leader>tT` | "Fullscreen" window via `:tab split` — makes a real tab page |
| `:tabc` | Close a real tab page (exits `<leader>tT` fullscreen; `gt`/`gT` cycle). Errors with "Cannot close last tab page" if there's only one — then you want `<A-c>`/`:bd` instead |
| `<leader>?` | Which-key: buffer-local keymaps |
| `<leader>tc` | Toggle sticky scope context — enclosing `class`/`def` signature lines pinned at the top of the window (treesitter-context, max 4 lines) |
| `<C-/>` | Toggle terminal at project root (same key hides it; double-`<Esc>` for normal mode inside) |
| `<leader>tp` | Run current python file in a fresh terminal split (`uv run` if the project has `pyproject.toml`, else `python3`) |

## Find (telescope)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fc` | Colorscheme picker with **live preview** — the preview pane shows *your current buffer* under each theme; `<CR>` keeps, `<Esc>` reverts. ~65 schemes: catppuccin ×4, kanagawa ×3, nightfox pack ×7, rose-pine ×3, tokyonight ×4, onedarkpro, gruvbox, everforest, oxocarbon, cyberdream… (`lazy/colors_extra.lua`; promote a keeper to the top of `set.lua`) |

Snacks provides a full picker too (`:lua Snacks.picker.pick()`) — see the Snacks section below.

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
| `<leader>e` (or builtin `<C-w>d`) | Float the full diagnostic for the current line — what the red `E` is about |
| `<leader>xx` / `<leader>xX` | Trouble: all / buffer diagnostics |
| `<leader>cs` | Trouble: symbols |
| `<leader>xL` / `<leader>xQ` | Trouble: loclist / quickfix |

⚠ Collision: `<space>wa`/`<space>wr` are bound twice — auto-session (defined later) wins; the LSP workspace-folder add/remove maps are shadowed.
⚠ Collision: `<space>cl` is bound twice — iron REPL clear (in `lazy/iron.lua`) wins; Trouble's LSP-panel map is shadowed (run `:Trouble lsp` if you need it).

## Completion (nvim-cmp + minuet)

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / previous item |
| `<CR>` | Confirm |
| `<C-Space>` | Trigger completion |
| `<C-b>` / `<C-f>` | Scroll docs |
| `<C-l>` | **Minuet**: fetch LLM completion — default `qwen3.8-27b-q8` (same model as avante/opencode/board: no GPU-0 thrash); manual-only by design |
| `<leader>l1` / `l2` / `l3` | Minuet preset: `flashnext` (ik) / `q8` (27B Q8 4-slot — the default) / `flashnext_mtp` (ik+MTP) — l1/l3 swap GPU 0 to a different model |

Sources: LSP, luasnip, path, pandoc references, minuet, buffer.

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

## LLM tools — all routed through the arbiter (`http://fractal:12500/v1`)

Model names route via llama-swap; both defaults are **GPU-0** profiles, so a
request while vLLM owns the card triggers a drain + engine swap (up to ~3 min),
and densify owns GPU 0 22:00–06:45. No auth.

Avante tool permissions: read-only tools (`view`/`glob`/`grep`/`ls`) run without
asking; anything that writes files or runs bash prompts first (inline buttons).
Generated diffs always wait for review (`co`/`ct` accept ours/theirs).

| Key / Command | Action |
|---|---|
| `:AvanteAsk` (`<leader>aa`) | Avante sidebar — default provider `arbiter_q8` (qwen3.8-27b-q8, 4×160k) |
| `:AvanteSwitchProvider arbiter_flashnext` | Switch avante to qwen3.8-flash-next-ik |
| `<leader>ae` / `<leader>at` | Avante: edit selection / toggle sidebar (default avante maps) |
| `<C-m>c` | model.nvim: `:Mchat` — `qm` = flash-next-ik, `ql` = 27b-q8 |
| `<C-m>m` | model.nvim: `:M` — run prompt (`q` = code-only prompt on flash-next-ik) |
| `<C-m>s` / `<C-m>d` | `:Mselect` / `:Mdelete` |

`curl http://fractal:12500/placement` shows who owns GPU 0 before you commit to a heavy ask.

## Claude Code (claudecode.nvim) — full agent, NOT the arbiter

Unlike the tools above, this talks to **Anthropic's API** via the Claude Code CLI
(`/usr/bin/claude`, installed globally) — nothing here routes through the local
GPU fleet. The plugin hosts a WebSocket MCP server the CLI connects to, so
Claude sees your current file/selection live, can open files, and proposes
edits as native nvim diffs. Spec: `lazy/claudecode.lua`.

The `<leader>c` prefix is **shared** — `c{a,m,s,l}` belong to code action /
Mason / Trouble symbols / iron REPL clear; Claude only uses the free letters.

| Key | Action |
|---|---|
| `<leader>cc` | Toggle Claude in a split (`:ClaudeCode`) |
| `<leader>cf` | Focus / toggle the Claude pane |
| `<leader>cr` / `<leader>cC` | Resume / continue a session |
| `<leader>cM` | Pick a Claude model |
| `<leader>cb` | Add current buffer to Claude's context |
| `<leader>cs` (visual only) | Send selection to Claude — normal-mode `<leader>cs` is still Trouble symbols |
| `<leader>cs` (in snacks explorer) | Add the hovered file to context — shadows Trouble's symbols map inside the tree |
| `<leader>cy` / `<leader>cn` | Accept / deny Claude's proposed diff |

**Leaving the pane:** in terminal mode every key goes to Claude (`<C-w>` =
its delete-word, leader types a space, and with CC's vim mode on, Esc is ITS
normal-mode/cancel — don't use `<Esc><Esc>` here). `<C-\><C-n>` is the one
chord nvim never forwards: it drops to nvim's normal mode, then `<C-w>h` etc.
moves out; `i` re-enters, `<leader>cf` refocuses from elsewhere.
**Fullscreen:** `<C-\><C-n>` then `<leader>tT` puts the pane in its own tab
(`:tabc` returns to the split layout); `<C-w>|`+`<C-w>_` maximizes in place. **Width:** 40% by default (`split_width_percentage` in
`lazy/claudecode.lua`); ad-hoc `<C-w>>`/`<C-w><` or `:vertical resize N` from
normal mode, though the plugin may snap back to the percentage around diffs.

Claude's edits open as native diff buffers: `:w` (or `<leader>cy`) accepts,
`:q` (or `<leader>cn`) rejects — you can edit the proposal before accepting.
`:ClaudeCodeCloseAllDiffs` clears leftover pending proposals.
`:ClaudeCodeStatus` and `:checkhealth claudecode` for diagnostics.

## opencode.nvim — the board's harness, in-editor

The same opencode CLI the taskboard dispatches, as an nvim sidebar. It
attaches to the household's persistent server (`opencode-server.service`,
`http://fractal:12530`) and inherits `~/.config/opencode/opencode.json` — the
**fractal arbiter provider (39 models)**, default `fractal/qwen3.8-27b-q8`
(the board's fleet workhorse; llama-swap resident, no engine swap). That json
is shared with the board — model experiments go through `<leader>op` (per
session), not the file. If the panel won't connect:
`systemctl --user status opencode-server`.

| Key | Action |
|---|---|
| `<leader>og` | Toggle opencode panel |
| `<leader>oi` / `<leader>oI` | Open input (current / new session) |
| `<leader>o/` | Quick chat (works on a visual selection too) |
| `<leader>op` | Pick provider/model (per session) |
| `<leader>os` / `<leader>oT` | Select session / timeline picker |
| `<leader>od` | Diff view of opencode's changes (vs its pre-prompt snapshot — files are already on disk) |
| `<leader>o]` / `<leader>o[` | Cycle next / previous change in the diff view (`<leader>oc` closes) |
| `<leader>ort` / `<leader>ora` | Revert this / all changes from the last prompt (`orT`/`orA` = whole session) |
| `<leader>oy` | Add visual selection to context |
| `<leader>ot` | Toggle focus editor ↔ opencode |
| `<leader>oz` | **Zoom** the opencode panel to 80% width (toggle) |

Input window: `<S-CR>` submit, `@` mention file/agent, `~` file picker, `/`
slash commands, `#` manage context, `<M-m>` switch build/plan mode, `<C-c>`
cancel request. Output window: `]]`/`[[` next/prev message, `]u`/`[u` next/prev **user** message (`[u` from the bottom = your last prompt), `gf` jump to file,
`<Tab>` swap pane. Permission prompts: `a` accept once, `A` accept all, `d` deny.
**Context is opt-in** (all auto-attach off in our config): `#` opens the
context menu (cmp popup — `<Tab>` move, `<CR>` toggles the item on/off), `@`
mentions files/agents. The bar above the input shows what's attached.
`:Opencode revert all prompt` undoes the last prompt's file changes.

## Snacks — folke's std-lib (one plugin, ~37 modules)

Each module is independently toggleable in `lazy/snacks.lua`; enabling a module
costs nothing until used. Status note (2026-09): folke's whole ecosystem has been
paused since ~May 2026 (no commits, all repos) — but snacks is LazyVim's default
picker/explorer so its install base is enormous, and the code is stable; nvim-tree
remains a one-line revert if it ever truly dies.

### Enabled modules — what they are, how to use them

| Module | What it is | How to use it |
|---|---|---|
| `explorer` | File-tree sidebar (replaced nvim-tree) | `<C-b>` toggle; keys below |
| `dashboard` | Start screen on bare `nvim` | Press the button letters: `f` find file, `n` new, `g` grep, `r` recent, `c` config, `s` restore session, `L` Lazy, `q` quit |
| `picker` | Telescope-class fuzzy finder (powers the explorer) | Unbound here (telescope owns `<leader>f*`); `:lua Snacks.picker.pick()` lists every source, e.g. `Snacks.picker.undo()`, `.resume()`, `.notifications()` |
| `notifier` | Routes `vim.notify` into toast popups (top right) | Toasts auto-expire; `<leader>nh` searchable history, `<leader>nd` dismiss all |
| `input` | Restyles `vim.ui.input` prompts | Passive — it's why LSP rename and explorer add/rename get a floating input |
| `indent` | Indent guides; current scope's guide highlighted | Passive |
| `scope` | Scope-aware textobjects and motions (treesitter/indent) | `vii`/`vai` select inner/full scope (any operator: `dii`, `yai`…); `[i` / `]i` jump to scope top/bottom edge |
| `scroll` | Smooth scrolling | Passive — `<C-d>`/`<C-u>` animate instead of teleporting |
| `statuscolumn` | Unified left column: numbers, git + diagnostic signs, fold marks | Passive; click fold marks to fold |
| `words` | Highlights other references of the symbol under cursor (LSP) | Highlight is automatic; `]]` / `[[` jump next/prev reference (cycles; takes a count) |
| `bigfile` | Detects big files (>1.5MB) and disables treesitter/LSP etc. | Automatic — big logs open instantly |
| `terminal` | Toggleable terminals | `<C-/>` shell at project root; `<leader>tp` run current python file; `:lua Snacks.terminal("cmd")` for anything else |
| `quickfile` | Renders the file you opened before the rest of startup finishes | Automatic |

### Explorer keys (it's a picker: just type to fuzzy-filter the tree)

| Key | Action |
|---|---|
| `l` / `h` | Open / close directory (`<BS>` = up a level) |
| `a` / `d` / `r` | Add / delete / rename (rename is LSP-aware) |
| `c` / `m` / `y` / `p` | Copy / move / yank / paste files |
| `o` | Open with system application |
| `.` / `<C-c>` | Focus dir as root / `:tcd` to it |
| `<leader>/` | Grep inside the selected directory |
| `<C-t>` | Terminal in the selected directory |
| `H` / `I` / `Z` | Toggle hidden / toggle ignored / close all dirs |
| `]g` `[g`, `]d` `[d`, `]e` `[e` | Next/prev git-changed, diagnostic, error file |
| `q` | Close explorer (or `<C-b>` from anywhere) |

### Available but not enabled (the rest of the ecosystem)

| Module | What it gives you |
|---|---|
| `lazygit` | Float lazygit UI (needs the `lazygit` binary) |
| `image` | Inline images via kitty graphics — candidate to replace 3rd/image.nvim for molten |
| `rename` | LSP-aware file rename other plugins can call |
| `gitbrowse` | Open current line/range on GitHub/GitLab in browser |
| `scratch` | Persistent per-project scratch buffers |
| `zen` / `dim` | Zen mode; dim inactive scopes |
| `bufdelete` | Close buffer w/o breaking layout (barbar covers this here) |
| `toggle` | Keymap-toggles for options with which-key labels |
| `animate` / `layout` / `win` | Animation/window/layout primitives (libraries for the rest) |
| `profiler` / `debug` | Lua profiler; debug printing |
| `gh` / `git` | GitHub + git helpers (used by picker sources) |

Picker sources cover ~20 families: files, grep, buffers, LSP (symbols/refs/etc.),
diagnostics, git (+GitHub), help, recent, undo, quickfix, treesitter — a full
telescope replacement whenever you feel like consolidating further.

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
| `:Lazy` | Plugin manager (`lazy-lock.json` pins versions; `:Lazy sync` updates + rewrites it) |
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
