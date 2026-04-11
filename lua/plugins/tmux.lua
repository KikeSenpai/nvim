-- Seamless navigation and resizing between neovim and tmux window splits
vim.pack.add({
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/RyanMillerC/better-vim-tmux-resizer",
}, { load = true })

-- Tmux resizer settings
vim.g.tmux_resizer_no_mappings = 1
vim.g.tmux_resizer_resize_count = 2
vim.g.tmux_resizer_vertical_resize_count = 2

-- Window resizing (tmux-aware)
vim.keymap.set("n", "<C-S-Up>", ":TmuxResizeUp<CR>", { silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<C-S-Down>", ":TmuxResizeDown<CR>", { silent = true, desc = "Decrease window height" })
vim.keymap.set("n", "<C-S-Left>", ":TmuxResizeLeft<CR>", { silent = true, desc = "Decrease window width" })
vim.keymap.set("n", "<C-S-Right>", ":TmuxResizeRight<CR>", { silent = true, desc = "Increase window width" })
