-- [[ Keymap hints popup ]]

vim.pack.add({
  "https://github.com/folke/which-key.nvim",
}, { load = true })

require("which-key").setup({
  delay = 0,
  preset = false,
  icons = {
    mappings = vim.g.have_nerd_font,
  },
  win = {
    no_overlap = true,
    border = "rounded",
    padding = { 1, 2 },
    row = math.huge,
    col = math.huge,
    width = 45,
    height = { min = 4, max = 25 },
  },
  spec = {
    { "<leader>b", group = "[B]uffer" },
    { "<leader>d", group = "[D]iagnostic" },
    { "<leader>e", group = "File [E]xplorer" },
    { "<leader>g", group = "[G]oto" },
    { "<leader>h", group = "Git [H]unks", mode = { "n", "v" } },
    { "<leader>j", group = "[J]ump anywhere" },
    { "<leader>l", group = "[L]SP" },
    { "<leader>m", group = "[M]arkdown" },
    { "<leader>o", group = "[O]bsidian" },
    { "<leader>p", group = "S[p]ell Checking" },
    { "<leader>s", group = "[S]earch" },
    { "<leader>w", group = "[W]indow" },
  },
})
