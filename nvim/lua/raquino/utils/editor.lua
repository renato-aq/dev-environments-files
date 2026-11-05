local M = {}

-- Nested, so the markers have equal priority and the nearest one wins
local root_markers = { { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" } }
local short_lang = { typescriptreact = "tsx", javascriptreact = "jsx", typescript = "ts", javascript = "js" }

---@return string?
function M.root()
	return vim.fs.root(0, root_markers)
end

function M.close_hidden_buffers()
	for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if #info.windows == 0 and info.changed == 0 then
			vim.api.nvim_buf_delete(info.bufnr, {})
		end
	end
end

---@param opts? { absolute?: boolean }
function M.copy_path(opts)
	local path = vim.fn.expand(opts and opts.absolute and "%:p" or "%:.")
	local text = ("%s#L%d"):format(path, vim.fn.line("."))
	vim.fn.setreg("+", text)
	vim.notify(text)
end

function M.copy_code_block()
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".")
	local filetype = vim.bo.filetype
	local block = {
		('```%s filename="%s" line=%d'):format(
			short_lang[filetype] or filetype,
			vim.fn.expand("%:."),
			math.min(from[2], to[2])
		),
	}
	vim.list_extend(block, vim.fn.getregion(from, to, { type = vim.fn.mode() }))
	table.insert(block, "```")
	vim.fn.setreg("+", table.concat(block, "\n") .. "\n")
	vim.cmd.normal({ args = { vim.keycode("<Esc>") }, bang = true })
end

function M.open_package_json()
	local root = vim.fs.root(0, "package.json")
	if not root then
		vim.notify("No package.json found", vim.log.levels.WARN)
		return
	end

	local width, height = math.floor(vim.o.columns * 0.8), math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(0, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
	})
	vim.cmd.edit(vim.fn.fnameescape(root .. "/package.json"))

	-- The buffer outlives the float, so the closing keys have to go with the float
	local buf = vim.api.nvim_get_current_buf()
	local keys = { "q", "<Esc>" }
	for _, key in ipairs(keys) do
		vim.keymap.set("n", key, "<cmd>close<cr>", { buffer = buf })
	end
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		once = true,
		callback = function()
			for _, key in ipairs(keys) do
				pcall(vim.keymap.del, "n", key, { buffer = buf })
			end
		end,
	})
end

return M
