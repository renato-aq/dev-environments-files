local function gh(repo)
	return "https://github.com/" .. repo
end

-- Has to exist before vim.pack.add, which is what fires it
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd.TSUpdate()
		end
	end,
})

vim.pack.add({
	-- UI
	gh("craftzdog/solarized-osaka.nvim"),
	gh("nvim-mini/mini.icons"),
	gh("nvim-lualine/lualine.nvim"),
	gh("b0o/incline.nvim"),
	gh("folke/snacks.nvim"),
	gh("rachartier/tiny-cmdline.nvim"),
	-- Navigation
	gh("stevearc/oil.nvim"),
	gh("christoomey/vim-tmux-navigator"),
	-- Syntax
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
	gh("nvim-lua/plenary.nvim"),
	gh("folke/todo-comments.nvim"),
	gh("brenoprata10/nvim-highlight-colors"),
	-- Completion
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
	gh("nvim-mini/mini.pairs"),
	-- LSP
	gh("mason-org/mason.nvim"),
	gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
	gh("neovim/nvim-lspconfig"),
	-- Formatting
	gh("stevearc/conform.nvim"),
	-- Git
	gh("lewis6991/gitsigns.nvim"),
	{ src = gh("craftzdog/mini.diff"), version = "feat/grouping" },
	gh("MunifTanjim/nui.nvim"),
	gh("esmuellert/codediff.nvim"),
	gh("linrongbin16/gitlinker.nvim"),
	-- AI
	gh("zbirenbaum/copilot.lua"),
})

require("raquino.plugins.ui")
require("raquino.plugins.navigation")
require("raquino.plugins.syntax")
require("raquino.plugins.completion")
require("raquino.plugins.lsp")
require("raquino.plugins.formatting")
require("raquino.plugins.git")
require("raquino.plugins.ai")
require("raquino.plugins.keymaps")
