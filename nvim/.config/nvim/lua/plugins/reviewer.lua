return {
  "dglsparsons/neo-reviewer",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local nr = require("neo_reviewer")

    nr.setup({
      input_window = {
        keys = {
          submit = "<C-y>", -- default <C-s> conflicts with tmux prefix
        },
      },
    })

    local opts = { silent = true, noremap = true }
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    -- Navigation
    map("n", "<leader>Rn", nr.next_change, "Next change")
    map("n", "<leader>Rp", nr.prev_change, "Prev change")
    map("n", "<leader>Rj", nr.next_comment, "Next comment")
    map("n", "<leader>Rk", nr.prev_comment, "Prev comment")

    -- Interaction
    map("n", "<leader>Rc", nr.add_comment, "Add comment")
    map("v", "<leader>Rc", ":AddComment<CR>", "Add comment on selection")
    map("n", "<leader>Rv", nr.show_comment, "View comment thread")
    map("n", "<leader>Ro", nr.toggle_prev_code, "Toggle old code")
    map("n", "<leader>Rf", nr.show_file_picker, "File picker")

    -- AI
    map("n", "<leader>Ri", nr.toggle_ai_feedback, "Toggle AI summary")
    map("n", "<leader>Rq", nr.ask, "Ask AI about code")

    -- Review actions
    map("n", "<leader>Ra", nr.approve, "Approve PR")
    map("n", "<leader>Rx", nr.request_changes, "Request changes")
    map("n", "<leader>Rd", nr.done, "Close review")
    map("n", "<leader>Rs", nr.sync, "Sync review")
  end,
}
