local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		-- null_ls.builtins.formatting.prettier, -- JavaScript, TypeScript
		-- null_lws.builtins.formatting.black, -- Python
		null_ls.builtins.formatting.gofmt, -- Go
	},
})

require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "vim" }, -- Disable in specific filetypes
	fast_wrap = {}, -- Enable fast wrapping feature
})
