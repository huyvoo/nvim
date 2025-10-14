-- Key Mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Remap ESC to jk
map("i", "jj", "<ESC>", opts)

-- Save file with Ctrl+s
map("n", "<C-s>", ":w<CR>", opts)

-- Split window shortcuts
map("n", "<Leader>v", ":vsplit<CR>", opts)
map("n", "<Leader>h", ":split<CR>", opts)

-- Move between splits using Ctrl + hjkl
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- fzf-lua keymaps
map("n", "<Leader>f", ":lua require('fzf-lua').files()<CR>", opts)
map("n", "<Leader>g", ":lua require('fzf-lua').live_grep()<CR>", opts)
map("n", "<Leader>fb", ":lua require('fzf-lua').buffers()<CR>", opts)
map("n", "<Leader>?", ":lua require('fzf-lua').help_tags()<CR>", opts)
map("n", "<Leader>c", ":lua require('fzf-lua').colorschemes()<CR>", opts)
map("n", "<Leader>m", ":lua require('fzf-lua').marks()<CR>", opts)
map("n", "<Leader>j", ":lua require('fzf-lua').jumps()<CR>", opts)
map("n", "<Leader>w", ":lua require('fzf-lua').grep_cword()<CR>", opts)
map("n", "<Leader>W", ":lua require('fzf-lua').grep_cWORD()<CR>", opts)

-- vim.api.nvim_set_keymap("n", "<Leader>e", ":NvimTreeToggle<CR>", opts)
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = true
	end,
})
