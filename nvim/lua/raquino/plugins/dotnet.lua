-- The SDK lives in ~/.dotnet (dotnet-install.sh), so Neovim finds it even when the shell doesn't
local dotnet_root = vim.fs.joinpath(vim.env.HOME, ".dotnet")
if not vim.env.DOTNET_ROOT and vim.uv.fs_stat(dotnet_root) then
	vim.env.DOTNET_ROOT = dotnet_root
	vim.env.PATH = dotnet_root .. ":" .. vim.fs.joinpath(dotnet_root, "tools") .. ":" .. vim.env.PATH
end

-- Roslyn, the debugger and the test runner. Roslyn settings are in after/lsp/easy_dotnet.lua.
require("easy-dotnet").setup({
	picker = "snacks",
	auto_bootstrap_namespace = { type = "file_scoped", enabled = true },
	debugger = {
		-- Its bundled netcoredbg has an arm64 build, Mason's is x64 only
		engine = "netcoredbg",
	},
	-- The defaults are <leader>d and <leader>p, which shadow the register keys in test files
	test_runner = {
		mappings = {
			run_test_from_buffer = { lhs = "<leader>tr", desc = "Run the test" },
			run_all_tests_from_buffer = { lhs = "<leader>ta", desc = "Run all tests in the file" },
			debug_test_from_buffer = { lhs = "<leader>td", desc = "Debug the test" },
			peek_stack_trace_from_buffer = { lhs = "<leader>tp", desc = "Peek the test output" },
		},
	},
	outdated = {
		mappings = {
			upgrade = { lhs = "<leader>nu", desc = "Upgrade the package" },
			upgrade_all = { lhs = "<leader>nU", desc = "Upgrade all outdated packages" },
		},
	},
})
