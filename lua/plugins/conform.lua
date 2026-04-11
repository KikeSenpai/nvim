-- [[ Code formatting ]]

vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
}, { load = true })

require("conform").setup({
  notify_on_error = false,
  formatters_by_ft = {
    lua = { "stylua" },
    terraform = { "terraform_fmt" },
    markdown = { "markdownlint" },
    json = { "jq" },
  },
  default_format_opts = {
    lsp_format = "never",
  },
  format_on_save = function(bufnr)
    local disable_filetypes = {
      proto = true,
      sql = true,
    }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    end
    return {
      timeout_ms = 500,
      lsp_format = "fallback",
    }
  end,
})

vim.keymap.set("", "<leader>f", function()
  require("conform").format({ async = true })
end, { desc = "[F]ormat the current buffer" })
