require("telescope").setup({})
vim.api.nvim_set_keymap("n", "<Leader>f", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>g", ":Telescope live_grep<CR>", { noremap = true, silent = true })
