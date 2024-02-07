return {
  -- The undo history visualizer for VIM
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, {
      desc = "Toggle UndoTree",
    })
  end,
}
