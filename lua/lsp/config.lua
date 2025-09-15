local nvim_lsp = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

nvim_lsp.jdtls.setup({
	cmd = { "jdtls" },
	root_dir = nvim_lsp.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
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

nvim_lsp.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			checkOnSave = { command = "clippy" },
			procMacro = { enable = true },
		},
	},

	capabilities = capabilities,
})

nvim_lsp.gopls.setup({
	cmd = { "gopls" },
	filetypes = { "go", "gomod" },
	root_dir = nvim_lsp.util.root_pattern("go.mod", ".git"),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
	root_dir = require("lspconfig.util").root_pattern("go.mod", ".git"),
	capabilities = capabilities,
})

nvim_lsp.pyright.setup({
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "off", -- Change to "basic" or "strict" if needed
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		},
	},
	capabilities = capabilities,
})

-- C/C++
nvim_lsp.clangd.setup({
	on_new_config = function(new_config, root_dir)
		-- Check the file type and adjust the configuration accordingly
		if vim.bo.filetype == "c" then
			new_config.filetypes = { "c" }
			new_config.cmd = { "clangd" }
		elseif vim.bo.filetype == "cpp" then
			new_config.filetypes = { "cpp" }
		end
	end,
	capabilities = capabilities,
})

-- Keybindings for LSP
local lsp_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>d", "<cmd>lua vim.lsp.buf.type_definition()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>b", "<C-o>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"gi",
	"<cmd>lua require('telescope.builtin').lsp_implementations()<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"n",
	"<Leader>u",
	"<cmd>lua require('telescope.builtin').lsp_references()<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap("n", "<Leader>F", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })
-- Vertical split
vim.api.nvim_set_keymap("n", "<Leader>v", ":vsplit<CR>", { noremap = true, silent = true })

-- Horizontal split
vim.api.nvim_set_keymap("n", "<Leader>h", ":split<CR>", { noremap = true, silent = true })
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

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
