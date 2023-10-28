local cmp_copilot = {
	"zbirenbaum/copilot-cmp",
	opts = true, -- auto setup
}

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

return {
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
			cmp_copilot,
		},
		opts = function()
			local cmp = require("cmp")
			local icons = require("ethan.icons")

			return {
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
					-- ["<Tab>"] = vim.schedule_wrap(function(fallback)
					-- 	if cmp.visible() and has_words_before() then
					-- 		cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					-- 	else
					-- 		fallback()
					-- 	end
					-- end),
					--
					-- ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
					-- 	if cmp.visible() and has_words_before() then
					-- 		cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					-- 	else
					-- 		fallback()
					-- 	end
					-- end),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),

				sources = cmp.config.sources({
					{ name = "neorg" },
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
			}
		end,
		config = function(_, opts)
			vim.g.cmp_active = true
			require("cmp").setup(opts)
		end,
	},
}
