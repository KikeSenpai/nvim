-- [[ Visual enhancements — rainbow indent guides + colored brackets ]]

vim.pack.add({
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/HiPhish/rainbow-delimiters.nvim",
}, { load = true })

-- Shared tokyonight storm colors
local colors = {
  red = "#f7768e",
  yellow = "#e0af68",
  blue = "#7aa2f7",
  purple = "#bb9af7",
  orange = "#ff9e64",
  cyan = "#7dcfff",
}

-- Indent guides
local hooks = require("ibl.hooks")

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowIndentRed", { fg = colors.red })
  vim.api.nvim_set_hl(0, "RainbowIndentYellow", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "RainbowIndentBlue", { fg = colors.blue })
  vim.api.nvim_set_hl(0, "RainbowIndentPurple", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "RainbowIndentOrange", { fg = colors.orange })
  vim.api.nvim_set_hl(0, "RainbowIndentCyan", { fg = colors.cyan })
end)

require("ibl").setup({
  indent = {
    highlight = {
      "RainbowIndentRed",
      "RainbowIndentYellow",
      "RainbowIndentBlue",
      "RainbowIndentPurple",
      "RainbowIndentOrange",
      "RainbowIndentCyan",
    },
    char = "│",
  },
  scope = {
    enabled = false,
    char = "┃",
  },
})

-- Rainbow brackets
local rainbow = require("rainbow-delimiters")

vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = colors.red })
vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = colors.blue })
vim.api.nvim_set_hl(0, "RainbowDelimiterPurple", { fg = colors.purple })
vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = colors.orange })
vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = colors.cyan })

require("rainbow-delimiters.setup").setup({
  strategy = {
    [""] = rainbow.strategy["global"],
    vim = rainbow.strategy["local"],
  },
  query = {
    [""] = "rainbow-delimiters",
    lua = "rainbow-blocks",
  },
  priority = {
    [""] = 110,
    lua = 210,
  },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterPurple",
    "RainbowDelimiterOrange",
    "RainbowDelimiterCyan",
  },
  blacklist = { "c", "cpp" },
})
