<div align="center">

```
 ██████╗██╗      █████╗ ██╗███╗   ██╗███████╗██╗   ██╗
██╔════╝██║     ██╔══██╗██║████╗  ██║██╔════╝██║   ██║
██║     ██║     ███████║██║██╔██╗ ██║█████╗  ██║   ██║
██║     ██║     ██╔══██║██║██║╚██╗██║██╔══╝  ╚██╗ ██╔╝
╚██████╗███████╗██║  ██║██║██║ ╚████║███████╗ ╚████╔╝
 ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝  ╚═══╝
```

**Clainev Neovim Config**

A fast, modular Neovim setup for full-stack and systems development.

![Neovim](https://img.shields.io/badge/Neovim-0.10+-57A143?style=flat&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-5.1-2C2D72?style=flat&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat)

</div>

---

## Stack

`TypeScript` · `JavaScript` · `React` · `Go` · `Rust` · `Python` · `PHP` · `C/C++` · `Dart/Flutter` · `SQL`

## Requirements

- Neovim >= 0.10
- Git
- [Nerd Font](https://www.nerdfonts.com/) — any variant
- `make` / `cmake` (for native extensions)
- `node` + `npm` (for LSP servers and formatters)

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone git@github.com:TU-USER/TU-REPO.git ~/.config/nvim

# Open Neovim — plugins install automatically
nvim
```

Lazy.nvim bootstraps itself on first launch and installs all plugins. LSP servers and formatters install via Mason.

## Structure

```
~/.config/nvim/
├── init.lua                     # Entry point
└── lua/clainev/
    ├── options.lua              # vim.opt settings
    ├── lazy.lua                 # Plugin manager bootstrap
    ├── keymaps.lua              # Global keymaps
    ├── autocmds.lua             # Autocommands
    └── plugins/
        ├── ui.lua               # Theme, statusline, explorer, dashboard
        ├── editor.lua           # Telescope, Treesitter, editing utilities
        ├── lsp.lua              # LSP servers, Mason, diagnostics, formatter
        ├── completion.lua       # nvim-cmp, LuaSnip
        ├── git.lua              # Gitsigns, LazyGit, Trouble
        ├── tools.lua            # Terminal (toggleterm)
        ├── ai.lua               # Avante (Claude / GPT)
        └── flutter.lua          # Flutter tools
```

## Plugins

| Category | Plugin |
|---|---|
| Theme | [catppuccin](https://github.com/catppuccin/nvim) — Mocha |
| Statusline | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) |
| Tabline | [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) |
| Explorer | [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) |
| Fuzzy finder | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) |
| Syntax | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) |
| LSP | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim) |
| Completion | [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) |
| Formatter | [conform.nvim](https://github.com/stevearc/conform.nvim) |
| Git | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) + [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) |
| Diagnostics | [trouble.nvim](https://github.com/folke/trouble.nvim) |
| Terminal | [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) |
| AI | [avante.nvim](https://github.com/yetone/avante.nvim) (Claude / GPT) |
| Flutter | [flutter-tools.nvim](https://github.com/akinsho/flutter-tools.nvim) |

## Keymaps

`<leader>` = `Space`

### General

| Key | Action |
|---|---|
| `<C-s>` | Save |
| `<C-q>` | Quit |
| `jk` | Exit insert mode |
| `<C-a>` | Select all |
| `zz` | Quit without saving |
| `zw` | Save and quit |

### Navigation

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Move between windows |
| `<Tab>` / `<S-Tab>` | Next / prev buffer |
| `H` / `L` | Prev / next tab |
| `<leader>x` | Close buffer |

### Find (Telescope)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fw` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fo` | Recent files |
| `<leader>fh` | Help tags |

### LSP

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>lf` | Format file |
| `[d` / `]d` | Prev / next diagnostic |

### Git

| Key | Action |
|---|---|
| `<leader>gg` | LazyGit |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gs` | Stage hunk |
| `<leader>gd` | Diff this |

### Tools

| Key | Action |
|---|---|
| `<leader>e` | Toggle explorer |
| `<leader>th/tv/tf` | Terminal horizontal / vertical / float |
| `<leader>xx` | Trouble diagnostics |
| `<leader>u` | Undo tree |
| `<leader>db` | Database UI |

### AI (Avante)

| Key | Action |
|---|---|
| `<leader>aa` | Ask AI |
| `<leader>ac` | AI Chat |
| `<leader>ae` | AI Edit |

### Flutter

| Key | Action |
|---|---|
| `<leader>Fr` | Flutter run |
| `<leader>FR` | Hot reload |
| `<leader>Fd` | Devices |
| `<leader>FL` | Logs |

## LSP Servers

Installed automatically via Mason:

`ts_ls` · `eslint` · `html` · `cssls` · `tailwindcss` · `emmet_ls` · `jsonls` · `intelephense` · `pyright` · `gopls` · `rust_analyzer` · `clangd` · `dartls` · `lua_ls` · `sqls` · `marksman` · `yamlls` · `taplo` · `dockerls` · `bashls`

## Formatters

Installed via Mason. Format on save enabled.

`prettier` · `black` · `isort` · `gofumpt` · `goimports` · `rustfmt` · `clang-format` · `stylua` · `php-cs-fixer` · `sqlfmt` · `shfmt` · `dart_format`

## AI Setup

Avante uses Claude by default. Set your API key as an environment variable:

```bash
# Claude
export ANTHROPIC_API_KEY="sk-ant-..."

# OpenAI (optional)
export OPENAI_API_KEY="sk-..."
```

Add it to your shell profile (`.bashrc`, `.zshrc`) to persist.

---

<div align="center">
  <sub>Clainev — ship fast, measure, iterate</sub>
</div>
