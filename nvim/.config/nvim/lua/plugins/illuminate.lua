return {
  -- Highlight other uses of the current word
  "RRethy/vim-illuminate",
  config = function()
    local illuminate = require("illuminate")
    illuminate.configure({ filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "alpha", "NvimTree", "neo-tree" } })
    vim.keymap.set("n", "<a-n>", function()
      illuminate.goto_next_reference(true)
    end, { desc = "Next reference" })
    vim.keymap.set("n", "<a-p>", function()
      illuminate.goto_prev_reference(true)
    end, { desc = "Previous reference" })
  end,
}
