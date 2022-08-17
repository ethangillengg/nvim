--Auto-install packer
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim' --api for stuffs
  use 'nvim-lua/popup.nvim' --other api for stuffs
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } --treesitter
  use 'nvim-telescope/telescope.nvim' --telescope
  use 'kyazdani42/nvim-web-devicons' --icons for stuffs
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- fast sorter for telescope
  use 'windwp/nvim-autopairs' --bracket pairs
  use 'numToStr/Comment.nvim' --use 'gcc' to comment
  use 'nvim-lualine/lualine.nvim' --nice line at bottom
  use 'xiyaowong/nvim-transparent' --allow transparency for colorschemes that don't support it
  use { 'akinsho/toggleterm.nvim', tag = 'v2.*' } --terminal in neovim!!
  use 'goolord/alpha-nvim' --greeter
  use 'lewis6991/impatient.nvim' --make neovim start faster!
  use { 'nvim-neo-tree/neo-tree.nvim', requires = { 'MunifTanjim/nui.nvim' } } --file explorer

  -- cmp plugins  
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'saadparwaiz1/cmp_luasnip'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'

  -- snippets
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  -- LSP
  use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
  }

  -- colors!!
  use 'kyazdani42/blue-moon' --cool colorscheme
  use 'sainnhe/sonokai'

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
