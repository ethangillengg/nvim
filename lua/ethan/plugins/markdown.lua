return {
	-- {
	-- 	"epwalsh/obsidian.nvim",
	-- 	lazy = true,
	-- 	event = {
	-- 		"BufReadPre /home/ethan/Notes/Obsidian/**.md",
	-- 		"BufNewFile /home/ethan/Notes/Obsidian/**.md",
	-- 	},
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	--
	-- 	cmd = { "ObsidianQuickSwitch" },
	-- 	keys = {
	-- 		-- { "gd", "<cmd>ObsidianFollowLink<cr>", desc = "Follow Obsidian Link" },
	-- 		{ "<enter>", "<cmd>ObsidianFollowLink<cr>", desc = "Follow Obsidian Link" },
	-- 		{ "<leader>to", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find Note" },
	-- 	},
	-- 	opts = {
	-- 		-- Obsidian automatically uses the first workspace as default
	-- 		workspaces = {
	-- 			{
	-- 				name = "personal",
	-- 				path = "~/Notes/Obsidian/Personal",
	-- 			},
	-- 			{
	-- 				name = "work",
	-- 				path = "~/Notes/Obsidian/Work",
	-- 			},
	-- 		},
	-- 		completion = {
	-- 			-- Start cmp immediately
	-- 			min_chars = 1,
	-- 		},
	--
	-- 		follow_url_func = function(url)
	-- 			-- Open the URL in the default web browser.
	-- 			vim.fn.jobstart({ "xdg-open", url })
	-- 		end,
	-- 	},
	-- },

	{
		"jakewvincent/mkdnflow.nvim",
		config = function()
			require("mkdnflow").setup({
				-- Config goes here; leave blank for defaults
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}
