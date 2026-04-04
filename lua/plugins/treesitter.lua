-- [[ Treesitter — syntax highlighting and parser management ]]

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
}, { load = true })

local parsers = {
  'bash',
  'css',
  'diff',
  'dockerfile',
  'hcl',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'proto',
  'python',
  'regex',
  'sql',
  'terraform',
  'toml',
  'typescript',
  'vim',
  'yaml',
}

-- Install missing parsers on startup
local installed = require('nvim-treesitter').get_installed()
local missing = vim.tbl_filter(function(lang)
  return not vim.tbl_contains(installed, lang)
end, parsers)

if #missing > 0 then
  require('nvim-treesitter.install').install(missing, { summary = true })
end

-- Enable treesitter highlighting for all filetypes with parsers
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-highlight', { clear = true }),
  callback = function()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang and pcall(vim.treesitter.language.add, lang) then
      pcall(vim.treesitter.start)
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et
