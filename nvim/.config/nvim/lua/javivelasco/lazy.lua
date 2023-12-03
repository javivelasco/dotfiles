local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Install package manager
--    https://github.com/folke/lazy.nvim
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    -- A port of gruvbox community theme to lua with treesitter support
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
			vim.cmd("colorscheme gruvbox-material")
		end,
  },

	-- Sensible defaults
	{ "tpope/vim-sensible" },

	{
		-- Configure LSP
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{
				-- Optional
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" }, -- Required
      { "onsails/lspkind.nvim" },
		},
	},

	-- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
	{ "jose-elias-alvarez/null-ls.nvim" },

	-- Additional lua configuration, makes nvim stuff amazing!
	{ "folke/neodev.nvim" },

	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- Git related plugins
	"dinhhuy258/git.nvim",
	"tpope/vim-rhubarb",

	{
		-- Super fast git decorations implemented purely in lua/teal.
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "-" },
				untracked = { text = "┆" },
			},
			on_attach = function(bufnr)
				vim.keymap.set(
					"n",
					"[c",
					require("gitsigns").prev_hunk,
					{ buffer = bufnr, desc = "Go to Previous Hunk" }
				)
				vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Go to Next Hunk" })
				vim.keymap.set(
					"n",
					"<leader>ph",
					require("gitsigns").preview_hunk,
					{ buffer = bufnr, desc = "[P]review [H]unk" }
				)
			end,
		},
	},

	{
		-- A blazing fast and easy to configure Neovim statusline written in Lua.
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				icons_enabled = true,
				theme = "gruvbox",
				component_separators = "|",
				section_separators = "",
			},
		},
	},

	{
		-- A snazzy 💅 buffer line (with tabpage integration) for Neovim built using lua
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},

	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
    main = "ibl",
		opts = {
      indent = { char = "┊" },
      whitespace = {
        remove_blankline_trail = false,
    },
		},
	},

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" }, opts = {} },

	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},

	{
		-- A file browser extension for telescope.nvim
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		-- Live grep args picker for telescope.nvim
		"nvim-telescope/telescope-live-grep-args.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},

	{
		-- A File Explorer For Neovim Written In Lua
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
	},

	-- View treesitter information directly in Neovim
	{ "nvim-treesitter/playground" },

	{
		-- Insert or delete brackets, parens, quotes in pair.
		"windwp/nvim-autopairs",
		opts = {
			disable_filetype = { "TelescopePrompt" },
		},
	},

	{
		-- Github Copilot
		"github/copilot.vim",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		end,
	},

	-- Prettier integration
	{ "MunifTanjim/prettier.nvim" },

	-- Consider Editorconfig in projects
	{ "gpanders/editorconfig.nvim" },

	-- Integrate navigation between tmux and vim
	{ "christoomey/vim-tmux-navigator" },

	-- The undo visualization plugin for Neovim
	{ "mbbill/undotree" },

	{
		-- Standalone UI for nvim-lsp progress
		"j-hui/fidget.nvim",
    tag = "legacy",
		config = function()
			require("fidget").setup()
		end,
	},

	-- Highlight other uses of the current word
	{ "RRethy/vim-illuminate" },

	{
		-- Use treesitter to autoclose and autorename html tag
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({})
		end,
	},

	{
		-- A file explorer
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
			vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
		end,
		opts = {},
	},

  {
    -- Allows to have a buffer delete that doesn't close the window
    -- so the layout is preserved
    'famiu/bufdelete.nvim',
  }
}, {})
