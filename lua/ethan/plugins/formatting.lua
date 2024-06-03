return {
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
				html = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				scss = { { "prettierd", "prettier" } },
				vue = { { "prettierd", "prettier" } },

				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },

				nix = { "alejandra" },
				-- cs = { "charpier" },
				lua = { "stylua" },
				cpp = { "clang_format" },
				glsl = { "clang_format" },
				python = { "ruff_format" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				yaml = { "yamlfmt" },
				tex = { "latexindent" },
				asm = { "asmfmt" },
				xml = { "xmlformat" },
				go = { "gopls" },
			},
			format_on_save = {
				timeout_ms = 500,
				async = true,
				lsp_fallback = true,
			},
		},
	},
}
