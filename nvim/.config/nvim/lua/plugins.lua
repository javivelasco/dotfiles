return {
  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },

  -- Detect tabstop and shiftwidth automatically
  { "tpope/vim-sleuth" },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", lazy = false, opts = {} },

  -- Integrate navigation between tmux and vim
  { "christoomey/vim-tmux-navigator" },

  -- Surround text objects (Lua rewrite of vim-surround)
  -- Same keybindings: ys{motion}{char}, ds{char}, cs{old}{new}, S in visual
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
}
