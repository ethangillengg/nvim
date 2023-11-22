return {
	-- colors!!
	{ "catppuccin/nvim" },
	{ "folke/tokyonight.nvim" },
	{ "ellisonleao/gruvbox.nvim" },
	{
		"marko-cerovac/material.nvim",
		config = function()
			vim.g.material_style = "darker"
		end,
	},
}
