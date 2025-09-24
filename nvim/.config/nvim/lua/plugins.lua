return {
  -- Sensible defaults
  { "tpope/vim-sensible" },

  -- Manage surround text objects
  { "tpope/vim-surround" },

  -- Repeat plugin commands with the dot command
  { "tpope/vim-repeat" },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },

  -- Detect tabstop and shiftwidth automatically
  { "tpope/vim-sleuth" },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", lazy = false, opts = {} },

  -- Integrate navigation between tmux and vim
  { "christoomey/vim-tmux-navigator" },

  -- Allows to have a buffer delete that doesn't close the window
  { "famiu/bufdelete.nvim" },
}
