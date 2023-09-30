return {
	{
		"ethangillengg/ChatGPT.nvim",
		event = "VeryLazy",
		opts = {
			api_key_cmd = "pass show personal/openai",
		},

		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}
