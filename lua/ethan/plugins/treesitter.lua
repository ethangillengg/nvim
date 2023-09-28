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
				"jsdoc",
				"rust",
				"yaml",
				"nix",
				"glsl",
			},
			sync_install = false,
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = { "" }, -- list of language that will be disabled
				additional_vim_regex_highlighting = true,
			},
			autopairs = {
				enable = true,
			},
			indent = { enable = true, disable = { "yaml" } },
			--rainbow for bracket pairs
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	-- { "nvim-treesitter/nvim-treesitter-context", event = "BufEnter" },
}
