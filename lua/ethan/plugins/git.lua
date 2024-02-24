return {
	-- { "sindrets/diffview.nvim", opts = {} },

	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			-- OR 'ibhagwan/fzf-lua',
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},

		keys = {
			{ "<leader>op", "<cmd>Octo pr list<CR>", desc = "Octo: List PRs" },
		},
	},
	{
		"tpope/vim-fugitive",
		event = "VimEnter",
		config = function()
			vim.api.nvim_create_user_command("ToggleFugitive", function()
				-- see if there is already a buffer with the fugitive file type
				local buffers = vim.api.nvim_list_bufs()
				local fugitive_buffer_found = false
				for _, buf in ipairs(buffers) do
					local bufname = vim.api.nvim_buf_get_name(buf)
					if bufname:match("fugitive://") then
						vim.api.nvim_buf_delete(buf, { force = true })
						fugitive_buffer_found = true
						break
					end
				end

				if not fugitive_buffer_found then
					vim.cmd(":vsp")
					vim.cmd(":Git ++curwin")
				end
			end, {})
		end,
		keys = {
			{ "<C-b>", "<cmd>ToggleFugitive<CR>", desc = "Git: Summary" },
			{ "<leader>gg", "<cmd>ToggleFugitive<CR>", desc = "Git: Summary" },
			{ "<leader>gc", ":Git commit<CR>", desc = "Git: Commit" },
			{ "<leader>gp", ":Git push<CR>", desc = "Git: Push" },
			{ "<leader>gd", ":Gdiffsplit<CR>", desc = "Git: Diff" },
			{ "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git: Branches" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git: Status" },
			{ "<leader>gl", "<cmd>Gllog<CR>", desc = "Git: Log" },
		},
	},
}
