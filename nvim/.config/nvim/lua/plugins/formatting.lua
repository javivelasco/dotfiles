-- Pick the right JS/TS formatter per project:
--   1. oxfmt   - if the project has an oxfmt config (e.g. vercel/api)
--   2. biome   - if the project has a biome config
--   3. prettierd - fallback
local function js_formatter(bufnr)
  local conform = require("conform")
  if conform.get_formatter_info("oxfmt", bufnr).available then
    return { "oxfmt" }
  elseif conform.get_formatter_info("biome", bufnr).available then
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
        "<leader>f",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters = {
        biome = {
          require_cwd = true,
        },
        oxfmt = {
          -- Only activate when the project actually uses oxfmt. The builtin
          -- also treats vite.config.* as a root marker, which would wrongly
          -- enable oxfmt in any Vite project - restrict to real oxfmt configs.
          require_cwd = true,
          cwd = function(self, ctx)
            return require("conform.util").root_file({
              ".oxfmtrc.json",
              ".oxfmtrc.jsonc",
              "oxfmt.config.ts",
            })(self, ctx)
          end,
          args = function(self, ctx)
            -- By default oxfmt honors both .gitignore and .prettierignore.
            -- Repos migrating from prettier (e.g. vercel/api) may have a
            -- .prettierignore that ignores everything ("*"), which silently
            -- disables stdin formatting. Match vercel/api's own invocation
            -- (`oxfmt --ignore-path .gitignore`) when a .gitignore exists
            -- at the oxfmt root.
            local cwd = self.cwd(self, ctx)
            local args = { "--stdin-filepath", "$FILENAME" }
            if cwd and vim.uv.fs_stat(cwd .. "/.gitignore") then
              args = { "--ignore-path", ".gitignore", "--stdin-filepath", "$FILENAME" }
            end
            return args
          end,
        },
      },
      formatters_by_ft = {
        css = { "prettierd" },
        html = { "prettierd" },
        javascript = js_formatter,
        javascriptreact = js_formatter,
        json = js_formatter,
        jsonc = js_formatter,
        lua = { "stylua" },
        markdown = { "prettierd" },
        svelte = js_formatter,
        typescript = js_formatter,
        typescriptreact = js_formatter,
        yaml = function(bufnr)
          -- oxfmt also formats yaml in projects that use it (e.g. vercel/api)
          if require("conform").get_formatter_info("oxfmt", bufnr).available then
            return { "oxfmt" }
          end
          return { "prettierd" }
        end,
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 3000,
      },
    },
  },
  -- Note: editorconfig is built into Neovim 0.9+, no plugin needed
}
