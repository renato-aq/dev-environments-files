local web = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

-- A plain vite.config.ts says nothing about oxfmt, only a Vite+ one does
local function has_oxfmt_config(dirname)
	local config = vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }, {
		path = dirname,
		upward = true,
	})[1]
	if config then
		return true
	end

	local vite_config = vim.fs.find({ "vite.config.ts", "vite.config.js" }, { path = dirname, upward = true })[1]
	if not vite_config then
		return false
	end
	local file = io.open(vite_config, "r")
	if not file then
		return false
	end
	local content = file:read("*a")
	file:close()
	return content:find("vite-plus", 1, true) ~= nil
end

require("conform").setup({
	formatters_by_ft = {
		javascript = web,
		typescript = web,
		javascriptreact = web,
		typescriptreact = web,
		json = web,
		css = web,
		scss = web,
		less = web,
		html = web,
		htmlangular = web,
		markdown = web,
		mdx = web,
		yaml = web,
		lua = { "stylua" },
		sh = { "shfmt" },
		-- gopls formats but leaves imports alone, goimports fixes them
		go = { "goimports", "gofumpt" },
		fish = { "fish_indent" },
	},
	formatters = {
		oxfmt = {
			condition = function(_, ctx)
				return has_oxfmt_config(ctx.dirname)
			end,
		},
	},
	format_on_save = function(buf)
		if vim.b[buf].disable_autoformat then
			return
		end
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
})
