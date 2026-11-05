require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		-- Servers
		"lua-language-server",
		"vtsls",
		"eslint-lsp",
		"oxlint",
		"tailwindcss-language-server",
		"css-lsp",
		"rust-analyzer",
		"copilot-language-server",
		-- Formatters
		"prettier",
		"prettierd",
		"oxfmt",
		"stylua",
		"shfmt",
	},
	auto_update = false,
	run_on_start = true,
})

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities({
		workspace = {
			fileOperations = { didRename = true, willRename = true },
		},
	}),
})

vim.lsp.enable({ "eslint", "oxlint", "lua_ls", "cssls", "vtsls", "tailwindcss", "rust_analyzer" })

local icons = Raquino.icons.diagnostics
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = { prefix = "●", source = "if_many" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.Error,
			[vim.diagnostic.severity.WARN] = icons.Warn,
			[vim.diagnostic.severity.INFO] = icons.Info,
			[vim.diagnostic.severity.HINT] = icons.Hint,
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		-- nvim-highlight-colors paints the colors, so they aren't painted twice
		vim.lsp.document_color.enable(false, { bufnr = ev.buf })

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
	end,
})
