return {
  {
    -- Setup for init.lua and Plugin development
    "folke/neodev.nvim",
    opts = {},
  },

  {
    -- Setup for lsp-zero.nvim
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
      { "onsails/lspkind.nvim" },
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      ---@diagnostic disable-next-line: unused-local
      lsp_zero.on_attach(function(_client, bufnr)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, {
          desc = "LSP: Type [D]efinition",
          buffer = bufnr,
          remap = false,
        })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
          desc = "LSP: [R]e[n]ame",
          buffer = bufnr,
          remap = false,
        })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
          desc = "LSP: [C]ode [A]ction",
          buffer = bufnr,
          remap = false,
        })
        vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, {
          desc = "LSP: Signature Documentation",
          buffer = bufnr,
          remap = false,
        })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {
          buffer = bufnr,
          remap = false,
          desc = "LSP: Hover Documentation",
        })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
          desc = "LSP: [G]oto [D]efinition",
          buffer = bufnr,
          remap = false,
        })
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, {
          desc = "LSP: [G]oto [I]mplementation",
          buffer = bufnr,
          remap = false,
        })
        vim.keymap.set("n", "gR", vim.lsp.buf.references, {
          desc = "LSP: [G]oto [R]eferences",
          buffer = bufnr,
          remap = false,
        })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
          desc = "Go to previous diagnostic message",
          remap = false,
        })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
          desc = "Go to next diagnostic message",
          remap = false,
        })
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
          desc = "Open floating diagnostic message",
          remap = false,
        })
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
          desc = "Open diagnostics list",
          remap = false,
        })

        local telescope = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ds", telescope.lsp_document_symbols, {
          desc = "LSP: [D]ocument [S]ymbols",
          buffer = bufnr,
          remap = false,
        })
        vim.keymap.set("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, {
          desc = "LSP: [W]orkspace [S]ymbols",
          buffer = bufnr,
          remap = false,
        })
        vim.keymap.set("n", "<leader>gr", function()
          telescope.lsp_references({ include_declaration = false, show_line = false })
        end, { buffer = bufnr, remap = false, desc = "LSP: [G]oto [R]eferences" })
      end)

      -- Setup LSP servers with the default configuration
      lsp_zero.setup_servers({
        "lua_ls",
        "rust_analyzer",
        "tailwindcss",
        "tsserver",
      })

      -- Setup LSP servers with custom configuration
      lsp_zero.set_server_config({
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

      -- Specific configuration for the tsserver LSP server
      require("lspconfig").tsserver.setup({
        init_options = {
          preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            importModuleSpecifierPreference = "non-relative",
          },
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(bufnr, true)
          end
        end,
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentFormattingRangeProvider = false
        end,
      })

      -- Define icons for LSP diagnostics
      lsp_zero.set_sign_icons({
        error = "✘",
        warn = "▲",
        hint = "⚑",
        info = "»",
      })

      -- LSP Server manager
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "tsserver", "rust_analyzer" },
        handlers = { lsp_zero.default_setup },
      })

      -- Floating windows
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      cmp.setup({
        sources = {
          { name = "path" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({}),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Diagnostic windows
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Visual configuration for hover windows
      vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    end,
  },

  {
    -- Standalone UI for nvim-lsp progress
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  },
}
