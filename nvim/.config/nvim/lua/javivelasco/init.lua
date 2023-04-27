-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw at the very start of your init.lua (strongly advised for tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("javivelasco.lazy")
require("javivelasco.set")
require("javivelasco.remap")
