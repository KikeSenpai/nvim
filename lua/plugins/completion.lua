-- [[ Autocompletion — blink.cmp + LuaSnip ]]

vim.pack.add({
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/saghen/blink.cmp",
}, { load = true })

-- NOTE: jsregexp not built — LuaSnip falls back to Lua patterns for snippet transforms
require("luasnip").setup {}

require("blink.cmp").setup {
  keymap = {
    preset = "default",

    ["<C-e>"] = false,
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-h>"] = { "show_signature", "hide_signature", "fallback" },
    ["<CR>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { "lsp", "path", "snippets" },
  },

  snippets = { preset = "luasnip" },

  fuzzy = { implementation = "lua" },

  signature = { enabled = true },
}
