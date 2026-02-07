vim.opt.swapfile = false
-- Set leader key to space
vim.g.mapleader = " "

-- Enable line numbers
vim.opt.number = true
-- Basic
vim.opt.relativenumber = false

-- Enable mouse support
vim.opt.mouse = "a"

-- Enable system clipboard support
vim.opt.clipboard = "unnamedplus"

-- Key mappings for copying and pasting to/from system clipboard
vim.api.nvim_set_keymap("n", "<Leader>y", '"*y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>p", '"*p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>Y", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>P", '"+p', { noremap = true, silent = true })

-- Better tab handling
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Enable smart case search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable syntax highlighting
vim.cmd("syntax on")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local function set_cursor_highlight()
	-- Ensure the cursor stays yellow even after colorscheme changes.
	vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#FFFF00" })
	vim.api.nvim_set_hl(0, "CursorIM", { fg = "#000000", bg = "#FFFF00" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_cursor_highlight,
})

set_cursor_highlight()
-- Set colorscheme
-- local ls = require("luasnip")
--
-- vim.keymap.set({ "i" }, "<c-k>", function()
-- 	ls.expand()
-- end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<c-l>", function()
-- 	ls.jump(1)
-- end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<c-j>", function()
-- 	ls.jump(-1)
-- end, { silent = true })
--
-- vim.keymap.set({ "i", "s" }, "<c-e>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, { silent = true })
