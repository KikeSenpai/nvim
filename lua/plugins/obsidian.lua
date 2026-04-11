-- [[ Obsidian vault integration + markdown rendering ]]

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/epwalsh/obsidian.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
}, { load = true })

-- Markdown rendering
require("render-markdown").setup({
  file_types = { "markdown" },
})

vim.keymap.set("n", "<leader>mt", ":RenderMarkdown toggle<CR>", { desc = "[T]oggle Render Markdown" })

require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "~/Downloads/enrique-perez-obsidian/",
    },
  },
  completion = {
    min_chars = 2,
  },
  new_notes_location = "current_dir",
  preferred_link_style = "markdown",
  ui = { enable = false },

  mappings = {
    ["<leader>of"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
      desc = "[F]ollow Link",
    },
    ["<leader>oc"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
      desc = "Toggle [C]heckbox",
    },
  },

  note_frontmatter_func = function(note)
    local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = "", project = "" }
    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end
    return out
  end,

  note_id_func = function(title)
    local suffix = ""
    if title ~= nil then
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return suffix
  end,

  templates = {
    folder = "Templates",
    date_format = "%Y-%m-%d-%a",
    time_format = "%H:%M",
  },
})

-- Obsidian keymaps
vim.keymap.set("n", "<leader>on", ":ObsidianNew<CR>", { desc = "Create [N]ew Note" })
vim.keymap.set("n", "<leader>os", ":ObsidianSearch<CR>", { desc = "[S]earch Notes" })
vim.keymap.set({ "n", "v" }, "<leader>ol", ":ObsidianLink<CR>", { desc = "[L]ink Selection to Note" })
vim.keymap.set("n", "<leader>ok", ":ObsidianLinks<CR>", { desc = "Search Lin[k]s in Buffer" })
vim.keymap.set("n", "<leader>ot", ":ObsidianTags<CR>", { desc = "Search for [T]ags Ocurrences" })
