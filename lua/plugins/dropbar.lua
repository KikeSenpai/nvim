-- [[ LSP breadcrumbs in winbar ]]

vim.pack.add({
  'https://github.com/Bekaboo/dropbar.nvim',
}, { load = true })

-- Defer setup to avoid conflict with vim.pack redraw during startup
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    require('dropbar').setup {
      menu = {
        quick_navigation = false,
      },
      sources = {
        path = { enabled = true },
        treesitter = { enabled = true },
        lsp = { enabled = true },
      },
    }
  end,
})

-- vim: ts=2 sts=2 sw=2 et
