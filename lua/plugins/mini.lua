-- [[ Mini.nvim modules — surround, ai, files, pairs, bracketed ]]

vim.pack.add({
  "https://github.com/echasnovski/mini.nvim",
}, { load = true })

-- Better Around/Inside textobjects
require("mini.ai").setup { n_lines = 500 }

-- Add/delete/replace surroundings (brackets, quotes, etc.)
-- Keymaps match vim-surround (ys/cs/ds) for consistency with the JetBrains ideavimrc
require("mini.surround").setup {
  mappings = {
    add = "ys",
    delete = "ds",
    replace = "cs",
  },
}

-- File explorer
local mini_files = require("mini.files")
mini_files.setup {
  mappings = {
    go_in = "L",
    go_in_plus = "",
    go_out = "H",
    go_out_plus = "",
    synchronize = "U",
  },
}

vim.keymap.set("n", "<leader>ef", function()
  mini_files.open()
end, { desc = "[F]ocus Mini File Explorer" })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf = args.data.buf_id

    vim.keymap.set("n", "L", function()
      local entry = mini_files.get_fs_entry()
      if entry and entry.fs_type == "file" then
        mini_files.go_in { close_on_file = true }
      else
        mini_files.go_in()
      end
    end, { buffer = buf, desc = "Go in (close on file)" })

    vim.keymap.set("n", "<C-v>", function()
      local entry = mini_files.get_fs_entry()
      if entry and entry.fs_type == "file" then
        mini_files.close()
        vim.cmd("vsplit " .. vim.fn.fnameescape(entry.path))
      end
    end, { buffer = buf, desc = "Open in vertical split" })
  end,
})

-- Auto-pairs for quotes, brackets, etc.
require("mini.pairs").setup()

-- Navigate with square brackets (]b next buffer, [b prev buffer, etc.)
require("mini.bracketed").setup()
