-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	"nvim-neo-tree/neo-tree.nvim",
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
		{ "<c-n>", ":Neotree toggle reveal<CR>", { desc = "NeoTree toggle" } },
	},
}
