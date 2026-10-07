-- Run from the dotfiles root: nvim --headless '+luafile scripts/check-nvim.lua'
-- Uses the installed Neovim config, plugins and Mason tools.

local root = vim.fn.tempname()
local function check()
  -- Headless Neovim has no UIEnter; exercise Snacks' normal UI setup too.
  vim.api.nvim_exec_autocmds("UIEnter", {})
  -- Simulate a project still using TypeScript 6: the native LSP must skip it.
  vim.fn.mkdir(root .. "/node_modules/.bin", "p")
  vim.fn.writefile({ "#!/bin/sh", 'echo "Version 6.0.3"' }, root .. "/node_modules/.bin/tsc")
  vim.fn.setfperm(root .. "/node_modules/.bin/tsc", "rwx------")
  vim.fn.writefile({ "{}" }, root .. "/package-lock.json")
  vim.fn.writefile({ '{"compilerOptions":{"strict":true},"include":["*.ts"]}' }, root .. "/tsconfig.json")
  vim.fn.writefile({ "const message: string = 123;", "console.log(message);" }, root .. "/test.ts")
  vim.cmd.cd(root)
  vim.cmd.edit(root .. "/test.ts")
  local buf = vim.api.nvim_get_current_buf()
  -- This check targets LSP; don't run project linters on the temporary fixture.
  vim.api.nvim_clear_autocmds({ group = "lint" })

  local function attached(name)
    return vim.wait(15000, function()
      local clients = vim.lsp.get_clients({ bufnr = buf, name = name })
      return #clients == 1 and clients[1].initialized
    end, 50)
  end

  assert(attached("tsc"), "native TypeScript LSP did not attach")
  assert(not vim.lsp.is_enabled("tsgo"), "deprecated tsgo config enabled")
  assert(not vim.lsp.is_enabled("vtsls"), "fallback enabled alongside tsc")
  for _, name in ipairs({ "oxlint", "oxfmt", "stylua", "eslint", "ts_ls" }) do
    assert(not vim.lsp.is_enabled(name), "unexpected duplicate LSP: " .. name)
  end
  local client = vim.lsp.get_clients({ bufnr = buf, name = "tsc" })[1]
  assert(client.config.settings["js/ts"].inlayHints.variableTypes.enabled == false)
  assert(
    vim.wait(15000, function()
      for _, diagnostic in ipairs(vim.diagnostic.get(buf)) do
        if tostring(diagnostic.code) == "2322" then
          return true
        end
      end
      return false
    end, 50),
    "missing TypeScript type-error diagnostic"
  )
  local hover = client:request_sync("textDocument/hover", {
    textDocument = { uri = vim.uri_from_bufnr(buf) },
    position = { line = 0, character = 7 },
  }, 5000, buf)
  assert(hover and hover.result and hover.result.contents, "TypeScript hover failed")
  assert(vim.fn.maparg("<leader>rs", "n"):find("lsp restart", 1, true), "legacy restart mapping")
  vim.cmd("lsp restart")
  assert(
    vim.wait(15000, function()
      local clients = vim.lsp.get_clients({ bufnr = buf, name = "tsc" })
      return #clients == 1 and clients[1].initialized and clients[1].id ~= client.id
    end, 50),
    "native LSP restart failed"
  )

  vim.cmd.TSServerToggle()
  assert(attached("vtsls"), "vtsls fallback did not attach")
  assert(not vim.lsp.is_enabled("tsc"), "tsc still enabled after toggle")
  vim.cmd.TSServerToggle()
  assert(attached("tsc"), "native LSP did not reattach")
  assert(not vim.lsp.is_enabled("vtsls"), "vtsls still enabled after toggle")
  assert(
    vim.wait(5000, function()
      return #vim.lsp.get_clients({ bufnr = buf, name = "vtsls" }) == 0
    end, 50),
    "fallback client still attached"
  )

  require("lazy").load({ plugins = { "conform.nvim" } })
  local conform = require("lazy.core.config").plugins["conform.nvim"]
  assert(conform.opts.format_on_save.lsp_format == "fallback")
  assert(require("lazy.core.config").plugins["nvim-tree.lua"] == nil, "unused file tree still installed by config")
  assert(vim.ui.select == Snacks.picker.select, "picker selection overridden")
end

local ok, err = xpcall(check, debug.traceback)
for _, client in ipairs(vim.lsp.get_clients()) do
  client:stop(true)
end
vim.cmd.cd(vim.fn.expand("~"))
vim.fn.delete(root, "rf")
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
end
print("PASS: native TypeScript diagnostics/hover/restart, server toggle, and migrated config")
vim.cmd.qa({ bang = true })
