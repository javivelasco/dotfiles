local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")
local extensions = require('telescope').extensions

local function telescope_buffer_dir()
    return vim.fn.expand('%:p:h')
end

telescope.setup {
    defaults = {
        mappings = {
            n = {
                ["q"] = actions.close
            },
        },
    },
    extensions = {
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        },
        file_browser = {
            theme = "dropdown",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
                -- your custom insert mode mappings
                ["i"] = {
                    ["<C-w>"] = function() vim.cmd('normal vbd') end,
                },
                ["n"] = {
                    ["N"] = extensions.file_browser.actions.create,
                    ["D"] = extensions.file_browser.actions.remove,
                },
            },
        },
    },
}

telescope.load_extension('fzf')
telescope.load_extension("file_browser")

vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files({ no_ignore = false, hidden = true })
end)

vim.keymap.set('n', '<C-p>', function()
    builtin.git_files()
end)

vim.keymap.set('n', '<leader>pb', function()
    builtin.buffers()
end)

vim.keymap.set('n', '<leader>ps', function()
    extensions.live_grep_args.live_grep_args()
end)

vim.keymap.set('n', 'sf', function()
    extensions.file_browser.file_browser({
        path = "%:p:h",
        cwd = telescope_buffer_dir(),
        respect_git_ignore = false,
        hidden = true,
        grouped = true,
        previewer = false,
        initial_mode = "normal",
        layout_config = { height = 40 }
    })
end)
