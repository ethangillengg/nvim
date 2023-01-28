--Auto-install lazy.nvimlualua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

-- Install your plugins here
lazy.setup({
	"nvim-lua/plenary.nvim", --api for stuffs
	"nvim-lua/popup.nvim", --other api for stuffs
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }, --treesitter
	"nvim-telescope/telescope.nvim", --telescope
	"kyazdani42/nvim-web-devicons", --icons for stuffs
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- fast sorter for telescope
	"windwp/nvim-autopairs", --bracket pairs
	"windwp/nvim-ts-autotag", -- other auto pairs (html for example)
	"numToStr/Comment.nvim", -- Easily comment stuff
	"JoosepAlviste/nvim-ts-context-commentstring",
	"nvim-lualine/lualine.nvim", --nice line at bottom
	"xiyaowong/nvim-transparent", --allow transparency for colorschemes that don't support it
	--[[ use({ "akinsho/toggleterm.nvim", tag = "v2.*" }) --terminal in neovim!! ]]
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			--[[ "nvim-tree/nvim-web-devicons", -- optional, for file icons ]]
			"kyazdani42/nvim-web-devicons", -- optional, for file icons
		},
	},
	"goolord/alpha-nvim", --greeter
	"lewis6991/impatient.nvim", --make neovim start faster!
	"voldikss/vim-floaterm",

	-- cmp plugins
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"saadparwaiz1/cmp_luasnip",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",

	-- snippets
	{ "L3MON4D3/LuaSnip", lazy = true },
	"rafamadriz/friendly-snippets",

	-- LSP
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	"jose-elias-alvarez/null-ls.nvim",

	-- colors!!
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "kyazdani42/blue-moon" }, --cool colorscheme
	{ "sainnhe/sonokai" },
	{ "folke/tokyonight.nvim" },

	-- git integration
	{ "lewis6991/gitsigns.nvim" },
	{ "gelguy/wilder.nvim" },
})
