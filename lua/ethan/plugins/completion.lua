return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		build = "make install_jsregexp",
		event = "InsertEnter",
		config = function()
			require("luasnip").config.set_config({
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
				update_events = "TextChanged,TextChangedI",

				ft_func = function(...)
					local snip_at_cursor = require("luasnip.extras.filetype_functions").from_cursor_pos(...)
					if vim.tbl_contains(snip_at_cursor, "latex") then
						return snip_at_cursor
					end
					if
						vim.tbl_contains(snip_at_cursor, "markdown")
						or vim.tbl_contains(snip_at_cursor, "markdown_inline")
					then
						-- set both markdown and inline to the same filetype
						table.insert(snip_at_cursor, "markdown_core")
					end
					return snip_at_cursor
				end,
				load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
					-- load latex for inline math
					markdown = { "markdown_core", "latex" },
					tex = { "latex" },
				}),
			})

			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/luasnippets" })
		end,
		keys = {
			{
				"<leader>L",
				function()
					require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })
				end,
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-emoji",
			"L3MON4D3/LuaSnip",
			{
				--cmp in commandline!
				"hrsh7th/cmp-cmdline",
				config = function()
					local cmp = require("cmp")
					cmp.setup.cmdline("/", {
						mapping = cmp.mapping.preset.cmdline(),
						sources = {
							{ name = "buffer" },
						},
					})
					cmp.setup.cmdline(":", {
						mapping = cmp.mapping.preset.cmdline(),
						sources = cmp.config.sources({
							{ name = "path" },
						}, {
							{
								name = "cmdline",
								option = {
									ignore_cmds = { "Man", "!" },
								},
							},
						}),
					})
				end,
			},
			{
				"zbirenbaum/copilot-cmp",
				opts = true, -- auto setup
			},
		},
		opts = function()
			local cmp = require("cmp")
			local icons = require("ethan.icons")
			local ls = require("luasnip")

			return {
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-s>"] = cmp.mapping.complete({ reason = "manual" }),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
						-- that way you will only jump inside the snippet region
						elseif ls.expand_or_jumpable() then
							ls.expand_or_jump()
						-- elseif has_words_before() then
						-- 	cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif ls.jumpable(-1) then
							ls.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-c>"] = cmp.mapping.abort(),

					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),

				sources = cmp.config.sources({
					{ name = "mkdnflow" },
					{ name = "nvim_lsp" },
					{ name = "copilot" },
					-- { name = "nvim_lsp_signature_help" },
					{ name = "nvim_lua" },
					{ name = "path" },
					{ name = "buffer", keyword_length = 3, max_item_count = 10 },
					{ name = "luasnip" },
					{ name = "emoji" },
				}),
				sorting = {
					priority_weight = 2,
					comparators = {
						require("copilot_cmp.comparators").prioritize,

						-- Below is the default comparitor list and order for nvim-cmp
						cmp.config.compare.offset,
						-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(entry, vim_item)
						-- Kind icons
						vim_item.kind = icons.kind[vim_item.kind]
						vim_item.menu = ({
							mkdnflow = "[Flow]",
							copilot = "[Copilot]",
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							path = "[Path]",
							buffer = "[Buffer]",
							nvim_lua = "[LUA]",
							emoji = "[Emoji]",
						})[entry.source.name]
						return vim_item
					end,
				},
				window = {
					completion = {
						winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
						border = "rounded",
						scrollbar = true,
						max_width = 60,
					},
					documentation = {
						winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
						border = "rounded",
						scrollbar = true,
						max_width = 60,
					},
				},
			}
		end,
		config = function(_, opts)
			vim.g.cmp_active = true
			require("cmp").setup(opts)
		end,
	},
}
