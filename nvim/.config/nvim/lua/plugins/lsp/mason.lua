return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        -- Note: TypeScript servers (tsgo/vtsls) are configured in typescript.lua
      },
      -- mason-lspconfig v2 auto-enables every installed server via vim.lsp.enable.
      -- Exclude the ones we manage manually (TS toggle) or don't want at all.
      automatic_enable = {
        exclude = {
          "tsgo",
          "vtsls",
          "ts_ls",
          "eslint", -- we lint with eslint_d through nvim-lint instead
        },
      },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettierd", -- prettier daemon (faster)
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint", -- python linter
        "eslint_d", -- eslint daemon (faster linting)
        "tsgo", -- TypeScript native LSP (typescript-go) - default TS server
        "vtsls", -- TypeScript/JavaScript LSP - fallback for refactors
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
  },
}
