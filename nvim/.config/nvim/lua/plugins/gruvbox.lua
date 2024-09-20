return {
  -- A port of gruvbox community theme to lua with treesitter support
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  branch = "main",
  commit = "6e4027ae957cddf7b193adfaec4a8f9e03b4555f",
  config = function()
    vim.cmd("colorscheme gruvbox")
  end,
}
