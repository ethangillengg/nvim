-- Options
vim.o.clipboard='unnamedplus'
vim.wo.nu = true
vim.wo.relativenumber = true
vim.o.termguicolors = true
vim.o.scrolloff = 8
vim.o.syntax = 'on'
vim.o.errorbells = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.hlsearch = false 
vim.o.incsearch = true
vim.o.hidden = true
vim.o.mouse = 'a'
vim.o.completeopt='menuone,noinsert,noselect'
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.signcolumn = 'yes'
vim.wo.wrap = false
vim.g.mapleader = ' '


-- Require Plugins
vim.cmd [[packadd packer.nvim]]
require('plugins')
require('colorbuddy').colorscheme('gloombuddy')
require('nvim-autopairs').setup {}
require('lspconfig')


-- Mappings
local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

key_mapper('n', '<leader>w', ':w<cr>')
key_mapper('n', '<leader>q', ':wa<cr>')
key_mapper('n', '<leader>ff', ':Telescope find_files<cr>')
key_mapper('n', '<leader>fw', ':Telescope live_grep<cr>')
key_mapper('n', '<c-p>', ':Telescope find_files<cr>')
key_mapper('n', '<c-n>', ':NeoTreeRevealToggle<cr>')


-- Require Configs
require('lualine_config')
require('treesitter_config')
require('lsp_config')
require('cmp_config')
