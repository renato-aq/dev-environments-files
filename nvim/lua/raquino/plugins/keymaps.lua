local map = vim.keymap.set

-- Picker
map("n", ";f", function()
	Snacks.picker.files({ hidden = true })
end, { desc = "Find files" })
map("n", ";r", function()
	Snacks.picker.grep({ hidden = true })
end, { desc = "Live grep" })
map("n", ";;", function()
	Snacks.picker.resume()
end, { desc = "Reopen the last picker" })
map("n", "\\\\", function()
	Snacks.picker.buffers({ jump = { reuse_win = true } })
end, { desc = "List buffers" })
map("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "List diagnostics" })
map("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Show notification history" })
map("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "List git hunks" })

-- File explorer
map("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "Open oil" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function(ev)
		map("n", "h", function()
			require("oil.actions").parent.callback()
		end, { buffer = ev.buf, desc = "Go to the parent directory" })
		map("n", "q", function()
			require("oil").close()
		end, { buffer = ev.buf, desc = "Close oil" })
	end,
})

-- LSP. Buffer-local, so buffers without a server keep the built-in keys.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local function lsp_map(mode, lhs, rhs, opts)
			map(mode, lhs, rhs, vim.tbl_extend("force", { buffer = ev.buf }, opts))
		end

		lsp_map("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, { desc = "Go to the definition" })
		lsp_map("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, { desc = "Go to the declaration" })
		lsp_map("n", "gy", function()
			Snacks.picker.lsp_type_definitions()
		end, { desc = "Go to the type definition" })
		-- nowait, or the built-in gr* maps would delay it by timeoutlen
		lsp_map("n", "gr", function()
			Snacks.picker.lsp_references()
		end, { desc = "List references", nowait = true })
		lsp_map("n", "gI", function()
			Raquino.lsp.source_definition()
		end, { desc = "Go to the source definition or implementation" })
		lsp_map("n", ";c", function()
			Snacks.picker.lsp_incoming_calls()
		end, { desc = "List incoming calls" })
		lsp_map("n", "K", vim.lsp.buf.hover, { desc = "Show hover docs" })
		lsp_map("n", "gK", vim.lsp.buf.signature_help, { desc = "Show signature help" })
		lsp_map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help" })
		lsp_map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
		lsp_map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename the symbol" })
		lsp_map("n", "<leader>cR", function()
			Snacks.rename.rename_file()
		end, { desc = "Rename the file" })

		-- Word highlighting needs a language server too
		lsp_map("n", "]]", function()
			Snacks.words.jump(vim.v.count1)
		end, { desc = "Next occurrence" })
		lsp_map("n", "[[", function()
			Snacks.words.jump(-vim.v.count1)
		end, { desc = "Previous occurrence" })
	end,
})
map("n", "<C-j>", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>f", function()
	require("conform").format({ timeout_ms = 1000, lsp_format = "fallback" })
end, { desc = "Format" })
map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", { desc = "Show LSP info" })

-- Signs and blame
map("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Blame the line" })
map("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Blame the buffer" })
map("n", "<leader>go", function()
	Raquino.git.open_line_commit()
end, { desc = "Open the file as of the line's last commit" })
map("n", "<leader>gs", function()
	local gitsigns = require("gitsigns")
	if #(gitsigns.get_hunks(0) or {}) > 0 then
		gitsigns.stage_buffer()
	else
		gitsigns.reset_buffer_index()
	end
end, { desc = "Stage or unstage the buffer" })
map("n", "<leader>gh", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage or unstage the hunk" })

-- Diff overlay
map("n", "<leader>gd", function()
	require("mini.diff").toggle_overlay(0)
end, { desc = "Toggle the diff overlay" })
map("n", "]c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		require("mini.diff").goto_hunk("next")
	end
end, { desc = "Next hunk" })
map("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		require("mini.diff").goto_hunk("prev")
	end
end, { desc = "Previous hunk" })

-- Diff view
map("n", "<leader>dv", function()
	local lifecycle = require("codediff.ui.lifecycle")
	if lifecycle.get_session(vim.api.nvim_get_current_tabpage()) then
		lifecycle.close()
	else
		vim.cmd.CodeDiff()
	end
end, { desc = "Toggle the diff view" })
map("n", "<leader>dh", "<cmd>CodeDiff history %<cr>", { desc = "Show the file history" })
map("n", "<leader>dH", "<cmd>CodeDiff history<cr>", { desc = "Show the repo history" })

-- Lazygit
map("n", ";g", function()
	Raquino.lazygit.open()
end, { desc = "Open lazygit" })

-- Copilot
map("i", "<C-l>", function()
	require("copilot.suggestion").accept()
end, { desc = "Accept the suggestion" })
map("i", "<M-l>", function()
	require("copilot.suggestion").accept_word()
end, { desc = "Accept a word" })
map("i", "<M-L>", function()
	require("copilot.suggestion").accept_line()
end, { desc = "Accept a line" })
map("i", "<M-]>", function()
	require("copilot.suggestion").next()
end, { desc = "Next suggestion" })
map("i", "<M-[>", function()
	require("copilot.suggestion").prev()
end, { desc = "Previous suggestion" })
map("i", "<C-]>", function()
	require("copilot.suggestion").dismiss()
end, { desc = "Dismiss the suggestion" })
