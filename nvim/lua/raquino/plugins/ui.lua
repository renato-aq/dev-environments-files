require("solarized-osaka").setup({
	style = "vivid",
	transparent = true,
})
vim.cmd.colorscheme("solarized-osaka")

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

Raquino.tabline.setup()

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		refresh = {
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
				"RecordingEnter",
				"RecordingLeave",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			Raquino.lualine.root_name,
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			Raquino.lualine.pretty_path,
		},
		lualine_x = {
			Raquino.lualine.recording,
			{
				"diagnostics",
				symbols = {
					error = Raquino.icons.diagnostics.Error,
					warn = Raquino.icons.diagnostics.Warn,
					info = Raquino.icons.diagnostics.Info,
					hint = Raquino.icons.diagnostics.Hint,
				},
			},
			"diff",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

require("incline").setup({
	window = {
		placement = { horizontal = "right", vertical = "top" },
	},
	hide = {
		cursorline = true,
	},
	render = function(props)
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if name == "" then
			name = "[No Name]"
		end
		local icon, icon_hl = MiniIcons.get("file", name)
		return {
			vim.bo[props.buf].modified and "[+] " or "",
			{ icon .. " ", group = icon_hl },
			name,
		}
	end,
})

require("snacks").setup({
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	scroll = { enabled = false },
	picker = { enabled = true },
	lazygit = {
		theme = {
			activeBorderColor = { fg = "WarningMsg", bold = true },
		},
	},
})

require("tiny-cmdline").setup({
	position = { x = "50%", y = "20%" },
	on_reposition = require("tiny-cmdline").adapters.blink,
})
