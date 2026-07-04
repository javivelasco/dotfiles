return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  config = function()
    -- configure autopairs
    -- (completion parens are handled by blink.cmp's accept.auto_brackets)
    require("nvim-autopairs").setup({
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" }, -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        java = false, -- don't check treesitter on java
      },
    })
  end,
}
