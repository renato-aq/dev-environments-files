local M = {}

-- Lower-right and lower-left triangles, so each tab is wider at the bottom
local left_edge, right_edge = "\u{e0ba}", "\u{e0b8}"
local padding = "   "
local max_length, kept_length = 20, 17

---@param text string
---@return string
local function cut_right(text)
	if vim.fn.strchars(text) <= max_length then
		return text
	end
	return vim.fn.strcharpart(text, 0, kept_length) .. "…"
end

---@param text string
---@return string
local function cut_left(text)
	local length = vim.fn.strchars(text)
	if length <= max_length then
		return text
	end
	return "…" .. vim.fn.strcharpart(text, length - kept_length)
end

---@param buf integer
---@return string
local function label(buf)
	if vim.bo[buf].buftype == "terminal" then
		return "[Terminal]"
	end

	if vim.bo[buf].filetype == "oil" then
		local dir = require("oil").get_current_dir(buf)
		if dir then
			return cut_left(vim.fn.fnamemodify(dir, ":~:h"))
		end
	end

	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return "[No Name]"
	end

	local file = vim.fn.fnamemodify(name, ":t")
	return MiniIcons.get("file", file) .. " " .. cut_right(file)
end

function M.render()
	local parts = {}
	local current = vim.api.nvim_get_current_tabpage()
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
		local hl = tab == current and "RaquinoTabActive" or "RaquinoTabInactive"
		table.insert(parts, ("%%#%sEdge#%s%%#%s#"):format(hl, left_edge, hl))
		table.insert(parts, padding)
		if vim.bo[buf].modified then
			table.insert(parts, "[+] ")
		end
		table.insert(parts, (label(buf):gsub("%%", "%%%%")))
		table.insert(parts, padding)
		table.insert(parts, ("%%#%sEdge#%s"):format(hl, right_edge))
	end
	table.insert(parts, "%#TabLineFill#")
	return table.concat(parts)
end

local function set_highlights()
	local colors = require("solarized-osaka.colors").setup()
	vim.api.nvim_set_hl(0, "RaquinoTabActive", { fg = colors.base4, bg = colors.yellow, bold = true })
	vim.api.nvim_set_hl(0, "RaquinoTabActiveEdge", { fg = colors.yellow })
	vim.api.nvim_set_hl(0, "RaquinoTabInactive", { fg = colors.base0, bg = colors.base02 })
	vim.api.nvim_set_hl(0, "RaquinoTabInactiveEdge", { fg = colors.base02 })
	vim.api.nvim_set_hl(0, "TabLineFill", {})
end

function M.setup()
	set_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
	vim.o.showtabline = 1
	vim.o.tabline = "%!v:lua.Raquino.tabline.render()"
end

return M
