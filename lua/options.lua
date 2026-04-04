-- [[ Setting options ]]

-- Line numbers with relative
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Keeps indentation when wrapping lines
vim.o.breakindent = true

-- Enable wrapping lines by whole words
vim.o.linebreak = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 500

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Whitespace display
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', lead = '·' }

-- Preview substitutions live
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Enable 24-bit color
vim.o.termguicolors = true

-- Tab settings (method 3: tabstop=8, shiftwidth/softtabstop=4, noexpandtab)
vim.o.tabstop = 8
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = false

-- Vertical line for code line limit
vim.o.colorcolumn = '120'

-- Highlight on search
vim.o.hlsearch = true

-- Completion options (updated for 0.12 native completion)
vim.o.completeopt = 'menuone,noselect,fuzzy'

-- Built-in optional packages (0.12)
vim.cmd.packadd 'nvim.undotree'
vim.cmd.packadd 'nvim.difftool'

-- Custom filetypes
vim.filetype.add {
  extension = {
    lock = 'toml',
  },
  pattern = {
    ['.*/templates/.*%.yaml'] = 'helm',
    ['.*/templates/.*%.tpl'] = 'helm',
    ['helmfile.*%.yaml'] = 'helm',
  },
}

-- vim: ts=2 sts=2 sw=2 et
