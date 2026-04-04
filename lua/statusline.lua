-- [[ Custom statusline — replicates old lualine layout ]]
-- Layout: mode | branch diff diagnostics | filename ---- encoding fileformat filetype | progress | location

local M = {}

-- Tokyonight storm lualine colors
local colors = {
  bg_dark = '#1f2335',
  bg_mid = '#3b4261',
  fg = '#a9b1d6',
  blue = '#7aa2f7',
  green = '#9ece6a',
  magenta = '#bb9af7',
  yellow = '#e0af68',
  red = '#f7768e',
  cyan = '#56b6c2',
  dark = '#1f2335',
}

local mode_map = {
  n = 'NORMAL', i = 'INSERT', v = 'VISUAL', V = 'V-LINE',
  ['\22'] = 'V-BLOCK', c = 'COMMAND', R = 'REPLACE', t = 'TERMINAL',
  s = 'SELECT', S = 'S-LINE',
}

local mode_hl = {
  n = 'SLModeNormal', i = 'SLModeInsert', v = 'SLModeVisual', V = 'SLModeVisual',
  ['\22'] = 'SLModeVisual', c = 'SLModeCommand', R = 'SLModeReplace', t = 'SLModeTerminal',
  s = 'SLModeVisual', S = 'SLModeVisual',
}

-- Cache git branch (updated on buffer/dir change)
local branch_cache = ''
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'DirChanged' }, {
  callback = function()
    local b = vim.fn.system('git rev-parse --abbrev-ref HEAD 2>/dev/null'):gsub('%s+', '')
    branch_cache = b ~= '' and b or ''
  end,
})

local function hl(group, text)
  if text == '' then return '' end
  return '%#' .. group .. '#' .. text .. '%*'
end

function M.render()
  local m = vim.api.nvim_get_mode().mode
  local mode = mode_map[m] or m
  local mode_group = mode_hl[m] or 'SLModeNormal'

  -- Section A: mode
  local section_a = hl(mode_group, ' ' .. mode .. ' ')

  -- Section B: branch, diff, diagnostics
  local b_parts = {}
  if branch_cache ~= '' then
    b_parts[#b_parts + 1] = ' ' .. branch_cache
  end
  local d = vim.b.gitsigns_status_dict
  if d then
    if (d.added or 0) > 0 then b_parts[#b_parts + 1] = '+' .. d.added end
    if (d.changed or 0) > 0 then b_parts[#b_parts + 1] = '~' .. d.changed end
    if (d.removed or 0) > 0 then b_parts[#b_parts + 1] = '-' .. d.removed end
  end
  local diag = vim.diagnostic.status and vim.diagnostic.status(0) or ''
  if diag ~= '' then b_parts[#b_parts + 1] = diag end
  local section_b = #b_parts > 0 and hl('SLSectionB', ' ' .. table.concat(b_parts, ' ') .. ' ') or ''

  -- Section C: filename (left side)
  local section_c = hl('SLSectionC', ' %f%m%r ')

  -- Section X: encoding, fileformat, filetype (right side)
  local enc = vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding
  local ff = vim.bo.fileformat
  local section_x = hl('SLSectionC', ' ' .. enc .. ' ' .. ff .. ' %y ')

  -- Section Y: progress
  local section_y = hl('SLSectionB', ' %p%% ')

  -- Section Z: location (matches mode color)
  local section_z = hl(mode_group, ' %l:%c ')

  return table.concat {
    section_a,
    section_b,
    section_c,
    '%=',
    section_x,
    section_y,
    section_z,
  }
end

function M.setup()
  local set = vim.api.nvim_set_hl

  -- Section A / Z: bold mode color on dark bg (changes per mode)
  set(0, 'SLModeNormal', { bg = colors.blue, fg = colors.dark, bold = true })
  set(0, 'SLModeInsert', { bg = colors.green, fg = colors.dark, bold = true })
  set(0, 'SLModeVisual', { bg = colors.magenta, fg = colors.dark, bold = true })
  set(0, 'SLModeCommand', { bg = colors.yellow, fg = colors.dark, bold = true })
  set(0, 'SLModeReplace', { bg = colors.red, fg = colors.dark, bold = true })
  set(0, 'SLModeTerminal', { bg = colors.cyan, fg = colors.dark, bold = true })

  -- Section B: mid-tone background
  set(0, 'SLSectionB', { bg = colors.bg_mid, fg = colors.fg })

  -- Section C / X: dark background
  set(0, 'SLSectionC', { bg = colors.bg_dark, fg = colors.fg })

  -- Reapply highlights after colorscheme change
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      M.setup()
    end,
  })

  vim.o.statusline = "%!v:lua.require('statusline').render()"
end

return M

-- vim: ts=2 sts=2 sw=2 et
