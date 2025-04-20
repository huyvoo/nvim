local lazypath = vim.fn.stdpath("config") .. "../lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	print("Installing lazy.nvim...")
	vim.fn.system({
		"git",
		"clone",
		"--depth=1",
		"https://github.com/folke/lazy.nvim",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			load = {
				["core.defaults"] = {}, -- Loads default behaviour
				["core.concealer"] = {}, -- Adds pretty icons
				["core.dirman"] = { -- Manages Neorg workspaces
					config = {
						workspaces = {
							notes = "~/neorg",
						},
						default_workspace = "notes",
					},
				},
			},
		},
		lazy = false, -- load on startup (optional)
	},
	-- lazy.nvim setup
	{
		"tanvirtin/monokai.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme monokai")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
				indent = { char = "│" }, -- Change this to "┆", "┊", "▏", etc. if preferred
				scope = { show_start = true, show_end = true },
			})
		end,
	},
	{
		"hrsh7th/cmp-cmdline", -- Add cmp-cmdline
		dependencies = { "hrsh7th/nvim-cmp" }, -- Ensure cmp-cmdline depends on nvim-cmp
	},
	"tpope/vim-dadbod", -- Database connection plugin
	"kristijanhusak/vim-dadbod-ui", -- UI for vim-dadbod
	"kristijanhusak/vim-dadbod-completion", -- Autocompletion for SQL
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-tree.lua",
	"nvim-telescope/telescope.nvim",
	"nvim-treesitter/nvim-treesitter",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"neovim/nvim-lspconfig",
	"tpope/vim-commentary",
	"jose-elias-alvarez/null-ls.nvim",
	"windwp/nvim-autopairs",
	"navarasu/onedark.nvim",
	"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
	"kyazdani42/nvim-web-devicons",
	"lewis6991/gitsigns.nvim", -- Git integration
	"williamboman/mason.nvim", -- Mason package manager
	"williamboman/mason-lspconfig.nvim", -- Bridges Mason with nvim-lspconfig
	"christoomey/vim-tmux-navigator",
	"numToStr/Comment.nvim",
	"tpope/vim-fugitive",
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- {
	-- 	"folke/noice.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		views = {
	-- 			cmdline_popup = {
	-- 				position = {
	-- 					row = math.floor(vim.o.lines / 2), -- Centers vertically
	-- 					col = math.floor(vim.o.columns / 2 - 25), -- Centers horizontally
	-- 				},
	-- 				size = {
	-- 					width = 50, -- Adjust width as needed
	-- 					height = "auto",
	-- 				},
	-- 			},
	-- 		},
	-- 		presets = {
	-- 			command_palette = true, -- Example preset, you can customize as needed
	-- 		},
	-- 		routes = {
	-- 			{
	-- 				filter = { event = "notify" },
	-- 				opts = { skip = true }, -- This disables notifications
	-- 			},
	-- 		},
	-- 	},
	-- },
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 20, -- Adjust the size of the terminal
				open_mapping = [[<c-t>]],
				direction = "float", -- Set the terminal to be floating
			})
		end,
	},
	{
		"vimwiki/vimwiki",
		config = function()
			vim.g.vimwiki_list = {
				{
					path = "~/vimwiki/", -- Change the path where your notes will be stored
					syntax = "markdown", -- Or you can use 'mediawiki' syntax if you prefer
					ext = ".md",
				},
			}
		end,
	},
	{
		"mistricky/codesnap.nvim",
		build = "make build_generator",
		keys = {
			{ "<leader>tt", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
			{ "<leader>ttt", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
		},
		opts = {
			save_path = "~/Pictures",
			has_breadcrumbs = true,
			bg_theme = "bamboo",
		},
		config = function()
			local codesnap = require("codesnap")
			codesnap.setup({
				save_path = "~/Pictures",
				has_breadcrumbs = true,
				bg_theme = "bamboo",
			})

			-- Define a custom function to save to directory
			function _G.snap()
				codesnap.snap() -- This will save to the configured path (~/Pictures)
			end
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for icons
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				sections = {
					lualine_c = { { "filename", path = 1 } },
				},
			})
		end,
	},
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	version = "*",
	-- 	dependencies = "nvim-tree/nvim-web-devicons",
	-- 	config = function()
	-- 		require("bufferline").setup({
	-- 			options = {
	-- 				separator_style = "slant", -- or "padded_slant", "thick", "thin", "slope"
	-- 				diagnostics = "nvim_lsp",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" }, -- Lua formatter
				python = { "black" }, -- Python formatter
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				sh = { "shfmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
		keys = {
			{
				"<leader>fa",
				function()
					require("conform").format()
				end,
				desc = "Format File",
			},
		},
	},
	-- {
	-- 	"stevearc/aerial.nvim",
	-- 	config = function()
	-- 		require("aerial").setup({
	-- 			layout = {
	-- 				default_direction = "right", -- Always open on the right side
	-- 				placement = "edge",
	-- 			},
	-- 			attach_mode = "global", -- Use Aerial globally for all buffers
	-- 			open_automatic = true, -- Auto-open when entering a file
	-- 			close_automatic_events = { "unfocus" }, -- Auto-close when losing focus
	-- 		})
	--
	-- 		-- Global shortcuts for toggling Aerial
	-- 		vim.api.nvim_set_keymap("n", "<leader>jk", ":AerialToggle! right<CR>", { noremap = true, silent = true })
	-- 		vim.api.nvim_set_keymap("n", "<leader>j", ":AerialNext<CR>", { noremap = true, silent = true }) -- Next symbol
	-- 		vim.api.nvim_set_keymap("n", "<leader>k", ":AerialPrev<CR>", { noremap = true, silent = true }) -- Previous symbol
	-- 	end,
	-- },
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
})

require("plugins/telescope")
require("plugins/tmux_navigator")
require("plugins/greeter")

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

require("Comment").setup()

-- Map 'c' + 'p' to toggle comments
vim.api.nvim_set_keymap(
	"n",
	"cp",
	':lua require("Comment.api").toggle.linewise.current()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"v",
	"cp",
	':lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
	{ noremap = true, silent = true }
)
require("luasnip.loaders.from_vscode").lazy_load()
local ls = require("luasnip")

vim.keymap.set({ "i" }, "<C-K>", function()
	ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function()
	ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function()
	ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("c", {
	s("fopen", {
		t("fopen("),
		i(1, '"filename.txt"'),
		t(", "),
		i(2, '"r"'),
		t(");"),
	}),
})
