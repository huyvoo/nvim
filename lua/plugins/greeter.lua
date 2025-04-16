local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set a cool ASCII banner
dashboard.section.header.val = {
	[[       Hello World!    ]],
}

-- Define buttons for quick actions with added descriptions
dashboard.section.buttons.val = {
	dashboard.button("f", "  Find File", ":Telescope find_files<CR>"), -- Quickly open files with Telescope
	dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"), -- Access recently opened files
	dashboard.button("n", "  New File", ":ene | startinsert<CR>"), -- Start a new file and go into insert mode
	dashboard.button("u", "  Update Plugins", ":Lazy update<CR>"), -- Update installed plugins
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"), -- Quit Neovim
	dashboard.button("o", "  Open Neorg Notes", ":Neorg workspace notes<CR>"),
}

-- Additional quick access for popular actions
dashboard.section.buttons.val = vim.list_extend(dashboard.section.buttons.val, {
	dashboard.button("t", "  Find Text", ":Telescope live_grep<CR>"), -- Find text within files
	dashboard.button("p", "  Git Pull", ":Lazy sync<CR>"), -- Sync with the latest git changes
})

-- Footer message with dynamic date
local date = os.date("%A, %B %d, %Y - %I:%M %p")

dashboard.section.footer.val = {
	"",
	"🚀 Today is " .. date,
}

-- Apply the theme configuration to Neovim
alpha.setup(dashboard.config)

-- Optional: Set up your Neovim startup screen to show the dashboard by default
vim.cmd([[autocmd User AlphaReady echo 'Welcome to your Neovim setup!']])
