return {
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }, --treesitter
	{ "nvim-lua/popup.nvim" }, --other api for stuffs
	{ "nvim-lua/plenary.nvim" }, --api for stuffs
	{ "kyazdani42/nvim-web-devicons" }, --icons for stuffs

	{ "windwp/nvim-autopairs", config = true }, --bracket pairs
	{ "windwp/nvim-ts-autotag", config = true }, -- other auto pairs (html for example)

	{
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				prompt_prefix = "   ",
				selection_caret = "❯ ",
				sorting_strategy = "ascending",
				layout_config = {
					prompt_position = "top",
				},
			},
		},
	}, --telescope
	--[[ { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- fast sorter for telescope ]]

	{
		"numToStr/Comment.nvim",
		--configure later?
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = true,
	}, -- Easily comment stuff

	{
		"voldikss/vim-floaterm",
		config = function()
			vim.g.floaterm_height = 0.99
			vim.g.floaterm_width = 0.99
		end,
	},

	-- git integration
	{
		"lewis6991/gitsigns.nvim",
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
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				delay = 0,
				virt_text_priority = 0,
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			},
		},
	},

	-- keymaps
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},

	-- UI
	{ "stevearc/dressing.nvim" }, -- styling for lsp rename and code actions

	-- Lets you use git and file managers
	{
		"is0n/fm-nvim",
		keys = {
			-- Lf + lazygit mappings (fm-nvim)
			-- map("n", "<leader>d", ":Gitui<cr>")
			{ "<leader>d", "<cmd>Gitui<cr>", desc = "Open gitui" },
			{
				"<leader>e",
				function()
					-- command to start lf at the current file
					require("fm-nvim").Lf(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
				end,
				desc = "Lf at current file",
			},
		},
		opts = {
			ui = {
				float = {
					height = 1,
					width = 0.9,
				},
			},
		},
	},
}
