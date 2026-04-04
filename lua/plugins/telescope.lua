-- [[ Fuzzy finder ]]

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}, { load = true })

require('telescope').setup {
  pickers = {
    find_files = { hidden = true },
    live_grep = { additional_args = { '--hidden' } },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search by [F]ilename' })
vim.keymap.set('n', '<leader>sb', builtin.builtin, { desc = 'Search Telescope [B]uiltin' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search Current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search Files by [G]rep' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Search Recent Files' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Search Open Files' })
vim.keymap.set('n', '<leader>dl', builtin.diagnostics, { desc = 'Open Diagnostics [L]ist' })
vim.keymap.set('n', '<leader>jl', builtin.jumplist, { desc = 'Open Jump[l]ist' })

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
    prompt_title = 'Live grep in current buffer',
  })
end, { desc = 'Search Buffer by Grep' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = 'Search Opened Files by Grep' })

vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Search [N]eovim Config Files' })

-- vim: ts=2 sts=2 sw=2 et
