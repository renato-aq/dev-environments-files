require("gitsigns").setup()

require("mini.diff").setup({
	view = { overlay_style = "hunk" },
	-- Only the keys in plugins/keymaps.lua
	mappings = {
		apply = "",
		reset = "",
		textobject = "",
		goto_first = "",
		goto_prev = "",
		goto_next = "",
		goto_last = "",
	},
})

require("codediff").setup({
	explorer = {
		view_mode = "tree",
		width = 50,
		auto_open_on_cursor = true,
		line_stats = { enabled = true },
	},
	diff = {
		compact = true,
		compact_context_lines = 8,
		compact_sync_folds = true,
	},
})

require("gitlinker").setup()
