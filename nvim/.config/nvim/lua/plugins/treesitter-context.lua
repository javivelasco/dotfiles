return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    max_lines = 3, -- How many lines of context to show
    multiline_threshold = 1, -- Maximum number of lines to show for a single context
  },
}
