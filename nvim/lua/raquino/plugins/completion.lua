local function lsp_icon(ctx)
	return MiniIcons.get("lsp", ctx.kind)
end

require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		-- Signature help has its own LSP keymap
		["<C-k>"] = false,
	},
	completion = {
		accept = { auto_brackets = { enabled = true } },
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		ghost_text = { enabled = false },
		menu = {
			draw = {
				treesitter = { "lsp" },
				components = {
					kind_icon = {
						text = function(ctx)
							return lsp_icon(ctx) .. ctx.icon_gap
						end,
						highlight = function(ctx)
							return select(2, lsp_icon(ctx))
						end,
					},
				},
			},
		},
	},
	cmdline = {
		completion = {
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			list = { selection = { preselect = false } },
		},
	},
})

require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = false },
})
