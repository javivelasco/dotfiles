local lsp = require("lsp-zero").preset({})

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"rust_analyzer",
})

-- Fix Undefined global 'vim'
lsp.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-l>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
})

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP keymaps
lsp.on_attach(function(client, bufnr)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "LSP: Type [D]efinition" })
	vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "LSP: Format current buffer" })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: [R]e[n]ame" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: [C]ode [A]ction" })
	vim.keymap.set(
		"n",
		"<leader>K",
		vim.lsp.buf.signature_help,
		{ buffer = bufnr, desc = "LSP: Signature Documentation" }
	)
	vim.keymap.set(
		"n",
		"<leader>ds",
		require("telescope.builtin").lsp_document_symbols,
		{ buffer = bufnr, desc = "LSP: [D]ocument [S]ymbols" }
	)
	vim.keymap.set(
		"n",
		"<leader>ws",
		require("telescope.builtin").lsp_dynamic_workspace_symbols,
		{ buffer = bufnr, desc = "LSP: [W]orkspace [S]ymbols" }
	)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover Documentation" })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: [G]oto [D]efinition" })
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: [G]oto [I]mplementation" })
	vim.keymap.set("n", "gR", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: [G]oto [R]eferences" })
	vim.keymap.set("n", "gr", function()
		require("telescope.builtin").lsp_references({ include_declaration = false, show_line = false })
	end, { buffer = bufnr, desc = "[G]oto [R]eferences" })

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "LSP: Format current buffer" })

	-- Disable semantic tokens, it ruins the colorscheme
	client.server_capabilities.semanticTokensProvider = nil

	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})
