return {
	{
		"jakewvincent/mkdnflow.nvim",
		ft = { "markdown" },
		opts = {
			to_do = {
				symbols = { " ", "~", "x", "a", "!" }, -- see MkdnToggleToDo
				not_started = " ",
				in_progress = "~",
				complete = "x",
			},
			mappings = {
				MkdnEnter = false,
				MkdnTab = false,
				MkdnSTab = false,
				MkdnNextLink = false,
				MkdnPrevLink = false,
				MkdnNextHeading = { "n", "]]" },
				MkdnPrevHeading = { "n", "[[" },
				MkdnGoBack = false,
				MkdnGoForward = false,
				MkdnCreateLink = false, -- see MkdnEnter
				MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>p" }, -- see MkdnEnter
				MkdnFollowLink = false, -- see MkdnEnter
				MkdnDestroyLink = { "n", "<M-CR>" },
				MkdnTagSpan = { "v", "<M-CR>" },
				MkdnMoveSource = { "n", "<F2>" },
				MkdnYankAnchorLink = { "n", "yaa" },
				MkdnYankFileAnchorLink = { "n", "yfa" },
				MkdnIncreaseHeading = { "n", "+" },
				MkdnDecreaseHeading = { "n", "-" },
				MkdnToggleToDo = { { "n", "v" }, "<C-]>" },
				MkdnNewListItem = { "i", "<CR>" }, -- seee MkdnEnter
				MkdnNewListItemBelowInsert = { "n", "o" },
				MkdnNewListItemAboveInsert = { "n", "O" },
				MkdnExtendList = false,
				MkdnUpdateNumbering = { "n", "<leader>nn" },
				MkdnTableNextCell = { "i", "<Tab>" },
				MkdnTablePrevCell = { "i", "<S-Tab>" },
				MkdnTableNextRow = false,
				MkdnTablePrevRow = { "i", "<M-CR>" },
				MkdnTableNewRowBelow = { "n", "<leader>ir" },
				MkdnTableNewRowAbove = { "n", "<leader>iR" },
				MkdnTableNewColAfter = { "n", "<leader>ic" },
				MkdnTableNewColBefore = { "n", "<leader>iC" },
				MkdnFoldSection = false, -- use default fold binds
				MkdnUnfoldSection = false, -- use default fold binds
			},
		},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		ft = "markdown",
		cmd = { "ObsidianQuickSwitch", "ObsidianToday" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"folke/zen-mode.nvim",
			{
				"iamcco/markdown-preview.nvim",
				cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
				build = "cd app && npm install",
				init = function()
					vim.g.mkdp_filetypes = { "markdown" }
				end,
			},
		},
		opts = {
			workspaces = {
				{
					name = "notes",
					path = "~/Notes",
				},
			},
			completion = {
				min_chars = 0,
			},
			ui = {
				enable = true, -- set to false to disable all additional syntax features
				checkboxes = {
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
					["~"] = { char = "󰐖", hl_group = "ObsidianTodoStarted" }, -- done
					["x"] = { char = "󰄲", hl_group = "ObsidianTodoDone" }, -- done
					["a"] = { char = "󰞋", hl_group = "ObsidianTodoAmbiguous" }, -- ambiguous
					["!"] = { char = "󱋬", hl_group = "ObsidianTodoCancelled" }, -- cancelled
				},
				hl_groups = {
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianTodoStarted = { bold = true, fg = "#f7d26c" },
					ObsidianTodoDone = { bold = true, fg = "#89ddff" },
					ObsidianTodoAmbiguous = { bold = true, fg = "#c792ea" },
					ObsidianTodoCancelled = { bold = true, fg = "#ff5370" },
				},
			},
		},

		keys = {
			{
				"<leader>ot",
				function()
					vim.cmd(":ObsidianToday")
					vim.cmd(":ZenMode")
				end,
				desc = "Daily Note",
			},
			{
				"<leader>of",
				":ObsidianQuickSwitch<CR>",
				desc = "Find Note",
			},
			{
				"<leader>op",
				":ObsidianPasteImg<CR>",
				desc = "Paste Image",
			},
			{
				"<leader>or",
				":MarkdownPreview<CR>",
				desc = "Markdown Preview",
				ft = { "markdown" },
			},
			{
				"<CR>",
				function()
					local cursor_on_markdown_link = require("obsidian").util.cursor_on_markdown_link

					if cursor_on_markdown_link() then -- follow the link
						vim.cmd(":ObsidianFollowLink")
					else -- try to find a link on the line
						local cur_line = tostring(vim.api.nvim_get_current_line())
						local link_regex = vim.regex("\\[.*\\]") -- regex for markdown links
						local col = link_regex:match_str(cur_line)
						print(col)

						if col then
							-- go to the col where we found a link
							vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col })
							vim.cmd(":ObsidianFollowLink") -- follow the link
							return
						end

						vim.api.nvim_echo({ { "No link below the cursor", "WarningMsg" } }, true, {})
					end
				end,
				mode = "n",
				desc = "Follow Link",
				ft = { "markdown" },
			},
		},
	},
}
