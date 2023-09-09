return {
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		dependencies = { "nvim-lua/plenary.nvim" },

		-- keys = {
		-- 	{ "<localleader>nr", "<cmd>Neorg return<cr>", desc = "Neorg return" },
		-- },

		opts = {
			load = {
				["core.defaults"] = {}, -- Loads default behaviour
				["core.concealer"] = {}, -- Adds pretty icons to your documents
				["core.summary"] = {}, -- Creates links to all files in any workspace
				["core.completion"] = {
					config = {
						engine = "nvim-cmp",
						-- 	name = "[Neorg]",
					},
				},
				["core.dirman"] = { -- Manages Neorg workspaces
					config = {
						workspaces = {
							notes = "~/Notes",
						},
						default_workspace = "notes",
					},
				},
			},
		},
	},
}
