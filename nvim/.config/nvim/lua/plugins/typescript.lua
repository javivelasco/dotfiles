-- TypeScript LSP setup with two interchangeable servers:
--
--   * tsgo (typescript-go): native Go port of tsserver. Much faster project
--     load, diagnostics and navigation. DEFAULT.
--   * vtsls: wrapper around VSCode's TS extension. Full-featured (rename file,
--     organize imports, move to file, etc). Fallback for heavy refactors.
--
-- Toggle between them with <leader>ts (or :TSServerToggle).

local ts_filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }

local inlay_hints = {
  enumMemberValues = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  parameterNames = { enabled = "all" },
  parameterTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  variableTypes = { enabled = false },
}

return {
  "yioneko/nvim-vtsls", -- provides the refactor commands used when vtsls is active
  ft = ts_filetypes,
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    -- vtsls settings (merged on top of nvim-lspconfig's bundled config)
    vim.lsp.config("vtsls", {
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
          suggest = { completeFunctionCalls = true },
          inlayHints = inlay_hints,
        },
        javascript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = { completeFunctionCalls = true },
          inlayHints = inlay_hints,
        },
      },
    })

    -- tsgo settings (nvim-lspconfig ships the base config; it prefers the
    -- project-local node_modules/.bin/tsgo binary automatically)
    vim.lsp.config("tsgo", {
      settings = {
        typescript = { inlayHints = inlay_hints },
        javascript = { inlayHints = inlay_hints },
      },
    })

    -- tsgo is the default; vtsls only on demand
    vim.lsp.enable("vtsls", false)
    vim.lsp.enable("tsgo")

    local current = "tsgo"
    local function toggle_ts_server()
      local next_server = current == "tsgo" and "vtsls" or "tsgo"
      vim.lsp.enable(current, false) -- stops running clients (nvim 0.11.2+)
      vim.lsp.enable(next_server)
      current = next_server
      -- Re-fire FileType so the new server attaches to already-open TS buffers
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(ts_filetypes, vim.bo[buf].filetype) then
          vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
        end
      end
      vim.notify("TypeScript LSP: " .. next_server, vim.log.levels.INFO)
    end

    vim.api.nvim_create_user_command("TSServerToggle", toggle_ts_server, {
      desc = "Toggle between tsgo (fast) and vtsls (full refactors)",
    })
    vim.keymap.set("n", "<leader>ts", toggle_ts_server, {
      silent = true,
      desc = "Toggle TS server (tsgo ↔ vtsls)",
    })

    -- TypeScript-specific keybindings via nvim-vtsls commands (vtsls only)
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
