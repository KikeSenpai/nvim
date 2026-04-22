-- Set <space> as the leader key
-- NOTE: Must happen before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Assign a virtualenv for Neovim so that the `pynvim` package is not required for each virtualenv
vim.g.python3_host_prog = "/Users/enrique.perez/.virtualenvs/nvim/bin/python"

-- Make Node-based tools available to Neovim even when Node is managed by nvm.
local function ensure_node_on_path()
  if vim.fn.exepath("node") ~= "" then
    return
  end

  local nvm_dir = vim.env.NVM_DIR or (vim.env.HOME .. "/.nvm")
  local default_alias = vim.trim(table.concat(vim.fn.readfile(nvm_dir .. "/alias/default"), ""))
  if default_alias == "" then
    return
  end

  local version_glob = string.format("%s/versions/node/v%s.*/bin", nvm_dir, default_alias)
  local matches = vim.fn.glob(version_glob, false, true)
  if #matches == 0 then
    return
  end

  table.sort(matches)
  vim.env.PATH = matches[#matches] .. ":" .. vim.env.PATH
end

ensure_node_on_path()

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

-- NOTE: Enable experimental ui2 (removes "Press ENTER" prompts)
pcall(function()
  require("vim._core.ui2").enable()
end)
