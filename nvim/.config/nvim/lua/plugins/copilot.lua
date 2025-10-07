return {
  "github/copilot.vim",
  -- This is because I need node < 22 in some Vercel projects
  commit = "dfe0a3a1c256167d181488a73ec6ccab8d8931a9",
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
  end,
}
