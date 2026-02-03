return {
  -- vtsls: LSP wrapper around VSCode's TypeScript extension
  -- Actively maintained and used as LazyVim's default
  "yioneko/nvim-vtsls",
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    -- Disable any auto-start of vtsls before we configure it
    vim.lsp.enable("vtsls", false)

    -- Register vtsls with lspconfig (required before setup)
    require("lspconfig.configs").vtsls = require("vtsls").lspconfig

    -- Configure vtsls through lspconfig
    require("lspconfig").vtsls.setup({
      filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      single_file_support = true,
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            maxInlayHintLength = 30,
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "all" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
        javascript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "all" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    })

    -- TypeScript-specific keybindings via nvim-vtsls commands
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("VtslsKeymaps", { clear = true }),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client or client.name ~= "vtsls" then
          return
        end

        local opts = { buffer = ev.buf, silent = true }
        local vtsls = require("vtsls")

        opts.desc = "Organize Imports"
        vim.keymap.set("n", "<leader>oi", function()
          vtsls.commands.organize_imports(ev.buf)
        end, opts)

        opts.desc = "Sort Imports"
        vim.keymap.set("n", "<leader>si", function()
          vtsls.commands.sort_imports(ev.buf)
        end, opts)

        opts.desc = "Remove Unused Imports"
        vim.keymap.set("n", "<leader>ru", function()
          vtsls.commands.remove_unused_imports(ev.buf)
        end, opts)

        opts.desc = "Add Missing Imports"
        vim.keymap.set("n", "<leader>am", function()
          vtsls.commands.add_missing_imports(ev.buf)
        end, opts)

        opts.desc = "Fix All"
        vim.keymap.set("n", "<leader>fa", function()
          vtsls.commands.fix_all(ev.buf)
        end, opts)

        opts.desc = "Go to Source Definition"
        vim.keymap.set("n", "gS", function()
          vtsls.commands.goto_source_definition(ev.buf)
        end, opts)

        opts.desc = "Rename File and Update Imports"
        vim.keymap.set("n", "<leader>rf", function()
          vtsls.commands.rename_file(ev.buf)
        end, opts)

        opts.desc = "Select TypeScript Version"
        vim.keymap.set("n", "<leader>tv", function()
          vtsls.commands.select_ts_version(ev.buf)
        end, opts)
      end,
    })
  end,
}
