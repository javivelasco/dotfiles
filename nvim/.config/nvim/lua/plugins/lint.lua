-- Filetypes we lint with a JS/TS linter
local js_fts = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  svelte = true,
}

-- Pick oxlint when the project uses it (e.g. vercel/api), otherwise eslint_d
local function js_linters(bufnr)
  local root = vim.fs.root(bufnr, {
    ".oxlintrc.json",
    ".oxlintrc.jsonc",
  })
  if root then
    return { "oxlint" }
  end
  return { "eslint_d" }
end

return {
  -- An asynchronous linter plugin for Neovim
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      markdown = { "vale" },
    }

    local function run_lint()
      local bufnr = vim.api.nvim_get_current_buf()
      local filename = vim.api.nvim_buf_get_name(bufnr)

      -- Vale expects both an installed executable and a real file path. Pi can
      -- open temporary Markdown files, while BufNewFile can have no path yet.
      if
        vim.bo[bufnr].filetype == "markdown"
        and (vim.fn.executable("vale") == 0 or filename == "" or vim.fn.filereadable(filename) == 0)
      then
        return
      end

      if js_fts[vim.bo[bufnr].filetype] then
        lint.try_lint(js_linters(bufnr))
      else
        lint.try_lint()
      end
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = run_lint,
    })

    vim.keymap.set("n", "<leader>l", run_lint, { desc = "Trigger linting for current file" })
  end,
}
