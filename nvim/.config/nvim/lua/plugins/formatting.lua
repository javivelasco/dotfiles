function biome_or_prettierd(bufnr)
  if require("conform").get_formatter_info("biome", bufnr).available then
    return { "biome" }
  else
    return { "prettierd" }
  end
end

return {
  {
    -- Lightweight yet powerful formatter plugin for Neovim
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        css = { "prettierd" },
        html = { "prettierd" },
        javascript = biome_or_prettierd,
        javascriptreact = biome_or_prettierd,
        json = biome_or_prettierd,
        -- lua = { "stylua" },
        markdown = { "prettierd" },
        svelte = biome_or_prettierd,
        typescript = biome_or_prettierd,
        typescriptreact = biome_or_prettierd,
        yaml = { "prettierd" },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500 },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    -- Prettier plugin for Neovim's built-in LSP client.
    "MunifTanjim/prettier.nvim",
  },

  {
    -- EditorConfig plugin for Neovim written in Fennel
    "gpanders/editorconfig.nvim",
  },
}
