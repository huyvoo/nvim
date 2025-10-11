local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Java Development Tools Language Server
vim.lsp.config('jdtls', {
	cmd = { "jdtls" },
	root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
	settings = {
		java = {
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.hamcrest.Matchers.*",
				},
			},
			contentProvider = {
				preferred = "fernflower",
			},
		},
	},
	capabilities = capabilities,
})

-- Rust Analyzer
vim.lsp.config('rust_analyzer', {
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			checkOnSave = { command = "clippy" },
			procMacro = { enable = true },
		},
	},
	capabilities = capabilities,
})

-- Go Language Server
vim.lsp.config('gopls', {
	cmd = { "gopls" },
	filetypes = { "go", "gomod" },
	root_markers = { "go.mod", ".git" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
	capabilities = capabilities,
})

-- Python Language Server
vim.lsp.config('pyright', {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
	settings = {
		python = {
			analysis = {
				-- Path and indexing
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				indexing = true,
				packageIndexDepths = {
					{ name = "", depth = 2 },
					{ name = "numpy", depth = 5 },
					{ name = "pandas", depth = 5 },
					{ name = "scipy", depth = 5 },
					{ name = "matplotlib", depth = 5 },
					{ name = "sklearn", depth = 5 },
					{ name = "tensorflow", depth = 5 },
					{ name = "torch", depth = 5 },
				},
				
				-- Diagnostic mode
				diagnosticMode = "workspace", -- check all files in workspace
				typeCheckingMode = "basic", -- basic, strict, off
				
				-- Import resolution
				autoImportCompletions = true,
				include = { "**/*.py" },
				exclude = { "**/node_modules", "**/__pycache__", "**/.git" },
				
				-- Type checking settings
				strictListInference = true,
				strictDictionaryInference = true,
				strictSetInference = true,
				strictParameterNoneValue = true,
				
				-- Error reporting
				reportMissingImports = "error",
				reportMissingTypeStubs = "error",
				reportImportCycles = "error",
				reportUnusedImport = "warning",
				reportUnusedClass = "warning",
				reportUnusedFunction = "warning",
				reportUnusedVariable = "warning",
				reportDuplicateImport = "warning",
				reportWildcardImportFromLibrary = "warning",
				reportOptionalSubscript = "error",
				reportOptionalMemberAccess = "error",
				reportOptionalCall = "error",
				reportOptionalIterable = "error",
				reportOptionalOperand = "error",
				reportOptionalContextManager = "error",
				reportTypedDictNotRequiredAccess = "error",
				reportPrivateImportUsage = "error",
				reportConstantRedefinition = "error",
				reportIncompatibleMethodOverride = "error",
				reportIncompatibleVariableOverride = "error",
				reportOverlappingOverload = "error",
				reportUnnecessaryIsInstance = "warning",
				reportUnnecessaryCast = "warning",
				reportUnnecessaryComparison = "warning",
				reportUnnecessaryContains = "warning",
				reportAssertAlwaysTrue = "warning",
				reportSelfClsParameterName = "warning",
				reportImplicitStringConcatenation = "warning",
				reportInvalidStringEscapeSequence = "error",
				reportUnknownParameterType = "warning",
				reportUnknownArgumentType = "warning",
				reportUnknownLambdaType = "warning",
				reportUnknownVariableType = "warning",
				reportUnknownMemberType = "warning",
				reportMissingParameterType = "warning",
				reportMissingTypeArgument = "warning",
				reportInvalidTypeVarUse = "error",
				reportCallInDefaultInitializer = "warning",
				reportUnnecessaryTypeIgnoreComment = "warning",
				reportImplicitOverride = "warning",
				reportShadowedImports = "warning",
				reportUnusedCallResult = "warning",
				reportUntypedFunctionDecorator = "error",
				reportUntypedClassDecorator = "error",
				reportUntypedNamedTuple = "error",
				reportPrivateUsage = "error",
				reportTypeCommentUsage = "warning",
				
				-- Logging
				logLevel = "Information",
			},
			
			-- Python environment
			pythonPath = "python",
			venvPath = ".venv",
			venv = ".venv",
			
			-- Completion settings
			completion = {
				includeCompletionsForImportStatements = true,
				includeCompletionsWithSnippetText = true,
			},
		},
	},
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- Disable formatting for pyright (use null-ls or other formatters)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
})

-- C/C++ Language Server
vim.lsp.config('clangd', {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
	init_options = {
		clangdFileStatus = true,
		usePlaceholders = true,
		completeUnimported = true,
		allScopes = true,
	},
	settings = {
		clangd = {
			arguments = {
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--header-insertion=iwyu",
			},
		},
	},
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- Disable formatting for clangd (use null-ls or other formatters)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
})

-- Enable all configured language servers
vim.lsp.enable({ 'jdtls', 'rust_analyzer', 'gopls', 'pyright', 'clangd' })

-- Keybindings for LSP
local lsp_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>d", "<cmd>lua vim.lsp.buf.type_definition()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>b", "<C-o>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"gi",
	"<cmd>lua require('fzf-lua').lsp_implementations()<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"n",
	"<Leader>u",
	"<cmd>lua require('fzf-lua').lsp_references()<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap("n", "<Leader>F", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })
-- Vertical split
vim.api.nvim_set_keymap("n", "<Leader>v", ":vsplit<CR>", { noremap = true, silent = true })

-- Horizontal split
vim.api.nvim_set_keymap("n", "<Leader>h", ":split<CR>", { noremap = true, silent = true })

-- Import and configure null-ls for formatting, diagnostics, etc.
require("lsp.null-ls")
require("lsp.cmp")

-- Lua config
vim.keymap.set({ "i", "s" }, "<C-j>", function()
	return require("luasnip").jump(1)
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
	return require("luasnip").jump(-1)
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<Tab>", function()
	return require("luasnip").jumpable(1) and require("luasnip").jump(1) or "<Tab>"
end, { expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	return require("luasnip").jumpable(-1) and require("luasnip").jump(-1) or "<S-Tab>"
end, { expr = true, silent = true })
