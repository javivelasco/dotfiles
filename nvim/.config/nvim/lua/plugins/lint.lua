return {
  -- An asynchronous linter plugin for Neovim
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      markdown = { "vale" },
      svelte = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    -- This is a dirty hack so when eslint is not in the project
    -- we don't get an annoying error at the top of the file.
    local eslint = require("lint.linters.eslint")
    local parser = eslint.parser
    eslint.parser = function(output, bufnr)
      local lint_res = parser(output, bufnr)
      if #lint_res == 1 and string.match(lint_res[1].message, "^Could not parse linter output") then
        return {}
      end
      return parser(output, bufnr)
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint(nil, { ignore_errors = true })
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint(nil, { ignore_errors = true })
    end, { desc = "Trigger linting for current file" })
  end,
}
