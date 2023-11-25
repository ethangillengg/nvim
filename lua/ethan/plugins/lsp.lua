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

			local config = {
				virtual_text = true,
				-- show signs
				signs = {
					active = signs,
				},
				update_in_insert = true,
				underline = true,
				severity_sort = true,
				float = {
					focusable = false,
					source = "always",
					width = 80,
				},
			}

			vim.diagnostic.config(config)

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				width = 60,
			})

			require("ethan.lsp.lspconfig").setup()
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>ff",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				react = { { "prettierd", "prettier" } },
				vue = { { "prettierd", "prettier" } },
				nix = { "alejandra" },
				cs = { "charpier" },
				lua = { "stylua" },
				cpp = { "clang_format" },
				python = { "ruff_format" },
				bash = { "shfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				async = true,
				lsp_fallback = true,
			},
		},
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		config = true,
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	},

	{
		"simrat39/rust-tools.nvim",
		lazy = true,
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
}
