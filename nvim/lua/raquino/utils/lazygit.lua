local M = {}

local origin_win ---@type integer?

function M.open()
	origin_win = vim.api.nvim_get_current_win()
	Snacks.lazygit()
end

-- Called from lazygit's edit command, through --remote-send
function M.focus_origin()
	if origin_win and vim.api.nvim_win_is_valid(origin_win) then
		vim.api.nvim_set_current_win(origin_win)
	end
end

return M
