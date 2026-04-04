# Neovim Configuration

Personal Neovim 0.12 configuration using the native plugin manager (`vim.pack`).

## Installation

### Prerequisites

- [Neovim 0.12+](https://github.com/neovim/neovim/releases)
- [Nerd Font](https://www.nerdfonts.com/) installed and configured in your terminal
- [Git](https://git-scm.com/)
- A C compiler (`gcc` or `clang`) for Treesitter parser and telescope-fzf-native compilation
- Python 3.12 via [pyenv](https://github.com/pyenv/pyenv) with `pynvim` installed

### System packages

Install via your package manager (e.g. `brew`, `apt`):

- `ripgrep` — required by Telescope for live grep
- `xclip` — required for system clipboard support
- `tree-sitter` — required by nvim-treesitter
- `tree-sitter-cli` — required for Treesitter parser installation

### Setup

1. Back up any existing Neovim configuration:

   ```sh
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repository:

   ```sh
   git clone https://github.com/<your-username>/nvim.git ~/.config/nvim
   ```

3. Create the Python virtual environment for Neovim:

   ```sh
   pyenv virtualenv 3.12 py3.12-nvim
   pyenv activate py3.12-nvim
   pip install pynvim
   ```

4. Launch Neovim:

   ```sh
   nvim
   ```

   On first launch, plugins are pulled automatically via `vim.pack` and Mason installs all configured LSP servers, formatters, and linters.

## Plugins

| Plugin | Purpose |
|--------|---------|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme (storm variant) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Completion engine |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP/tool installer |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatting |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git diff signs |
| [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim) | Breadcrumb navigation |
| [supermaven-nvim](https://github.com/supermaven-inc/supermaven-nvim) | AI code completion |
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | Obsidian vault integration |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | Collection of small utilities |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding hints |

