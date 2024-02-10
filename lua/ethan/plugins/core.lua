return {
	{ "nvim-lua/popup.nvim" }, --other api for stuffs
	{ "nvim-lua/plenary.nvim" }, --api for stuffs
	{ "nvim-tree/nvim-web-devicons" }, --icons for stuffs

	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true }, --bracket pairs
	{ "windwp/nvim-ts-autotag", event = "InsertEnter", config = true }, -- other auto pairs (html for example)
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = true,
	},
	{
		"fedepujol/move.nvim",
		config = true,
		init = function()
			local opts = { noremap = true, silent = true }
			-- Normal-mode commands
			vim.keymap.set("n", "<A-j>", ":MoveLine(1)<CR>", opts)
			vim.keymap.set("n", "<A-k>", ":MoveLine(-1)<CR>", opts)
			-- Visual-mode commands
			vim.keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>", opts)
			vim.keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>", opts)
		end,
		cmd = { "MoveLine", "MoveBlock", "MoveHBlock" },
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {

			{
				"nvim-telescope/telescope-fzf-native.nvim",
				"nvim-telescope/telescope-ui-select.nvim",
				-- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				build = "make",
			},
		},
		cmd = "Telescope",
		keys = {
			{ "<c-p>", "<cmd>Telescope fd<cr>", desc = "Find file" },
			{ "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Grep word" },
			{ "<leader>tw", "<cmd>Telescope live_grep<cr>", desc = "Grep word" },
			{ "<leader>tc", "<cmd>Telescope colorscheme<cr>", desc = "Theme" },
			{ "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "Help" },
			{ "<leader>ts", "<cmd>Telescope symbols<cr>", desc = "Symbols" },
			{ "<leader>tm", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
			{ "<leader>tb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>tt", "<cmd>Telescope builtin<cr>", desc = "Builtins" },
		},
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = {
					prompt_prefix = " ",
					selection_caret = "❯ ",
					sorting_strategy = "ascending",
					layout_config = {
						prompt_position = "top",
					},
					file_ignore_patterns = {
						"^wwwroot\\",
						"^target/",
					},
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				},
			}
		end,
		config = function(_, opts)
			local ts = require("telescope")
			ts.setup(opts)
			ts.load_extension("fzf")
			-- require("telescope.builtin").symbols({ sources = { "math", "latex", "nerd" } })
		end,
	}, --telescope
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		--configure later?
		-- dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = true,
	}, -- Easily comment stuff

	-- git integration
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		opts = {
			signs = {
				add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
				change = {
					hl = "GitSignsChange",
					text = "▎",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = {
					hl = "GitSignsChange",
					text = "▎",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
				untracked = { text = "▎" },
				--[[ untracked = { text = "┆" }, ]]
			},
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				delay = 0,
				virt_text_priority = 0,
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			},
		},
	},
	{ -- for git merge
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffViewFileHistory" },
		opts = {
			view = {
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
			file_panel = {

				win_config = {
					width = 20,
				},
			},
		},
	},

	{ "akinsho/git-conflict.nvim", version = "*", config = {} },
	-- UI
	{ "stevearc/dressing.nvim" }, -- styling for lsp rename and code actions
	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		opts = {
			update_focused_file = {
				enable = true,
				update_root = false,
			},
		},
		config = true,
		keys = {
			{ "<C-n>", ":NvimTreeToggle<CR>", desc = "Toggle file tree" },
		},
	},
	-- keymaps
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 10
			require("which-key").setup()
		end,
	},
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		opts = {
			timeout = 300,
		},
		config = function(_, opts)
			require("better_escape").setup(opts)
		end,
	},
	{
		"tpope/vim-fugitive",
		event = "VimEnter",
		keys = {

			{ "<leader>gg", ":Git ++curwin<CR>", desc = "Git summary" },
			{ "<leader>gc", ":Git commit<CR>", desc = "Git commit" },
			{ "<leader>gp", ":Git push<CR>", desc = "Git push" },
			{ "<leader>gd", ":Gdiffsplit<CR>", desc = "Git diff" },

			{ "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
			{ "<leader>gl", "<cmd>Gllog<CR>", desc = "Git log" },
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			debounce = 50,
			indent = {
				char = "┊",
			},
		},
	},
	{ "anuvyklack/pretty-fold.nvim", opts = {} },
}
