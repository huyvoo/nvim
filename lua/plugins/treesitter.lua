-- require("nvim-treesitter.configs").setup({
-- 	ensure_installed = "all",
-- 	highlight = { enable = true },
-- 	indent = { enable = true },
-- })

local nvim_tree = require("nvim-tree")
nvim_tree.setup()

local opts = { noremap = false, silent = true }

vim.api.nvim_set_keymap("n", "<Leader>e", ":NvimTreeToggle<CR>", opts)
