vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

--tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- 2 spaces for ident width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy the indent from current line when starting a new one

opt.wrap = false

-- seaching settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if mixed case then case-sensiteve

opt.cursorline = true

--turn on termguicolors for tokyonight colorschem to work
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace 
opt.backspace = "indent,eol,start" -- allow backpace on indent, eod of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windowns
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the botton
