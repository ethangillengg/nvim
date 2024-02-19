return {
	-- colors!!
	{ "catppuccin/nvim" },
	{ "folke/tokyonight.nvim" },
	{ "ellisonleao/gruvbox.nvim" },
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_foreground = "original"
		end,
	},
	{
		"marko-cerovac/material.nvim",
		config = function()
			vim.g.material_style = "darker"
		end,
	},
}
