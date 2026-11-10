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
		-- Like <C-w>gf, the file under the cursor in a new tab
		lsp_map("n", "<C-w>gd", function()
			Snacks.picker.lsp_definitions({ confirm = "tab" })
		end, { desc = "Open the definition in a new tab" })
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
map("n", "]d", function()
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

-- Debugging. F-keys like Visual Studio and Rider. Not under <leader>d, which is the black hole delete.
local function dap(method, ...)
	local args = { ... }
	return function()
		require("dap")[method](unpack(args))
	end
end
map("n", "<F5>", dap("continue"), { desc = "Start or continue debugging" })
map("n", "<S-F5>", dap("terminate"), { desc = "Stop debugging" })
map("n", "<F17>", dap("terminate"), { desc = "Stop debugging" }) -- <S-F5> in some terminals
map("n", "<F9>", dap("toggle_breakpoint"), { desc = "Toggle a breakpoint" })
map("n", "<F10>", dap("step_over"), { desc = "Step over" })
map("n", "<F11>", dap("step_into"), { desc = "Step into" })
map("n", "<S-F11>", dap("step_out"), { desc = "Step out" })
map("n", "<F23>", dap("step_out"), { desc = "Step out" }) -- <S-F11> in some terminals
map("n", "<leader>Db", dap("toggle_breakpoint"), { desc = "Toggle a breakpoint" })
map("n", "<leader>DB", function()
	require("dap").set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Set a conditional breakpoint" })
map("n", "<leader>DL", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, { desc = "Set a logpoint" })
map("n", "<leader>Dx", dap("clear_breakpoints"), { desc = "Clear all breakpoints" })
map("n", "<leader>Dc", dap("continue"), { desc = "Start or continue debugging" })
map("n", "<leader>DC", dap("run_to_cursor"), { desc = "Run to the cursor" })
map("n", "<leader>Dl", dap("run_last"), { desc = "Rerun the last session" })
map("n", "<leader>Dn", dap("step_over"), { desc = "Step over" })
map("n", "<leader>Di", dap("step_into"), { desc = "Step into" })
map("n", "<leader>Do", dap("step_out"), { desc = "Step out" })
map("n", "<leader>Dk", dap("up"), { desc = "Go up the stack" })
map("n", "<leader>Dj", dap("down"), { desc = "Go down the stack" })
map("n", "<leader>Dq", dap("terminate"), { desc = "Stop debugging" })
map("n", "<leader>Dr", function()
	require("dap").repl.toggle()
end, { desc = "Toggle the REPL" })
map("n", "<leader>Du", function()
	require("dapui").toggle()
end, { desc = "Toggle the debug UI" })
map({ "n", "v" }, "<leader>De", function()
	require("dapui").eval()
end, { desc = "Evaluate the expression" })

-- .NET. Test keys inside test files (<leader>tr, ta, td, tp) are set by easy-dotnet in plugins/dotnet.lua.
local function dotnet(method)
	return function()
		require("easy-dotnet")[method]()
	end
end
map("n", "<leader>nr", dotnet("run_default"), { desc = "Run the default project" })
map("n", "<leader>nR", dotnet("run_profile"), { desc = "Run a project with a launch profile" })
map("n", "<leader>nw", dotnet("watch_default"), { desc = "Watch the default project" })
map("n", "<leader>nd", dotnet("debug_default"), { desc = "Debug the default project" })
map("n", "<leader>nD", dotnet("debug_profile"), { desc = "Debug a project with a launch profile" })
map("n", "<leader>na", dotnet("debug_attach"), { desc = "Attach the debugger to a process" })
map("n", "<leader>nx", dotnet("stop"), { desc = "Stop running projects" })
map("n", "<leader>nb", dotnet("build_default_quickfix"), { desc = "Build the default project" })
map("n", "<leader>nB", dotnet("build_solution_quickfix"), { desc = "Build the solution" })
map("n", "<leader>nc", dotnet("clean"), { desc = "Clean" })
map("n", "<leader>ne", dotnet("diagnostic_errors"), { desc = "List errors in the solution" })
map("n", "<leader>nE", dotnet("diagnostic_warnings"), { desc = "List errors and warnings in the solution" })
map("n", "<leader>nn", dotnet("new"), { desc = "New from a template" })
map("n", "<leader>np", dotnet("add_package"), { desc = "Add a NuGet package" })
map("n", "<leader>nP", dotnet("remove_package"), { desc = "Remove a NuGet package" })
map("n", "<leader>no", dotnet("outdated"), { desc = "Show outdated packages" })
map("n", "<leader>ns", dotnet("secrets"), { desc = "Edit user secrets" })
map("n", "<leader>nm", dotnet("terminal_toggle"), { desc = "Toggle the .NET terminal" })
map("n", "<leader>tt", dotnet("testrunner"), { desc = "Toggle the test runner" })
map("n", "<leader>tT", dotnet("test_solution"), { desc = "Test the solution" })

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
