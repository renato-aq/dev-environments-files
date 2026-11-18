local packages = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages")
-- jdtls needs Java 25 to run, so it gets Homebrew's latest JDK. Projects still build with the
-- JDK 21 in JAVA_HOME, through the runtimes setting below.
local server_java = "/opt/homebrew/opt/openjdk/bin/java"

-- java-debug and vscode-java-test, loaded into jdtls so nvim-jdtls can debug and run tests
local bundles = vim.fn.glob(
	vim.fs.joinpath(packages, "java-debug-adapter", "extension", "server", "com.microsoft.java.debug.plugin-*.jar"),
	true,
	true
)
for _, jar in ipairs(vim.fn.glob(vim.fs.joinpath(packages, "java-test", "extension", "server", "*.jar"), true, true)) do
	local name = vim.fs.basename(jar)
	-- These two aren't OSGi bundles, jdtls fails to load them
	if name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" and name ~= "jacocoagent.jar" then
		table.insert(bundles, jar)
	end
end

return {
	cmd = function(dispatchers, config)
		local root = config.root_dir or vim.fn.getcwd()
		-- The index lives outside the project. The hash keeps same-named projects apart.
		local data_dir = vim.fs.joinpath(
			vim.fn.stdpath("cache"),
			"jdtls",
			vim.fs.basename(root) .. "-" .. vim.fn.sha256(root):sub(1, 8)
		)
		local cmd = {
			"jdtls",
			"--java-executable=" .. server_java,
			"--jvm-arg=-javaagent:" .. vim.fs.joinpath(packages, "jdtls", "lombok.jar"),
			"-data",
			data_dir,
		}
		-- nvim-jdtls reads the data dir off a cmd table, for :JdtWipeDataAndRestart and :JdtShowLogs
		config.cmd = cmd
		return vim.lsp.rpc.start(cmd, dispatchers, {
			cwd = config.cmd_cwd,
			env = config.cmd_env,
			detached = config.detached,
		})
	end,
	-- The wrappers and .git first, so a multi-module project gets a single server
	root_markers = {
		{ "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" },
		{ "pom.xml", "build.gradle", "build.gradle.kts", "build.xml" },
	},
	init_options = {
		bundles = bundles,
	},
	-- jdtls registers inlay hints after it attaches, too late for the check in plugins/lsp.lua
	on_attach = function(_, bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
	settings = {
		java = {
			configuration = {
				updateBuildConfiguration = "automatic",
				runtimes = {
					{ name = "JavaSE-21", path = vim.env.JAVA_HOME, default = true },
				},
			},
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			signatureHelp = { enabled = true, description = { enabled = true } },
			-- jdtls sends no inlay hints unless they're enabled here
			inlayHints = { parameterNames = { enabled = "all" } },
			completion = {
				favoriteStaticMembers = {
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
					"org.assertj.core.api.Assertions.*",
					"org.mockito.Mockito.*",
					"org.mockito.ArgumentMatchers.*",
				},
			},
		},
	},
}
