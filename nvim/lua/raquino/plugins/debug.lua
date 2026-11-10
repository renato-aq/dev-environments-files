local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- The UI follows the session, <leader>Du brings it back after it ends
dap.listeners.after.event_initialized["dapui"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui"] = function()
	dapui.close()
end

vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
local sign_hl = { Stopped = "DiagnosticWarn", BreakpointRejected = "DiagnosticError" }
for name, icon in pairs(Raquino.icons.dap) do
	local line_hl = name == "Stopped" and "DapStoppedLine" or nil
	vim.fn.sign_define("Dap" .. name, {
		text = icon,
		texthl = sign_hl[name] or "DiagnosticInfo",
		linehl = line_hl,
		numhl = line_hl,
	})
end
