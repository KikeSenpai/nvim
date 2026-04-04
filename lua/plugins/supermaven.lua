-- [[ AI code completion (disabled by default) ]]

vim.pack.add({
  'https://github.com/supermaven-inc/supermaven-nvim',
}, { load = true })

require('supermaven-nvim').setup {
  keymaps = {
    accept_suggestion = '<M-CR>',
    clear_suggestion = '<C-[>',
    accept_word = '<M-;>',
  },
  ignore_filetypes = {},
  log_level = 'off',
  disable_inline_completion = false,
  disable_keymaps = false,
}

-- vim: ts=2 sts=2 sw=2 et
