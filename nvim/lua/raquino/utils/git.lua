local M = {}

---@param args string[]
---@param cwd string
---@return string?
local function git(args, cwd)
	local result = vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
	if result.code ~= 0 then
		vim.notify(vim.trim(result.stderr), vim.log.levels.WARN)
		return nil
	end
	return result.stdout
end

-- Opens the file as of the commit that last touched the current line, in a new tab
function M.open_line_commit()
	local file = vim.api.nvim_buf_get_name(0)
	local root = vim.fs.root(0, ".git")
	if file == "" or not root then
		vim.notify("Not a file in a git repository", vim.log.levels.WARN)
		return
	end

	local lnum = vim.fn.line(".")
	local blame = git({ "blame", "--porcelain", "-L", ("%d,%d"):format(lnum, lnum), "--", file }, root)
	if not blame then
		return
	end
	local sha, orig_lnum = blame:match("^(%x+) (%d+)")
	local path = blame:match("\nfilename ([^\n]+)")
	if sha:match("^0+$") then
		vim.notify("This line is not committed yet", vim.log.levels.WARN)
		return
	end

	local content = git({ "show", sha .. ":" .. path }, root)
	if not content then
		return
	end

	vim.cmd.tabnew()
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content:gsub("\n$", ""), "\n"))
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = false
	pcall(vim.api.nvim_buf_set_name, buf, sha:sub(1, 7) .. ":" .. path)
	vim.bo[buf].filetype = vim.filetype.match({ filename = path, buf = buf }) or ""
	vim.api.nvim_win_set_cursor(0, { tonumber(orig_lnum), 0 })
end

return M
