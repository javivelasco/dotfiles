-- When in visual mode this allows to move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the line below down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the line above up" })

-- Move the line below at the end of the current line
vim.keymap.set("n", "J", "mzJ`z", { desc = "Move the line below at the end of the current line" })

-- Keep the cursor in the middle of the screen when jumping up and down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- Allow for search terms to remain the middle of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without yanking the highlighted text
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "[P]aste without yanking" })

-- Yank into the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]ank to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank uppercase to clipboard" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "[D]elete without yanking" })

-- Escape without using the escape key
vim.keymap.set("i", "kj", "<Esc>", { desc = "Escape without using the escape key" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape without using the escape key" })

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Replace every occurence of the word under the cursor
vim.keymap.set(
  "n",
  "<leader>r",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace every occurence of the word under the cursor" }
)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-w>", function() Snacks.bufdelete() end, { desc = "Delete buffer" })

-- Inside Rex, move between nvim splits first and hand over to Rex at the edge,
-- like vim-tmux-navigator does under tmux. Rex leaves these keys to nvim while
-- it is in the foreground (see rex/.config/rex/init.lua).
if vim.env.REX_SESSION and not vim.env.TMUX then
  for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
    vim.keymap.set("n", "<C-" .. key .. ">", function()
      local window = vim.api.nvim_get_current_win()
      vim.cmd.wincmd(key)
      if vim.api.nvim_get_current_win() == window then
        vim.system({ "rex", "focus", direction, "--session", vim.env.REX_SESSION })
      end
    end, { desc = "Navigate " .. direction .. " (nvim, then Rex)" })
  end
end

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up" })
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Make C-i work correctly with Alacritty
vim.keymap.set("n", "<C-n>i", "<C-i>", {})
