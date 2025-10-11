-- Set leader key first
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('core.options')
require('core.keymaps')
require('plugins')
require('lsp.config')
require('ui')
