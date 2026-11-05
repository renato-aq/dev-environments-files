require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
		-- Only the keys in plugins/keymaps.lua
		keymap = {
			accept = false,
			accept_word = false,
			accept_line = false,
			next = false,
			prev = false,
			dismiss = false,
		},
	},
	filetypes = {
		markdown = true,
		help = true,
	},
	-- The one Mason installs, found through the PATH Mason sets up
	server = {
		type = "binary",
		custom_server_filepath = "copilot-language-server",
	},
})
