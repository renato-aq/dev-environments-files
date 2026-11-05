return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			hint = {
				enable = true,
				paramType = true,
			},
			diagnostics = {
				globals = { "Raquino", "Snacks", "MiniIcons" },
				disable = { "incomplete-signature-doc", "trailing-space", "missing-fields" },
			},
		},
	},
}
