return {
  -- A file explorer
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup({ default_file_explorer = true })
    vim.keymap.set("n", "-", require("oil").open, {
      desc = "Open parent directory",
    })
  end,
  opts = {},
}
