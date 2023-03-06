-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
require("nvim-tree").setup()

vim.keymap.set({ "n", "v" }, "<leader>t", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>T", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
