vim.keymap.set("n", "<leader>go", "<CMD>lua require('git.browse').open(false)<CR>", { desc = "Open [G]it File [O]pen" })
vim.keymap.set("n", "<leader>gb", "<CMD>lua require('git.blame').blame()<CR>", { desc = "[G]it [B]lame" })
