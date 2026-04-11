vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
}, { load = true })

require("tokyonight").setup({
  style = "storm",
})

vim.cmd.colorscheme("tokyonight")
