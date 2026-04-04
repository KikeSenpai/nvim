-- [[ Basic Keymaps ]]

-- Clear highlight on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dm', vim.diagnostic.open_float, { desc = 'Display Diagnostic [M]essage' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open Diagnostics [Q]uickfix List' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Window navigation with CTRL+<hjkl>
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Set jk as escape key
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Escape from insert mode' })

-- Stay in indentation mode
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })

-- Move lines up and down
vim.keymap.set('n', 'K', ':m .-2<CR>==', { desc = 'Move line up in normal mode' })
vim.keymap.set('n', 'J', ':m .+1<CR>==', { desc = 'Move line down in normal mode' })
vim.keymap.set('x', 'K', ":move '<-2<CR>gv=gv", { desc = 'Move line up in visual mode' })
vim.keymap.set('x', 'J', ":move '>+1<CR>gv=gv", { desc = 'Move line down in visual mode' })

-- Join lines (since J is remapped to move lines)
vim.keymap.set('n', '<leader>J', 'J', { desc = '[J]oin Lines' })

-- Buffer management
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = '[D]elete current [B]uffer' })
vim.keymap.set('n', '<leader>ba', ':%bd|edit#|bd#<CR>', { desc = 'Delete [A]ll [B]uffers' })
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = 'Goto [N]ext [B]uffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { desc = 'Goto [P]revious [B]uffer' })

-- Window management
vim.keymap.set('n', '<leader>wh', '<C-W>s', { desc = 'Split Window [H]orizontally' })
vim.keymap.set('n', '<leader>wv', '<C-W>v', { desc = 'Split Window [V]ertically' })
vim.keymap.set('n', '<leader>we', '<C-W>=', { desc = 'Make split Windows [E]qual width' })
vim.keymap.set('n', '<leader>wq', '<C-W>q', { desc = '[Q]uit current Window' })

-- Spell checking
vim.keymap.set('n', '<leader>pt', '<cmd>set spell!<CR>', { desc = '[T]oggle Spell Check' })
vim.keymap.set('n', '<leader>pc', '[s1z=', { desc = '[C]orrect Word' })
vim.keymap.set('n', '<leader>pa', 'zg', { noremap = true, silent = true, desc = '[A]dd Word to Dictionary' })

-- Navigate between quickfix list items
vim.keymap.set('n', '<leader>gq', ':cnext<CR>zz', { desc = 'Goto next [Q]uickfix item' })
vim.keymap.set('n', '<leader>gQ', ':cprev<CR>zz', { desc = 'Goto previous [Q]uickfix item' })

-- [[ Autocommands ]]

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Open help window in a vertical split to the right
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Open help window in a vertical split to the right',
  group = vim.api.nvim_create_augroup('help-window-right', { clear = true }),
  pattern = { '*.txt' },
  callback = function()
    if vim.bo.filetype == 'help' then
      vim.cmd.wincmd 'L'
    end
  end,
})

-- Set filetype for JSONL files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.jsonl',
  command = 'set filetype=json',
})

-- vim: ts=2 sts=2 sw=2 et
