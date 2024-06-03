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
				-- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				build = "make",
			},
			"nvim-telescope/telescope-ui-select.nvim",
			"piersolenski/telescope-import.nvim",
		},
		cmd = "Telescope",
		keys = {
			{ "<c-p>", "<cmd>Telescope fd<cr>", desc = "Find file" },
			{ "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Telescope: Grep word" },
			{ "<leader>tw", "<cmd>Telescope live_grep<cr>", desc = "Telescope: Grep word" },
			{ "<leader>tc", "<cmd>Telescope colorscheme<cr>", desc = "Telescope: Theme" },
			{ "<leader>tj", "<cmd>Telescope jumplist<cr>", desc = "Telescope: Jumplist" },
			{ "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "Telescope: Help" },
			{ "<leader>ts", "<cmd>Telescope symbols<cr>", desc = "Telescope: Symbols" },
			{ "<leader>tm", "<cmd>Telescope keymaps<cr>", desc = "Telescope: Keymaps" },
			{ "<leader>tb", "<cmd>Telescope buffers<cr>", desc = "Telescope: Buffers" },
			{ "<leader>tt", "<cmd>Telescope builtin<cr>", desc = "Telescope: Builtins" },
			{ "<leader>ti", "<cmd>Telescope import<cr>", desc = "Telescope: Import" },
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
				extensions = {
					import = {
						-- Add imports to the top of the file keeping the cursor in place
						insert_at_top = false,
						-- Support additional languages
						custom_languages = {
							{
								-- The regex pattern for the import statement
								regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
								-- The Vim filetypes
								filetypes = { "vue" },
								-- The filetypes that ripgrep supports (find these via `rg --type-list`)
								extensions = { "js", "ts" },
							},
						},
					},
				},
			}
		end,
		config = function(_, opts)
			local ts = require("telescope")
			ts.setup(opts)
			ts.load_extension("fzf")
			ts.load_extension("import")
			-- require("telescope.builtin").symbols({ sources = { "math", "latex", "nerd" } })
		end,
	},
	-- },
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		--configure later?
		-- dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = true,
	}, -- Easily comment stuff
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
	{
		"luckasRanarison/tailwind-tools.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			conceal = {
				enabled = true,
				min_length = "40",
			},
		},
	},
}
