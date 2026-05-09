-- [[ Custom statusline — replicates old lualine layout ]]
-- Layout: mode | branch diff diagnostics | filename ---- encoding fileformat filetype | progress | location

local M = {}
local colorscheme = require("plugins.colorscheme")

local mode_map = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  c = "COMMAND",
  R = "REPLACE",
  t = "TERMINAL",
  s = "SELECT",
  S = "S-LINE",
}

local mode_hl = {
  n = "SLModeNormal",
  i = "SLModeInsert",
  v = "SLModeVisual",
  V = "SLModeVisual",
  ["\22"] = "SLModeVisual",
  c = "SLModeCommand",
  R = "SLModeReplace",
  t = "SLModeTerminal",
  s = "SLModeVisual",
  S = "SLModeVisual",
}

-- Cache git branch (updated on buffer/dir change)
local branch_cache = ""
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "DirChanged" }, {
  callback = function()
    local b = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("%s+", "")
    branch_cache = b ~= "" and b or ""
  end,
})

local function hl(group, text)
  if text == "" then
    return ""
  end
  return "%#" .. group .. "#" .. text .. "%*"
end

local function filetype_label()
  local ft = vim.bo.filetype
  if ft == "" then
    return ""
  end

  local icon = ""
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then
    local name = vim.fn.expand("%:t")
    icon = devicons.get_icon(name, nil, { default = true }) or ""
  end

  if icon ~= "" then
    return icon .. " " .. ft
  end
  return ft
end

local function fileformat_icon()
  local icons = {
    unix = "",
    dos = "",
    mac = "",
  }
  return icons[vim.bo.fileformat] or vim.bo.fileformat
end

function M.render()
  local m = vim.api.nvim_get_mode().mode
  local mode = mode_map[m] or m
  local mode_group = mode_hl[m] or "SLModeNormal"

  -- Section A: mode
  local section_a = hl(mode_group, " " .. mode .. " ")

  -- Section B: branch
  local section_branch = ""
  if branch_cache ~= "" then
    section_branch = hl("SLSectionB", "  " .. branch_cache .. " ")
  end

  -- Section G: git changes
  local git_added = ""
  local git_changed = ""
  local git_removed = ""
  local d = vim.b.gitsigns_status_dict
  if d then
    if (d.added or 0) > 0 then
      git_added = hl("SLGitAdded", "+" .. d.added)
    end
    if (d.changed or 0) > 0 then
      git_changed = hl("SLGitChanged", "~" .. d.changed)
    end
    if (d.removed or 0) > 0 then
      git_removed = hl("SLGitRemoved", "-" .. d.removed)
    end
  end
  local git_parts = {}
  if git_added ~= "" then
    git_parts[#git_parts + 1] = git_added
  end
  if git_changed ~= "" then
    git_parts[#git_parts + 1] = git_changed
  end
  if git_removed ~= "" then
    git_parts[#git_parts + 1] = git_removed
  end
  local section_git = #git_parts > 0 and table.concat(git_parts, hl("SLSectionB", " ")) .. hl("SLSectionB", " ") or ""

  -- Section D: diagnostics
  local counts = vim.diagnostic.count(0)
  local e = counts[vim.diagnostic.severity.ERROR] or 0
  local w = counts[vim.diagnostic.severity.WARN] or 0
  local i = counts[vim.diagnostic.severity.INFO] or 0
  local h = counts[vim.diagnostic.severity.HINT] or 0
  local diag_parts = {}
  if e > 0 then
    diag_parts[#diag_parts + 1] = hl("SLDiagError", "󰅚 " .. e)
  end
  if w > 0 then
    diag_parts[#diag_parts + 1] = hl("SLDiagWarn", "󰀪 " .. w)
  end
  if i > 0 then
    diag_parts[#diag_parts + 1] = hl("SLDiagInfo", "󰋼 " .. i)
  end
  if h > 0 then
    diag_parts[#diag_parts + 1] = hl("SLDiagHint", "󰌵 " .. h)
  end
  local section_diag = #diag_parts > 0
      and hl("SLSectionB", " ") .. table.concat(diag_parts, hl("SLSectionB", " ")) .. hl("SLSectionB", " ")
    or ""
  local section_sep = hl("SLSectionB", " | ")
  local sep_branch_git = section_branch ~= "" and section_git ~= "" and section_sep or ""
  local sep_git_diag = section_git ~= "" and section_diag ~= "" and section_sep or ""
  local sep_branch_diag = section_branch ~= "" and section_git == "" and section_diag ~= "" and section_sep or ""

  -- Section C: filename (left side)
  local section_c = hl("SLSectionC", " %t%m%r ")

  -- Section X: encoding, fileformat, filetype (right side)
  local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local ff = fileformat_icon()
  local ft = filetype_label()
  local x_parts = { enc, ff }
  if ft ~= "" then
    x_parts[#x_parts + 1] = ft
  end
  local section_x = hl("SLSectionC", " " .. table.concat(x_parts, " | ") .. " ")

  -- Section Y: progress
  local section_y = hl("SLSectionB", " %p%% ")

  -- Section Z: location (matches mode color)
  local section_z = hl(mode_group, " %l:%c ")

  return table.concat {
    section_a,
    "%<",
    section_branch,
    sep_branch_git,
    section_git,
    sep_git_diag,
    sep_branch_diag,
    section_diag,
    section_c,
    "%=",
    section_x,
    section_y,
    section_z,
  }
end

function M.setup()
  local colors = colorscheme.get_palette()
  local set = vim.api.nvim_set_hl

  -- Section A / Z: bold mode color on dark bg (changes per mode)
  set(0, "SLModeNormal", { bg = colors.blue, fg = colors.dark, bold = true })
  set(0, "SLModeInsert", { bg = colors.green, fg = colors.dark, bold = true })
  set(0, "SLModeVisual", { bg = colors.magenta, fg = colors.dark, bold = true })
  set(0, "SLModeCommand", { bg = colors.yellow, fg = colors.dark, bold = true })
  set(0, "SLModeReplace", { bg = colors.red, fg = colors.dark, bold = true })
  set(0, "SLModeTerminal", { bg = colors.cyan, fg = colors.dark, bold = true })

  -- Section B: mid-tone background
  set(0, "SLSectionB", { bg = colors.bg_mid, fg = colors.fg })
  set(0, "SLGitAdded", { bg = colors.bg_mid, fg = colors.green, bold = true })
  set(0, "SLGitChanged", { bg = colors.bg_mid, fg = colors.yellow, bold = true })
  set(0, "SLGitRemoved", { bg = colors.bg_mid, fg = colors.red, bold = true })
  set(0, "SLDiagError", { bg = colors.bg_mid, fg = colors.red, bold = true })
  set(0, "SLDiagWarn", { bg = colors.bg_mid, fg = colors.yellow, bold = true })
  set(0, "SLDiagInfo", { bg = colors.bg_mid, fg = colors.blue, bold = true })
  set(0, "SLDiagHint", { bg = colors.bg_mid, fg = colors.cyan, bold = true })

  -- Section C / X: dark background
  set(0, "SLSectionC", { bg = colors.bg_dark, fg = colors.fg })
end

function M.init()
  local group = vim.api.nvim_create_augroup("StatuslineHighlights", { clear = true })

  M.setup()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      colorscheme.invalidate_palette()
      M.setup()
    end,
  })

  vim.o.statusline = "%!v:lua.require('statusline').render()"
end

return M
