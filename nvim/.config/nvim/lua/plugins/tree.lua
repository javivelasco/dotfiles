return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },

  config = function()
    require("neo-tree").setup({
      window = {
        position = "right",
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>t", ":Neotree toggle<CR>", {
      desc = "Toggle Nvimtree",
      noremap = true,
      silent = true,
    })

    vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
  end,
}
