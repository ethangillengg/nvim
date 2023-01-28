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
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }, --treesitter
	{ "nvim-lua/plenary.nvim" }, --api for stuffs
	{ "nvim-lua/popup.nvim" }, --other api for stuffs
	{ "kyazdani42/nvim-web-devicons" }, --icons for stuffs
	{ "windwp/nvim-autopairs" }, --bracket pairs
	{ "windwp/nvim-ts-autotag" }, -- other auto pairs (html for example)
	{ "nvim-telescope/telescope.nvim" }, --telescope
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- fast sorter for telescope
	{ "numToStr/Comment.nvim", dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" } }, -- Easily comment stuff
	{ "xiyaowong/nvim-transparent" }, --allow transparency for colorschemes that don't support it
	{ "nvim-lualine/lualine.nvim" }, --nice line at bottom
	{ "nvim-tree/nvim-tree.lua", dependencies = { "kyazdani42/nvim-web-devicons" } },
	{ "goolord/alpha-nvim" }, --greeter
	{ "lewis6991/impatient.nvim" }, --make neovim start faster!
	{ "voldikss/vim-floaterm" },
	-- cmp plugins
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "hrsh7th/cmp-cmdline" },
	-- snippets
	{ "L3MON4D3/LuaSnip", lazy = true },
	{ "rafamadriz/friendly-snippets" },
	-- LSP
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "jose-elias-alvarez/null-ls.nvim" },
	{ "folke/neodev.nvim" }, -- LSP for neovim config!
	-- colors!!
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "kyazdani42/blue-moon" }, --cool colorscheme
	{ "sainnhe/sonokai" },
	{ "folke/tokyonight.nvim" },
	-- git integration
	{ "lewis6991/gitsigns.nvim" },

	-- keymaps
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},

	-- UI
	{ "stevearc/dressing.nvim" }, -- styling for lsp rename and code actions
})
