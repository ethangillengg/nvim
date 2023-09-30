return {
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		opts = {
			api_key_cmd = "gpg --decrypt " .. "C:\\Users\\EGill\\openai.txt.gpg",
		},

		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}
