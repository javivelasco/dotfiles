return {
  -- A port of gruvbox community theme to lua with treesitter support
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  branch = "main",
  config = function()
    require("gruvbox").setup({
      overrides = {
        -- Blue folders in neo-tree instead of gruvbox's green-bold Directory
        -- (upstream d7a1674 made them green to match oil.nvim)
        NeoTreeDirectoryIcon = { link = "GruvboxBlue" },
        NeoTreeDirectoryName = { link = "GruvboxBlueBold" },
      },
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
