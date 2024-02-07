return {
  -- A file explorer
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "-", require("oil").open, {
      desc = "Open parent directory",
    })
  end,
  opts = {},
}
