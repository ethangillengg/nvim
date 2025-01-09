-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
	{

		"windwp/nvim-autopairs",
		cond = not vim.g.vscode,
		event = "InsertEnter",
		-- Optional dependency
		-- dependencies = { "hrsh7th/nvim-cmp" },
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		cond = not vim.g.vscode,
		lazy = false,
		opts = {},
	},
}
