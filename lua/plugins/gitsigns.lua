-- [[ Git signs in gutter + blame ]]

vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
}, { load = true })

require("gitsigns").setup {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    map("n", "]h", function()
      if vim.wo.diff then
        vim.cmd.normal { "]h", bang = true }
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Next Git [H]unk" })

    map("n", "[h", function()
      if vim.wo.diff then
        vim.cmd.normal { "[h", bang = true }
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Previous Git [H]unk" })

    map("n", "<leader>hb", gitsigns.blame_line, { desc = "Git [B]lame Line" })
  end,
}
