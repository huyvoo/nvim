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
	-- Catppuccin theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- Choose: latte, frappe, macchiato, mocha
				integrations = {
					treesitter = true,
					telescope = true,
					gitsigns = true,
					cmp = true,
					nvimtree = true,
					lsp_saga = true,
					which_key = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			views = {
				cmdline_popup = {
					position = {
						row = math.floor(vim.o.lines / 2), -- Centers vertically
						col = math.floor(vim.o.columns / 2 - 25), -- Centers horizontally
					},
					size = {
						width = 50, -- Adjust width as needed
						height = "auto",
					},
				},
			},
			presets = {
				command_palette = true, -- Example preset, you can customize as needed
			},
			routes = {
				{
					filter = { event = "notify" },
					opts = { skip = true }, -- This disables notifications
				},
			},
		},
	},
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
	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				layout = {
					default_direction = "right", -- Always open on the right side
					placement = "edge",
				},
				attach_mode = "global", -- Use Aerial globally for all buffers
				open_automatic = true, -- Auto-open when entering a file
				close_automatic_events = { "unfocus" }, -- Auto-close when losing focus
				keymaps = {
					["?"] = "actions.show_help", -- Show help
					["<CR>"] = "actions.jump", -- Jump to symbol
					["o"] = "actions.jump", -- Open (same as Enter)
					["<Tab>"] = "actions.down_and_jump", -- Jump to child symbol
					["<S-Tab>"] = "actions.up_and_jump", -- Jump to parent symbol
					["<Esc>"] = "actions.close", -- Close Aerial
					["q"] = "actions.close", -- Quit
					["l"] = "actions.next", -- Move to next symbol
					["h"] = "actions.prev", -- Move to previous symbol
					["{"] = "actions.prev_up", -- Move to previous parent symbol
					["}"] = "actions.next_up", -- Move to next parent symbol
					["[["] = "actions.prev", -- Jump to previous
					["]]"] = "actions.next", -- Jump to next
				},
			})

			-- Global shortcuts for toggling Aerial
			vim.api.nvim_set_keymap("n", "<leader>jk", ":AerialToggle! right<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>j", ":AerialNext<CR>", { noremap = true, silent = true }) -- Next symbol
			vim.api.nvim_set_keymap("n", "<leader>k", ":AerialPrev<CR>", { noremap = true, silent = true }) -- Previous symbol
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
		},
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
})

require("plugins/treesitter")
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
