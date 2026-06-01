-- [[ LSP Configuration ]]

-- Mason: auto-install LSP servers and tools
vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
}, { load = true })

require("mason").setup()

-- Language servers
local servers = {
  "cssls",
  "dockerls",
  "jsonls",
  "marksman",
  "pyright",
  "tflint",
  "terraformls",
  "ts_ls",
  "yamlls",
  "html",
  "kcl",
  "lua_ls",
  "helm_ls",
  "kotlin_lsp",
  "mmdc",
}

-- Per-server settings
vim.lsp.config("helm_ls", {
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
      },
    },
  },
})

-- Enable all servers (native 0.12 API)
vim.lsp.enable(servers)

-- Ensure servers and tools are installed via mason
local ensure_installed = vim.list_extend(vim.deepcopy(servers), {
  "stylua",
  "markdownlint",
  "luacheck",
  "jq",
})
require("mason-tool-installer").setup { ensure_installed = ensure_installed }
require("mason-lspconfig").setup {
  ensure_installed = {},
  automatic_installation = false,
}

-- Diagnostic config
vim.diagnostic.config {
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  virtual_text = {
    source = "if_many",
    spacing = 2,
  },
}

-- LSP keymaps (set on attach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
    end

    local builtin = require("telescope.builtin")
    map("<leader>gd", vim.lsp.buf.definition, "Goto [D]efinition")
    map("<leader>gD", vim.lsp.buf.declaration, "Goto [D]eclaration")
    map("<leader>gt", builtin.lsp_type_definitions, "Goto [T]ype Definition")
    map("<leader>gi", builtin.lsp_implementations, "Goto [I]mplementation")
    map("<leader>sr", builtin.lsp_references, "Search [R]eferences")
    map("<leader>sy", builtin.lsp_document_symbols, "Search Document S[y]mbols")
    map("<leader>sp", builtin.lsp_dynamic_workspace_symbols, "Search Works[p]ace Symbols")
    map("<leader>lr", vim.lsp.buf.rename, "[R]ename Symbol")
    map("<leader>lh", vim.lsp.buf.hover, "Display [H]over Information")
    map("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")
    map("<leader>lx", vim.lsp.codelens.run, "Execute Code [L]ens")

    -- Highlight references under cursor
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Toggle inlay hints
    if client and client.server_capabilities.inlayHintProvider then
      map("<leader>li", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
      end, "Toggle [I]nlay Hints")
    end
    if client and client.server_capabilities.documentHighlightProvider then
      local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
        end,
      })
    end
  end,
})

-- KCL filetype detection
vim.filetype.add { extension = { k = "kcl" } }
