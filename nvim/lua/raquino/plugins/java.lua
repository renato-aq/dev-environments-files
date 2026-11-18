-- The JDK is keg-only in Homebrew, so Neovim finds it even when the shell doesn't.
-- jdtls itself runs on it, and its settings are in after/lsp/jdtls.lua.
local java_home = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
if not vim.env.JAVA_HOME and vim.uv.fs_stat(java_home) then
	vim.env.JAVA_HOME = java_home
	vim.env.PATH = vim.fs.joinpath(java_home, "bin") .. ":" .. vim.env.PATH
end
