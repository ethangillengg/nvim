-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	{
		"stevearc/oil.nvim",
		opts = {
			use_default_keymaps = false,
			keymaps = {
				["g?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["<C-s>"] = { "actions.select", opts = { vertical = true } },
				["<C-h>"] = { "actions.select", opts = { horizontal = true } },
				["<C-t>"] = { "actions.select", opts = { tab = true } },
				["<C-c>"] = { "actions.close", mode = "n" },
				["<C-l>"] = "actions.refresh",
				["-"] = { "actions.parent", mode = "n" },
				["_"] = { "actions.open_cwd", mode = "n" },
				["`"] = { "actions.cd", mode = "n" },
				["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
				["gs"] = { "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["g."] = { "actions.toggle_hidden", mode = "n" },
				["g\\"] = { "actions.toggle_trash", mode = "n" },
			},
		},
		keys = {
			{ "<C-e>", "<cmd>Oil<CR>", { desc = "Oil" } },
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		cond = not vim.g.vscode,
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		opts = {
			default_component_configs = {
				git_status = {
					symbols = {
						-- Change type
						added = "+", -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified = "~", -- or "", but this is redundant info if you use git_status_colors on the name
						deleted = "-", -- this can only be used in the git_status source
						renamed = "~", -- this can only be used in the git_status source
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "",
						staged = "",
						conflict = "",
					},
				},
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					with_markers = true,
					expander_highlight = "NeoTreeFileIcon",
				},
				name = {
					use_git_status_colors = false,
				},
			},
			window = {
				position = "right",
				width = 60,
			},
		},
		cmd = "Neotree",
		keys = {
			{ "<C-N>", ":Neotree toggle reveal<CR>", { desc = "NeoTree toggle" } },
		},
	},
}
