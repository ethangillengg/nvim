return {
	{ "nvim-lua/popup.nvim" }, --other api for stuffs
	{ "nvim-lua/plenary.nvim" }, --api for stuffs
	{ "nvim-tree/nvim-web-devicons" }, --icons for stuffs

	{ "windwp/nvim-autopairs", event = "BufEnter", config = true }, --bracket pairs
	{ "windwp/nvim-ts-autotag", event = "BufEnter", config = true }, -- other auto pairs (html for example)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {

			{
				"nvim-telescope/telescope-fzf-native.nvim",
				-- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				build = "make",
			},
		},
		lazy = false,
		keys = {
			{ "<c-p>", "<cmd>Telescope fd<cr>", desc = "Find File" },
			{ "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Grep Word" },
			-- { "<leader>th", "<cmd>Telescope colorscheme<cr>", desc = "Theme" },
			{ "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "Help" },
			{ "<leader>ts", "<cmd>Telescope symbols<cr>", desc = "Symbols" },
			{ "<leader>tt", "<cmd>Telescope builtin<cr>", desc = "Telescope Builtins" },
		},
		opts = {
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
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("fzf")
			-- require("telescope.builtin").symbols({ sources = { "math", "latex", "nerd" } })
		end,
	}, --telescope
	-- [[ { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- fast sorter for telescope ]]
	{
		"numToStr/Comment.nvim",
		event = "BufEnter",
		--configure later?
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = true,
	}, -- Easily comment stuff

	-- git integration
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		-- keys = {
		-- 	{ "<leader>g", "<cmd>Gitsigns diffthis<cr>", desc = "Git Diff" },
		-- 	{
		-- 		"<c-g>",
		-- 		function()
		-- 			local gitsigns = require("gitsigns")
		-- 			gitsigns.next_hunk()
		-- 			vim.schedule(function()
		-- 				gitsigns.preview_hunk_inline()
		-- 			end)
		-- 		end,
		-- 		desc = "Preview next hunk",
		-- 	},
		-- },
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

	-- UI
	{ "stevearc/dressing.nvim" }, -- styling for lsp rename and code actions
	{
		"nvim-tree/nvim-tree.lua",
		event = "BufEnter",
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

			{ "<leader>gg", ":Git<CR>", desc = "Git summary" },
			{ "<leader>gc", ":Git commit<CR>", desc = "Git commit" },
			{ "<leader>gp", ":Git push<CR>", desc = "Git push" },
			{ "<leader>gd", ":Gdiffsplit<CR>", desc = "Git diff" },

			{ "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
			{ "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "Git log" },
		},
	},
}
