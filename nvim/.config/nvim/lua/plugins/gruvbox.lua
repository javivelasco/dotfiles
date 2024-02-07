return {
  -- A port of gruvbox community theme to lua with treesitter support
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme gruvbox")
  end,
}
