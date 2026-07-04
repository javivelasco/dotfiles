return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "1.*", -- use prebuilt Rust fuzzy matcher binaries
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
    },
    "rafamadriz/friendly-snippets", -- useful snippets
  },
  config = function()
    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    require("blink.cmp").setup({
      snippets = { preset = "luasnip" },
      -- keep the same muscle memory as the old nvim-cmp setup
      keymap = {
        preset = "none",
        ["<C-k>"] = { "select_prev", "fallback" }, -- previous suggestion
        ["<C-j>"] = { "select_next", "fallback" }, -- next suggestion
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" }, -- close completion window
        ["<CR>"] = { "accept", "fallback" }, -- confirm (no auto-select)
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      completion = {
        list = {
          selection = { preselect = false, auto_insert = false },
        },
        documentation = { auto_show = true },
        accept = {
          auto_brackets = { enabled = true }, -- add parens on function accept
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
      },
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true },
    })
  end,
}
