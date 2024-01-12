require("nvim-tree").setup({
  view = {
    side = "right",
    width = 50,
  },
})

vim.keymap.set(
  { "n", "v" },
  "<leader>T",
  ":NvimTreeFindFile<CR>",
  { noremap = true, silent = true, desc = "Find current buffer in Nvimtree" }
)

vim.keymap.set(
  { "n", "v" },
  "<leader>t",
  ":NvimTreeToggle<CR>",
  { noremap = true, silent = true, desc = "Toggle Nvimtree" }
)
