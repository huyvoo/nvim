require("telescope").setup({
	extensions = {
		["ui-select"] = {
			values = require("telescope.themes").get_dropdown({
				layout_strategy = "vertical",
				layout_config = {
					preview_width = 0.5,
					prompt_position = "top",
				},
				previewer = true,
				prompt_title = "Code Actions",
			}),
		},
	},
})

vim.keymap.set("n", "<Leader>fb", function()
	require("telescope.builtin").buffers()
end, { noremap = true, silent = true })
require("telescope").load_extension("ui-select")
vim.api.nvim_set_keymap("n", "<Leader>f", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>g", ":Telescope live_grep<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Telescope Code Action" })
