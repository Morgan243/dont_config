# dont_config

Personal configuration, versioned. Currently: Neovim (`nvim/`).

## How it deploys

One symlink, no dotfile manager:

```sh
ln -sfn ~/Projects/dont_config/nvim ~/.config/nvim
```

The git working tree is the live config — edits apply on next nvim start,
branch checkouts switch the editor wholesale. **`dev` is the live branch**;
`master` is the 2023 archive.

## Fresh machine

```sh
git clone git@github.com:Morgan243/dont_config.git ~/Projects/dont_config
cd ~/Projects/dont_config && git checkout dev
ln -sfn ~/Projects/dont_config/nvim ~/.config/nvim
nvim   # lazy.nvim bootstraps itself and restores plugins from lazy-lock.json
```

External deps: neovim ≥ 0.11, git, gcc/make, ripgrep, `tree-sitter` CLI
(treesitter main branch), node (some LSP servers). Optional: ImageMagick +
luarocks (image.nvim — auto-disabled without them), `jupyter_client` (molten).

## Documentation

- **`nvim/CHEATSHEET.md`** — keybindings and plugins, by workflow.
- **`AGENTS.md`** — operating guide for coding agents maintaining this setup
  (deployment model, verification workflow, LLM/arbiter wiring, box quirks).
