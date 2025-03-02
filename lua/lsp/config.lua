local nvim_lsp = require("lspconfig")

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
})

-- C/C++

nvim_lsp.clangd.setup({
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--query-driver=/usr/bin/clang++,/usr/bin/g++",
        "--compile-commands-dir=build",
        "--log=error",
        "--extra-arg=-isystem",
        "--extra-arg=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1",
        "--extra-arg=-I/Library/Developer/CommandLineTools/usr/include",
        "--extra-arg=-I/Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/include"
    },
    filetypes = { "c" , "objc", "objcpp" },
    root_dir = function(fname)
        return nvim_lsp.util.root_pattern("compile_commands.json", "CMakeLists.txt", ".git")(fname)
            or vim.fn.getcwd()
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

nvim_lsp.clangd.setup({
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "cpp" } 
})

-- Keybindings for LSP
local lsp_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>d", "<cmd>lua vim.lsp.buf.type_definition()<CR>", lsp_opts)
vim.api.nvim_set_keymap("n", "<Leader>b", "<C-o>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>F", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })
-- Vertical split
vim.api.nvim_set_keymap("n", "<Leader>v", ":vsplit<CR>", { noremap = true, silent = true })

-- Horizontal split
vim.api.nvim_set_keymap("n", "<Leader>h", ":split<CR>", { noremap = true, silent = true })
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason.setup()
mason_lspconfig.setup({
	ensure_installed = { "pyright", "lua_ls", "clangd" }, -- Added clangd
	automatic_installation = true,
})

-- Setup LSPs
local servers = { "pyright", "lua_ls", "clangd" }
for _, server in ipairs(servers) do
	lspconfig[server].setup({})
end
-- Import and configure null-ls for formatting, diagnostics, etc.
require("lsp.null-ls")
require("lsp.cmp")
