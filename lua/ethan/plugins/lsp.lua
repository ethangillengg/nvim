return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		cmd = "Mason",
		keys = {
			{ "<leader>m", ":Mason<CR>", desc = "Open mason" },
		},
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	},
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		config = function()
			local icons = require("ethan.icons")

			local signs = {
				{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
				{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warn },
				{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
				{ name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
			}

			for _, sign in ipairs(signs) do
				vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
			end

			vim.diagnostic.config({
				-- show signs
				signs = {
					active = signs,
				},
				update_in_insert = true,
				severity_sort = true,
				float = {
					title = "Diagnostic",
					header = false,
					focusable = false,
					source = "always",
					border = "rounded",
					max_width = 80,
				},
			})

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				title = "Hover",
				border = "rounded",
				max_width = 80,
				max_height = 30,
			})

			-- makes floating windows transparent
			local set_hl_for_floating_window = function()
				vim.api.nvim_set_hl(0, "NormalFloat", {
					link = "Normal",
				})
				vim.api.nvim_set_hl(0, "FloatBorder", {
					bg = "none",
				})
			end
			set_hl_for_floating_window()

			-- prevent override by colorscheme
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = set_hl_for_floating_window,
			})

			require("ethan.lsp.lspconfig").setup()
		end,
	},

	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		config = true,
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"simrat39/rust-tools.nvim",
		config = false,
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		event = { "BufReadPre", "BufNewFile" },
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
	},
	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		config = {
			"*", -- highlight all files
		},
	},
	{
		"smjonas/inc-rename.nvim",
		cmd = { "IncRename" },
		dependencies = { { "stevearc/dressing.nvim", config = true } },
		opts = {
			input_buffer_type = "dressing",
		},
		keys = {
			{
				"<F2>",
				":IncRename ",
			},
		},
	},
}
