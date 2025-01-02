return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ethangillengg/neotest-dotnet",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-dotnet"),
				},
			})
		end,

		keys = {
			{
				"<C-t>",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "[T]oggle test explorer",
			},

			{
				"<a-t>",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "[T]oggle test output",
			},
		},
	},
}
