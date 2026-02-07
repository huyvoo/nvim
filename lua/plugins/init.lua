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
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			winopts = {
				width = 1.0, -- full width
				height = 1.0, -- full height
				preview = {
					layout = "vertical", -- vertical split (top/bottom)
					vertical = "up:75%", -- preview at top, takes 75% height
				},
			},
		},
	},
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
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>e",
				function()
					require("nvim-tree.api").tree.toggle({ focus = false })
				end,
				desc = "Toggle file tree",
			},
		},
		config = function()
			require("nvim-tree").setup()
		end,
	},
	"nvim-treesitter/nvim-treesitter",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"neovim/nvim-lspconfig",
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"aznhe21/actions-preview.nvim",
		keys = {
			{
				"<leader>ca",
				function()
					require("actions-preview").code_actions()
				end,
				mode = { "n", "v" },
				desc = "Code Action (preview)",
			},
		},
		config = function()
			local actions_preview = require("actions-preview")
			local has_telescope, themes = pcall(require, "telescope.themes")
			local telescope_opts = {}

			if has_telescope then
				local entry_display = require("telescope.pickers.entry_display")
				local strings = require("plenary.strings")
				telescope_opts = themes.get_dropdown({
					layout_strategy = "vertical",
					layout_config = {
						width = 0.85,
						height = 0.9,
						prompt_position = "top",
					},
					sorting_strategy = "ascending",
					make_make_display = function(values)
						local index_width, title_width, client_width = 0, 0, 0

						for _, value in ipairs(values) do
							index_width = math.max(index_width, strings.strdisplaywidth(value.index))
							title_width = math.max(title_width, strings.strdisplaywidth(value.title))
							client_width = math.max(client_width, strings.strdisplaywidth(value.client_name or ""))
						end

						local displayer = entry_display.create({
							separator = " ",
							items = {
								{ width = index_width + 2 }, -- include "."
								{ width = title_width },
								{ width = client_width },
							},
						})

						return function(entry)
							return displayer({
								{ string.format("%d.", entry.value.index), "TelescopePromptPrefix" },
								{ entry.value.title },
								{ entry.value.client_name or "", "TelescopeResultsComment" },
							})
						end
					end,
				})
			end

			actions_preview.setup({
				backend = { "telescope", "nui" },
				telescope = telescope_opts,
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			if vim.fn.executable("dlv") == 0 then
				vim.notify("dlv not found in PATH; Go debugging will not work", vim.log.levels.WARN)
			end

			dap.adapters.go = {
				type = "server",
				host = "127.0.0.1",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}

			dap.configurations.go = {
				{
					type = "go",
					name = "Debug file",
					request = "launch",
					program = "${file}",
				},
				{
					type = "go",
					name = "Debug package (cwd)",
					request = "launch",
					program = "${workspaceFolder}",
				},
				{
					type = "go",
					name = "Debug test (file)",
					request = "launch",
					mode = "test",
					program = "${file}",
				},
			}

			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- DAP keymaps: edit bindings here.
			local map = vim.keymap.set
			map("n", "<F5>", dap.continue, { desc = "DAP continue" })
			map("n", "<F10>", dap.step_over, { desc = "DAP step over" })
			map("n", "<F11>", dap.step_into, { desc = "DAP step into" })
			map("n", "<F12>", dap.step_out, { desc = "DAP step out" })
			map("n", "<F9>", dap.toggle_breakpoint, { desc = "DAP breakpoint" })
			map("n", "<F8>", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "DAP conditional breakpoint" })
			map("n", "<F7>", dap.repl.open, { desc = "DAP REPL" })
			map("n", "<F6>", dapui.toggle, { desc = "DAP UI" })
		end,
	},
	"tpope/vim-commentary",
	"nvimtools/none-ls.nvim",
	-- "jose-elias-alvarez/null-ls.nvim",
	"windwp/nvim-autopairs",
	"navarasu/onedark.nvim",
	"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
	"kyazdani42/nvim-web-devicons",
	"lewis6991/gitsigns.nvim", -- Git integration
	{
		"williamboman/mason.nvim", -- Mason package manager
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim", -- Bridges Mason with nvim-lspconfig
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "gopls" }, -- Auto-install Go language server
			})
		end,
	},
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
})

require("plugins/telescope") -- Now contains fzf-lua configuration
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

-- Java snippets
ls.add_snippets("java", {
	s("foreach", {
		t("for ("),
		i(1, "String"),
		t(" "),
		i(2, "string"),
		t(" : "),
		i(3, "args"),
		t({") {", "\t"}),
		i(0),
		t({"", "}"}),
	}),
})

-- Simple Java decompile helper using `jadx`
-- Usage: :JadxDecompile [optional_path_to_jar_or_class]
vim.api.nvim_create_user_command("JadxDecompile", function(opts)
	local function is_executable(bin)
		return vim.fn.executable(bin) == 1
	end

	if not is_executable("jadx") then
		vim.notify("jadx not found. Install with: brew install jadx", vim.log.levels.ERROR)
		return
	end

	local target = opts.args ~= "" and opts.args or vim.fn.expand("%:p")
	if target == nil or target == "" then
		vim.notify("No target file provided or current buffer has no file.", vim.log.levels.ERROR)
		return
	end

	local outdir = vim.fn.tempname()
	vim.fn.mkdir(outdir)

	local cmd = { "jadx", "-d", outdir, target }
	vim.notify("Decompiling with jadx...", vim.log.levels.INFO)

	vim.fn.jobstart(cmd, {
		on_exit = function(_, code)
			if code ~= 0 then
				vim.schedule(function()
					vim.notify("jadx failed (exit code " .. code .. ")", vim.log.levels.ERROR)
				end)
				return
			end

			-- Find first .java file in output and open it
			local java_files = vim.fn.systemlist("fd -t f -e java . " .. vim.fn.shellescape(outdir))
			if #java_files == 0 then
				java_files = vim.fn.systemlist("find " .. vim.fn.shellescape(outdir) .. " -type f -name '*.java'")
			end

			vim.schedule(function()
				if #java_files > 0 then
					vim.cmd("edit " .. java_files[1])
					vim.notify("Opened decompiled file: " .. java_files[1], vim.log.levels.INFO)
				else
					vim.notify("No .java files found in decompiled output.", vim.log.levels.WARN)
				end
			end)
		end,
	})
end, { nargs = "?", complete = "file" })

-- Better Java decompiler: prefer CFR (rich output, handles libraries well), fallback to jadx
-- Install: brew install cfr jadx fd
-- Usage: :JavaDecompile [path]  (defaults to current file)
vim.api.nvim_create_user_command("JavaDecompile", function(opts)
	local function is_exec(bin)
		return vim.fn.executable(bin) == 1
	end

	local target = opts.args ~= "" and opts.args or vim.fn.expand("%:p")
	if target == nil or target == "" then
		vim.notify("No target file provided or current buffer has no file.", vim.log.levels.ERROR)
		return
	end

	-- If target is a .jar, CFR can output to directory; if .class, it outputs to current dir
	local outdir = vim.fn.tempname()
	vim.fn.mkdir(outdir)

	local use_cfr = is_exec("cfr")
	if use_cfr then
		local args = { "cfr", target, "--outputdir", outdir, "--silent" }
		vim.notify("Decompiling with CFR...", vim.log.levels.INFO)
		vim.fn.jobstart(args, {
			on_exit = function(_, code)
				if code ~= 0 then
					vim.schedule(function()
						vim.notify("CFR failed (exit code " .. code .. ")", vim.log.levels.WARN)
					end)
					return
				end
				local java_files = vim.fn.systemlist("fd -t f -e java . " .. vim.fn.shellescape(outdir))
				if #java_files == 0 then
					java_files = vim.fn.systemlist("find " .. vim.fn.shellescape(outdir) .. " -type f -name '*.java'")
				end
				vim.schedule(function()
					if #java_files > 0 then
						vim.cmd("edit " .. java_files[1])
						vim.notify("Opened decompiled (CFR): " .. java_files[1], vim.log.levels.INFO)
					else
						vim.notify("No .java files found from CFR output.", vim.log.levels.WARN)
					end
				end)
			end,
		})
		return
	end

	-- Fallback to jadx if CFR is not available
	if not is_exec("jadx") then
		vim.notify("No decompiler found. Install with: brew install cfr jadx", vim.log.levels.ERROR)
		return
	end

	local cmd = { "jadx", "-d", outdir, target }
	vim.notify("Decompiling with jadx...", vim.log.levels.INFO)
	vim.fn.jobstart(cmd, {
		on_exit = function(_, code)
			if code ~= 0 then
				vim.schedule(function()
					vim.notify("jadx failed (exit code " .. code .. ")", vim.log.levels.ERROR)
				end)
				return
			end
			local java_files = vim.fn.systemlist("fd -t f -e java . " .. vim.fn.shellescape(outdir))
			if #java_files == 0 then
				java_files = vim.fn.systemlist("find " .. vim.fn.shellescape(outdir) .. " -type f -name '*.java'")
			end
			vim.schedule(function()
				if #java_files > 0 then
					vim.cmd("edit " .. java_files[1])
					vim.notify("Opened decompiled (jadx): " .. java_files[1], vim.log.levels.INFO)
				else
					vim.notify("No .java files found from jadx output.", vim.log.levels.WARN)
				end
			end)
		end,
	})
end, { nargs = "?", complete = "file" })

-- Open JDK source for a given class using $JAVA_HOME/lib/src.zip
-- Usage: :JdkSource java.util.Random  (or leave empty to use word under cursor)
vim.api.nvim_create_user_command("JdkSource", function(opts)
	local class_name = opts.args ~= "" and opts.args or vim.fn.expand("<cword>")
	local java_home = os.getenv("JAVA_HOME")
	if not java_home or java_home == "" then
		vim.notify("JAVA_HOME not set. Set JAVA_HOME to your JDK.", vim.log.levels.ERROR)
		return
	end
	local src_zip = java_home .. "/lib/src.zip"
	if vim.fn.filereadable(src_zip) ~= 1 then
		vim.notify("JDK src.zip not found at " .. src_zip, vim.log.levels.ERROR)
		return
	end

	local tmpdir = vim.fn.tempname()
	vim.fn.mkdir(tmpdir)

	-- Convert class name to path, e.g., java.util.Random -> java/util/Random.java
	local path = class_name:gsub("%.", "/") .. ".java"
	local unzip_cmd = { "unzip", "-p", src_zip, path }
	if vim.fn.executable("unzip") ~= 1 then
		vim.notify("unzip not found. Install it (macOS has it by default).", vim.log.levels.ERROR)
		return
	end

	local content = vim.fn.systemlist(table.concat(unzip_cmd, " "))
	if vim.v.shell_error ~= 0 or #content == 0 then
		vim.notify("Could not extract " .. path .. " from src.zip", vim.log.levels.WARN)
		return
	end

	local file_path = tmpdir .. "/" .. class_name:gsub("%.", "_") .. ".java"
	vim.fn.writefile(content, file_path)
	vim.cmd("edit " .. file_path)
	vim.notify("Opened JDK source: " .. class_name, vim.log.levels.INFO)
end, { nargs = "?" })
