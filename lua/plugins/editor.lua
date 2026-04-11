-- [[ Editor enhancements — indent detection, TODO highlights, motion jumps ]]

vim.pack.add({
  "https://github.com/nmac427/guess-indent.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/folke/flash.nvim",
}, { load = true })

-- Auto-detect indentation
require("guess-indent").setup({
  filetype_exclude = {
    "lua",
  },
})

-- Highlight TODOs, NOTEs, WARNs in comments
require("todo-comments").setup({ signs = false })

-- Motion jumps
require("flash").setup({})

vim.keymap.set({ "n", "x", "o" }, "<leader>jp", function()
  require("flash").jump()
end, { desc = "Jump to [P]attern" })

vim.keymap.set({ "n", "x", "o" }, "<leader>jt", function()
  require("flash").treesitter()
end, { desc = "Jump to syntax [T]ree block" })
