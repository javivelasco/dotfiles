-- Color Scheme
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- Set listchars
vim.opt.list = true
vim.opt.listchars:append({ eol = '↵' })
vim.opt.listchars:append({ nbsp = "·" })
vim.opt.listchars:append({ trail = "·" })

-- Fat cursor for edit mode
vim.opt.guicursor = ""

-- Relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Wrap lines to screen width
vim.opt.wrap = true

-- Disable swap files and backup
vim.opt.swapfile = false
vim.opt.backup = false

-- Use a file for undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Enable incremental search highlights
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Enable true colors
vim.opt.termguicolors = true

-- Better scrolling
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

-- Disable GitBlame by default
vim.g.gitblame_enabled = 0
