-- Set <space> as the leader key
-- Must happen before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Assign a virtualenv for Neovim so that the `pynvim` package is not required for each virtualenv
vim.g.python3_host_prog = "/Users/enrique.perez/.pyenv/versions/py3.12-nvim/bin/python"

-- Nerd Font available in terminal
vim.g.have_nerd_font = true

-- Setting options
require("options")

-- Setting keymaps
require("keymaps")

-- Load plugins from lua/plugins/
for _, file in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugins/*.lua", false, true)) do
	local name = vim.fn.fnamemodify(file, ":t:r")
	require("plugins." .. name)
end

-- Statusline (after plugins so colorscheme is loaded)
require("statusline").setup()

-- Enable experimental ui2 (removes "Press ENTER" prompts)
pcall(function()
	require("vim._core.ui2").enable()
end)

-- vim: ts=2 sts=2 sw=2 et
