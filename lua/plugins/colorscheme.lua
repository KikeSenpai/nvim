local M = {}

local current_theme = {
  plugin = "https://github.com/folke/tokyonight.nvim",
  name = "tokyonight",
  style = "storm",
  setup = function()
    require("tokyonight").setup {
      style = "storm",
    }
  end,
  palette = function()
    local colors = require("tokyonight.colors").setup { style = "storm" }
    return {
      bg_dark = colors.bg_statusline or colors.bg_dark,
      bg_mid = colors.fg_gutter,
      fg = colors.fg_sidebar or colors.fg_dark or colors.fg,
      dark = colors.black or colors.bg_dark,
      blue = colors.blue,
      green = colors.green,
      magenta = colors.magenta,
      purple = colors.purple,
      yellow = colors.yellow,
      red = colors.red,
      cyan = colors.cyan,
      orange = colors.orange,
      rainbow = {
        colors.red,
        colors.yellow,
        colors.blue,
        colors.purple,
        colors.orange,
        colors.cyan,
      },
    }
  end,
}

local palette_cache

function M.get_palette()
  if not palette_cache then
    palette_cache = current_theme.palette()
  end
  return palette_cache
end

function M.invalidate_palette()
  palette_cache = nil
end

function M.setup()
  vim.pack.add({
    current_theme.plugin,
  }, { load = true })

  current_theme.setup()
  vim.cmd.colorscheme(current_theme.name)
  M.invalidate_palette()
end

M.setup()

return M
