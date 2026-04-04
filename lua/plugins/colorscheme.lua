vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
}, { load = true })

require('tokyonight').setup {
  style = 'storm',
}

vim.cmd.colorscheme 'tokyonight'

-- vim: ts=2 sts=2 sw=2 et
