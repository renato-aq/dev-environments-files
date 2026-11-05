local M = {}

-- The project root name, only when it differs from cwd
function M.root_name()
	local root = Raquino.editor.root()
	if not root or vim.fs.normalize(root) == vim.fs.normalize(vim.uv.cwd() or "") then
		return ""
	end
	return vim.fs.basename(root)
end

-- The path relative to cwd, with the middle folders dropped when it gets long
function M.pretty_path()
	local name = vim.api.nvim_buf_get_name(0):gsub("^oil://", "")
	if name == "" then
		return ""
	end

	local path = vim.fs.normalize(name)
	path = vim.fs.relpath(vim.uv.cwd() or "", path) or vim.fn.fnamemodify(path, ":~")
	local parts = vim.split(path, "/", { trimempty = true })
	if #parts > 3 then
		path = table.concat({ parts[1], "…", parts[#parts - 1], parts[#parts] }, "/")
	end
	return path
end

function M.recording()
	local register = vim.fn.reg_recording()
	return register ~= "" and "recording @" .. register or ""
end

return M
