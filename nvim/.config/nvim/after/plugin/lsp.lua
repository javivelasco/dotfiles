local lsp = require("lsp-zero")

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
	["<CR>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

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

local function ndmap(key, cmd, desc)
	vim.keymap.set("n", key, cmd, { remap = false, desc = desc })
end

ndmap("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic message")
ndmap("]d", vim.diagnostic.goto_next, "Go to next diagnostic message")
ndmap("<leader>e", vim.diagnostic.open_float, "Open floating diagnostic message")
ndmap("<leader>q", vim.diagnostic.setloclist, "Open diagnostics list")

lsp.on_attach(function(client, bufnr)
	local builtin = require("telescope.builtin")
	local function telescope_lsp_references()
		builtin.lsp_references({ include_declaration = false, show_line = false })
	end

	local function nmap(key, cmd, desc)
		vim.keymap.set("n", key, cmd, { buffer = bufnr, remap = false, desc = desc })
	end

	nmap("<leader>D", vim.lsp.buf.type_definition, "LSP: Type [D]efinition")
	nmap("<leader>rn", vim.lsp.buf.rename, "LSP: [R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "LSP: [C]ode [A]ction")
	nmap("<leader>f", vim.lsp.buf.format, "LSP: [F]ormat current buffer")
	nmap("<leader>K", vim.lsp.buf.signature_help, "LSP: Signature Documentation")
	nmap("K", vim.lsp.buf.hover, "LSP: Hover Documentation")
	nmap("gd", vim.lsp.buf.definition, "LSP: [G]oto [D]efinition")
	nmap("gI", vim.lsp.buf.implementation, "LSP: [G]oto [I]mplementation")
	nmap("gR", vim.lsp.buf.references, "LSP: [G]oto [R]eferences")
	nmap("<leader>ds", builtin.lsp_document_symbols, "LSP: [D]ocument [S]ymbols")
	nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "LSP: [W]orkspace [S]ymbols")
	nmap("<leader>gr", telescope_lsp_references, "LSP: [G]oto [R]eferences")

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "LSP: Format current buffer" })

	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- Disable semantic tokens, it ruins the colorscheme
	client.server_capabilities.semanticTokensProvider = nil
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})
