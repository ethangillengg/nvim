return {
	-- colors!!
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "kyazdani42/blue-moon" }, --cool colorscheme
	{ "sainnhe/sonokai" },
	{ "folke/tokyonight.nvim" },

	--allow transparency for colorschemes that don't support it
	{
		"xiyaowong/nvim-transparent",
		enable = true,
		opts = {
			enable = true,
			extra_groups = { -- table/string: additional groups that should be cleared
				-- In particular, when you set it to 'all', that means all available groups

				-- example of akinsho/nvim-bufferline.lua
				-- "BufferLineTabClose",
				-- "BufferlineBufferSelected",
				-- "BufferLineFill",
				-- "BufferLineBackground",
				-- "BufferLineSeparator",
				-- "BufferLineIndicatorSelected",
			},
			exclude = {}, -- table: groups you don't want to clear
		},
	},
}
