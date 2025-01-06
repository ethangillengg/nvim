return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"Issafalcon/neotest-dotnet",
		"mfussenegger/nvim-dap",
		},
		config = function()
			require("neotest").setup({
				icons = {
					running_animated = { "⠻", "⠽", "⠾", "⠷", "⠯", "⠟" },
				},
				adapters = {
					require("neotest-dotnet"),
				},
				dap = {
					-- Extra arguments for nvim-dap configuration
					-- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
					args = { justMyCode = false },
					-- Enter the name of your dap adapter, the default value is netcoredbg
					adapter_name = "coreclr",
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
