-- fzf-lua configuration
require("fzf-lua").setup({
	winopts = {
		width = 1.0, -- full width
		height = 1.0, -- full height
		preview = {
			layout = "vertical", -- vertical split (top/bottom)
			vertical = "up:75%", -- preview at top, takes 75% height
		},
	},
})

-- fzf-lua keymaps are now defined in core/keymaps.lua

-- LSP keymaps
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })