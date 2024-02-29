return {
	-- { "sindrets/diffview.nvim", opts = {} },
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

	{
		"akinsho/git-conflict.nvim",
		version = "*",
		opts = {
			list_opener = "Telescope quickfix",
			default_mappings = {
				ours = "co",
				theirs = "ct",
				none = "c0",
				both = "cb",
				next = "cn",
				prev = "cN",
			},
		},
		config = function(_, opts)
			require("git-conflict").setup(opts)
			vim.api.nvim_set_hl(0, "GitConflictCurrent", { link = "DiffChange" })
			vim.api.nvim_set_hl(0, "GitConflictCurrentLabel", { link = "DiffAdd" })
			vim.api.nvim_set_hl(0, "GitConflictIncoming", { link = "DiffDelete" })
			vim.api.nvim_set_hl(0, "GitConflictIncomingLabel", { link = "ErrorMsg" })
		end,
		keys = {
			{ "<leader>gq", "<cmd>GitConflictListQf<CR>", desc = "Git: Conflicts" },
		},
	},
}
