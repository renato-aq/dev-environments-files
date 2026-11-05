vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Leader and basics
opt.mouse = ""
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.iskeyword:append("-")

-- Look of the buffer
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.cmdheight = 0
opt.laststatus = 3
opt.winborder = "rounded"
opt.pumheight = 10
opt.pumblend = 10
opt.showmatch = true
opt.matchtime = 2
opt.title = true
opt.fillchars:append({ diff = "╱" })

-- Search and files
opt.ignorecase = true
opt.smartcase = true
opt.path:append("**")
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Undo
local undodir = vim.fn.stdpath("cache") .. "/undodir"
vim.fn.mkdir(undodir, "p")
opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.undodir = undodir

-- Timing
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0

-- Splits and folds
opt.splitbelow = true
opt.splitright = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

-- Messages
require("vim._core.ui2").enable({
	msg = {
		target = "msg",
		targets = {
			-- Long output
			emsg = "pager",
			echoerr = "pager",
			lua_error = "pager",
			rpc_error = "pager",
			list_cmd = "pager",
			verbose = "pager",
			shell_cmd = "pager",
			shell_out = "pager",
			shell_err = "pager",
			shell_ret = "pager",
			progress = "pager",
			-- Stay in the command line
			search_count = "cmd",
			search_cmd = "cmd",
			completion = "cmd",
			wildlist = "cmd",
			confirm = "cmd",
			-- Triggers win over kinds, so typed commands always answer in the command line
			typed_cmd = "cmd",
		},
		msg = { height = 0.3, timeout = 5000 },
		pager = { height = 0.5 },
	},
})
