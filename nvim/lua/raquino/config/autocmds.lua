local group = vim.api.nvim_create_augroup("raquino", {})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Only the active window shows the cursorline. Windows that never had one stay that way.
vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
})
vim.api.nvim_create_autocmd("WinEnter", {
	group = group,
	callback = function()
		if vim.w.auto_cursorline then
			vim.w.auto_cursorline = nil
			vim.wo.cursorline = true
		end
	end,
})
