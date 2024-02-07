return {
  {
    -- Lightweight yet powerful formatter plugin for Neovim
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          css = { "prettierd" },
          html = { "prettierd" },
          javascript = { "prettierd" },
          javascriptreact = { "prettierd" },
          json = { "prettierd" },
          lua = { "stylua" },
          markdown = { "prettierd" },
          svelte = { "prettierd" },
          typescript = { "prettierd" },
          typescriptreact = { "prettierd" },
          yaml = { "prettierd" },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        conform.format({
          lsp_fallback = true,
          async = false,
        })
      end, { desc = "Format file or range" })
    end,
  },

  {
    -- Prettier plugin for Neovim's built-in LSP client.
    "MunifTanjim/prettier.nvim",
  },

  {
    -- EditorConfig plugin for Neovim written in Fennel
    "gpanders/editorconfig.nvim",
  },
}
