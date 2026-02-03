return {
  {
    -- Use telescope to select things like Code Actions
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      local lga_actions = require("telescope-live-grep-args.actions")
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },

          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-h>"] = lga_actions.quote_prompt({ postfix = " --hidden" }),
                ["<C-space>"] = lga_actions.to_fuzzy_refine,
              },
            },
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },

  {
    -- FZF native implementation for telescope
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },

  {
    -- File browser extension for telescope
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
  },

  {
    -- It enables passing arguments to the grep command
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
  },

  {
    -- Find, Filter, Preview, Pick. All lua, all the time.
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")
      local extensions = require("telescope").extensions

      local function telescope_buffer_dir()
        return vim.fn.expand("%:p:h")
      end

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-c>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                ["<C-w>"] = function()
                  vim.cmd("normal vbd")
                end,
              },
              ["n"] = {
                ["N"] = extensions.file_browser.actions.create,
                ["D"] = extensions.file_browser.actions.remove,
              },
            },
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")

      vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
      vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Search [G]it [F]iles" })

      vim.keymap.set("n", "<leader>ps", function()
        extensions.live_grep_args.live_grep_args()
      end, { desc = "[P]roject [S]earch Live Grep" })

      vim.keymap.set("n", "<leader>pS", function()
        require("telescope.builtin").resume()
      end, { desc = "[P]roject Resume [S]earch Live Grep" })

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown({ previewer = false, winblend = 10 }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>b", function()
        extensions.file_browser.file_browser({
          path = "%:p:h",
          cwd = telescope_buffer_dir(),
          respect_git_ignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 40 },
        })
      end, { desc = "[B]rowse [F]iles" })
    end,
  },
}
