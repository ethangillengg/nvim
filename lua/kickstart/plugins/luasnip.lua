return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		cond = not vim.g.vscode,
		build = (function()
			-- Build Step is needed for regex support in snippets.
			-- This step is not supported in many windows environments.
			-- Remove the below condition to re-enable on windows.
			if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
				return
			end
			return "make install_jsregexp"
		end)(),
		dependencies = {
			-- `friendly-snippets` contains a variety of premade snippets.
			--    See the README about individual language/framework/plugin snippets:
			--    https://github.com/rafamadriz/friendly-snippets
			-- {
			-- 	"rafamadriz/friendly-snippets",
			-- 	config = function()
			-- 		require("luasnip.loaders.from_vscode").lazy_load()
			-- 	end,
			-- },
			"nvim-treesitter/nvim-treesitter",
			"lervag/vimtex",
		},
		event = "InsertEnter",
		config = function()
			local ls = require("luasnip")
			vim.keymap.set({ "i" }, "<c-k>", function()
				ls.expand()
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<c-l>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<c-h>", function()
				ls.jump(-1)
			end, { silent = true })

			ls.setup({
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
				update_events = { "TextChanged", "TextChangedI" },
				region_check_events = {
					"CursorMoved",
					"CursorMovedI",
					"CursorHold",
					"InsertEnter",
					"TextChanged",
				},
				ft_func = function()
					local ft = require("luasnip.extras.filetype_functions").from_filetype()
					if vim.tbl_contains(ft, "latex") then
						return ft
					end

					-- set both markdown and inline to the same filetype
					if vim.tbl_contains(ft, "markdown") then
						table.insert(ft, "markdown_core")
					elseif vim.tbl_contains(ft, "markdown_inline") then
						table.insert(ft, "markdown_core")
						table.insert(ft, "latex")
					end

					return ft
				end,
				load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
					-- load latex for inline math
					markdown = { "markdown_core", "latex" },
					markdown_inline = { "markdown_core", "latex" },
					tex = { "latex" },
				}),
			})

			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/luasnippets" })
		end,
		keys = {
			{

				"<leader>L",
				function()
					require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/luasnippets" })
				end,
			},
		},
	},
}
