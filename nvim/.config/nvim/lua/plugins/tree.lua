return {
  -- A file explorer tree for neovim written in lua
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      view = {
        side = "right",
        width = 50,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>T", ":NvimTreeFindFile<CR>", {
      desc = "Find current buffer in Nvimtree",
      noremap = true,
      silent = true,
    })

    vim.keymap.set({ "n", "v" }, "<leader>t", ":NvimTreeToggle<CR>", {
      desc = "Toggle Nvimtree",
      noremap = true,
      silent = true,
    })
  end,
}
