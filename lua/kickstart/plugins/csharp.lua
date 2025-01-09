return {
	{
		"iabdelkareem/csharp.nvim",
		lazy = false,
		dependencies = {
			"mfussenegger/nvim-dap",
			"Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
		},
		config = function()
			require("csharp").setup({
				lsp = {
					omnisharp = {
						enable = false,
						-- cmd_path = "OmniSharp",
					},
					roslyn = {
						-- When set to true, csharp.nvim will launch roslyn automatically.
						enable = true,
						-- Path to the roslyn LSP see 'Roslyn LSP Specific Prerequisites' above.
						cmd_path = "Microsoft.CodeAnalysis.LanguageServer",
					},
				},
			})
		end,
	},
}
