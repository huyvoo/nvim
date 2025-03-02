local cmp = require("cmp")
cmp.setup({
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item(), -- Move down in the menu
		["<C-p>"] = cmp.mapping.select_prev_item(), -- Move up in the menu
		["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
	},
	sources = {
		{ name = "nvim_lsp" }, -- LSP suggestions
		{ name = "buffer" }, -- Buffer text suggestions
		{ name = "path" }, -- Path completion
		{ name = "luasnip" }, -- Snippet completion
	},
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})

