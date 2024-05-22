return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",

		opts = {
			context_commentstring = {
				enable = true,
			},
			ensure_installed = {
				"bash",
				"fish",
				"c",
				"cpp",
				"html",
				"javascript",
				"typescript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"vim",
				"vue",
				"css",
				"jsdoc",
				"rust",
				"yaml",
				"nix",
				"glsl",
				"query",
				"latex",
				"c_sharp",
			},
			sync_install = false,
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = { "" }, -- list of language that will be disabled
				additional_vim_regex_highlighting = true,
			},
			indent = {
				enable = true,
				disable = { "yaml" },
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					node_incremental = ",",
					node_decremental = ".",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
		keys = {
			{
				"<leader>st",
				"<cmd>InspectTree<CR>",
				desc = "TS: Inspect tree",
			},

			{
				"<leader>si",
				"<cmd>Inspect<CR>",
				desc = "TS: Inspect under cursor",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufEnter",
		opts = {
			enable = false,
		},
		init = function()
			vim.api.nvim_set_hl(0, "TreesitterContext", {
				link = "CursorLine",
			})
		end,
		keys = {
			{
				"[c",
				function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end,
				desc = "TS: Go to previous context",
			},
			{
				"<leader>sc",
				function()
					require("treesitter-context").toggle()
				end,
				desc = "TS: Toggle context",
			},
		},
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			{
				"<S-m>",
				function()
					require("treesj").toggle({ split = { recursive = true } })
				end,
				desc = "TS: Toggle join tree",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },

		opts = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = { query = "@function.outer", desc = "Select around function" },
					["if"] = { query = "@function.inner", desc = "Select inside function" },
					["ac"] = { query = "@comment.outer", desc = "Select around comment" },
					["ic"] = { query = "@comment.inner", desc = "Select inside comment" },
				},
				selection_modes = {
					["@function.inner"] = "v",
					["@function.outer"] = "v",
					["@comment.inner"] = "v", -- linewise
					["@comment.outer"] = "v", -- linewise
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<A-l>"] = {
						query = "@parameter.inner",
						desc = "Swap parameter (next)",
					},
				},
				swap_previous = {
					["<A-h>"] = {
						query = "@parameter.inner",
						desc = "Swap parameter (prev)",
					},
				},
			},
			move = {
				enable = true,
				set_jumpts = true,
				goto_next_start = { ["]f"] = "@function.outer" },
				goto_previous_start = { ["[f"] = "@function.outer" },
			},
			lsp_interop = {
				enable = true,
				border = "rounded",
				floating_preview_opts = {
					title = "Definition",
					scrollbar = true,
					max_width = 80,
					max_height = 30,
				},
				peek_definition_code = {
					["<s-f>"] = {
						query = "@function.outer",
						"Peek function definition",
					},
				},
			},
		},
		init = function()
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			-- Repeat movement with ; and ,
			-- ensure ; goes forward and , goes backward regardless of the last direction
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ".", ts_repeat_move.repeat_last_move_previous)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
		end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup({ textobjects = opts })
		end,
	},

	-- {
	-- 	"RRethy/nvim-treesitter-textsubjects",
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- 	opts = {
	-- 		enable = true,
	-- 		prev_selection = ",", -- (Optional) keymap to select the previous selection
	-- 		keymaps = {
	-- 			["."] = "textsubjects-smart",
	-- 			[";"] = "textsubjects-container-outer",
	-- 			["i;"] = {
	-- 				"textsubjects-container-inner",
	-- 				desc = "Select inside containers (classes, functions, etc.)",
	-- 			},
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("nvim-treesitter.configs").setup({ textsubjects = opts })
	-- 	end,
	-- },
}
