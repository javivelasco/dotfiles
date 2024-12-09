return {
  {
    -- Clone of vim.fugitive written in lua
    "dinhhuy258/git.nvim",
    config = function()
      vim.keymap.set(
        "n",
        "<leader>go",
        "<CMD>lua require('git.browse').open(false)<CR>",
        { desc = "Open [G]it File [O]pen" }
      )
      vim.keymap.set("n", "<leader>gb", "<CMD>lua require('git.blame').blame()<CR>", { desc = "[G]it [B]lame" })
    end,
  },

  {
    -- GitHub extension for fugitive.vim
    "tpope/vim-rhubarb",
  },

  {
    -- Super fast git decorations implemented purely in Lua.
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "-" },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
        vim.keymap.set("n", "[c", require("gitsigns").prev_hunk, { buffer = bufnr, desc = "Go to Previous Hunk" })
        vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Go to Next Hunk" })
        vim.keymap.set(
          "n",
          "<leader>ph",
          require("gitsigns").preview_hunk,
          { buffer = bufnr, desc = "[P]review [H]unk" }
        )
      end,
    },
  },
}
