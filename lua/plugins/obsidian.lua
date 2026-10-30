-- [[ Obsidian vault integration + markdown rendering ]]

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/epwalsh/obsidian.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
}, { load = true })

-- Markdown rendering
require("render-markdown").setup {
  file_types = { "markdown" },
}

vim.keymap.set("n", "<leader>mt", ":RenderMarkdown toggle<CR>", { desc = "[T]oggle Render Markdown" })

require("obsidian").setup {
  workspaces = {
    {
      name = "personal",
      path = "~/Downloads/enrique-perez-obsidian/",
    },
  },
  completion = {
    min_chars = 2,
  },
  daily_notes = {
    folder = "2.Areas/Parloa/Daily Planning",
    date_format = "%Y-%m-%d",
  },
  new_notes_location = "current_dir",
  preferred_link_style = "markdown",
  ui = { enable = false },

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
}

-- Obsidian keymaps
vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<CR>", { desc = "Open Today's [D]aily Note" })
vim.keymap.set("n", "<leader>om", "<cmd>ObsidianTomorrow<CR>", { desc = "Open To[m]orrow's Daily Note" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "[O]pen in Obsidian" })
vim.keymap.set("n", "<leader>os", ":ObsidianSearch<CR>", { desc = "[S]earch Notes" })
vim.keymap.set({ "n", "v" }, "<leader>ol", ":ObsidianLink<CR>", { desc = "[L]ink Selection to Note" })
vim.keymap.set("n", "<leader>ok", ":ObsidianLinks<CR>", { desc = "Search Lin[k]s in Buffer" })
vim.keymap.set("n", "<leader>ot", ":ObsidianTags<CR>", { desc = "Search for [T]ags Ocurrences" })

-- ObsidianNew skips the daily-notes folder and any file outside the vault.
vim.keymap.set("n", "<leader>on", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    vim.notify("No file in this buffer", vim.log.levels.WARN)
    return
  end
  local dir = vim.fn.fnamemodify(bufname, ":p:h")
  local title = require("obsidian.util").input("Enter title or path (optional): ", { completion = "file" })
  if not title then
    require("obsidian.log").warn("Aborted")
    return
  elseif title == "" then
    title = nil
  elseif title:find("/", 1, true) then
    dir = vim.fn.fnamemodify(dir .. "/" .. title, ":p:h")
    title = vim.fn.fnamemodify(title, ":t")
    if title == "" then
      title = nil
    end
  end
  local client = require("obsidian").get_client()
  local note = client:create_note { title = title, dir = dir, no_write = true }
  client:open_note(note, { sync = true })
  client:write_note_to_buffer(note)
end, { desc = "Create [N]ew Note" })
