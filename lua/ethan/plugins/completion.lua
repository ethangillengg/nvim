--cmp in commandline!
local cmp_cmdline = {
	"hrsh7th/cmp-cmdline",
	event = "CmdlineEnter",
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
}

return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-emoji",
			"L3MON4D3/LuaSnip",
			cmp_cmdline,
		},
		opts = function()
			local cmp = require("cmp")
			return {
				performance = {
					debounce = 0,
					throttle = 0,
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-c>"] = cmp.mapping.complete({ reason = "manual" }),
					["<C-s>"] = cmp.mapping.complete({ reason = "manual" }),
					["<C-j>"] = cmp.mapping.scroll_docs(4),
					["<C-k>"] = cmp.mapping.scroll_docs(-4),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "neorg" },
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer", keyword_length = 3, max_item_count = 10 },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "emoji" },
					{ max_item_count = 1 },
				}),
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(entry, vim_item)
						local icons = require("ethan.icons")
						-- Kind icons
						vim_item.kind = icons.kind[vim_item.kind]

						vim_item.menu = ({
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
					documentation = {
						border = "rounded",
						winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
						max_height = 60,
					},
					completion = {
						border = "rounded",
						winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
					},
				},
				experimental = {
					ghost_text = true,
				},
			}
		end,
		config = function(_, opts)
			vim.g.cmp_active = true
			require("cmp").setup(opts)
		end,
	},
}
