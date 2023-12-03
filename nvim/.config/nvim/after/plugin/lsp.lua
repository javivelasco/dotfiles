local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
  local builtin = require("telescope.builtin")
  local function telescope_lsp_references()
    builtin.lsp_references({ include_declaration = false, show_line = false })
  end

  local function nmap(key, cmd, desc)
    vim.keymap.set("n", key, cmd, { buffer = bufnr, remap = false, desc = desc })
  end

  nmap("<leader>D", vim.lsp.buf.type_definition, "LSP: Type [D]efinition")
  nmap("<leader>rn", vim.lsp.buf.rename, "LSP: [R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "LSP: [C]ode [A]ction")
  nmap("<leader>f", vim.lsp.buf.format, "LSP: [F]ormat current buffer")
  nmap("<leader>K", vim.lsp.buf.signature_help, "LSP: Signature Documentation")
  nmap("K", vim.lsp.buf.hover, "LSP: Hover Documentation")
  nmap("gd", vim.lsp.buf.definition, "LSP: [G]oto [D]efinition")
  nmap("gI", vim.lsp.buf.implementation, "LSP: [G]oto [I]mplementation")
  nmap("gR", vim.lsp.buf.references, "LSP: [G]oto [R]eferences")
  nmap("<leader>ds", builtin.lsp_document_symbols, "LSP: [D]ocument [S]ymbols")
  nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "LSP: [W]orkspace [S]ymbols")
  nmap("<leader>gr", telescope_lsp_references, "LSP: [G]oto [R]eferences")
  nmap("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic message")
  nmap("]d", vim.diagnostic.goto_next, "Go to next diagnostic message")
  nmap("<leader>e", vim.diagnostic.open_float, "Open floating diagnostic message")
  nmap("<leader>q", vim.diagnostic.setloclist, "Open diagnostics list")


  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "LSP: Format current buffer" })

  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end

  -- Disable semantic tokens, it ruins the colorscheme
  client.server_capabilities.semanticTokensProvider = nil
end)

local rust_tools = require('rust-tools')
rust_tools.setup({
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
    end
  }
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { 'tsserver', 'rust_analyzer' },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
    rust_analyzer = function()
    end,
  }
})

lsp_zero.configure("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

lsp_zero.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
  },
})

local cmp = require("cmp")
local lspkind = require('lspkind')

cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
  },
  formatting = {
    format = lspkind.cmp_format({
      maxwidth = 50,
      ellipsis_char = '...',
    })
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  window = {
    completion = cmp.config.window.bordered({}),
    documentation = cmp.config.window.bordered(),
  },
})

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)

vim.api.nvim_set_hl(0, 'NormalFloat', {
  link = 'Normal',
})

vim.api.nvim_set_hl(0, 'FloatBorder', {
  bg = 'none',
})
