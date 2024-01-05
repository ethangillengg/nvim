return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		ft = "markdown",
		cmd = { "ObsidianQuickSwitch", "ObsidianToday" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			-- "folke/zen-mode.nvim",
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
					["c"] = { char = "󱋬", hl_group = "ObsidianTodoCancelled" }, -- cancelled
				},
				hl_groups = {
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianTodoStarted = { bold = true, fg = "#f7d26c" },
					ObsidianTodoDone = { bold = true, fg = "#89ddff" },
					ObsidianTodoAmbiguous = { bold = true, fg = "#c792ea" },
					ObsidianTodoCancelled = { bold = true, fg = "#ff5370" },
				},
			},
			follow_url_func = function(url)
				local this_os = vim.loop.os_uname().sysname

				if this_os == "Linux" then
					vim.fn.jobstart({ "xdg-open", url })
				elseif this_os == "Darwin" then
					vim.fn.jobstart({ "open", url })
				elseif this_os == "Windows_NT" then
					vim.fn.jobstart({ "cmd.exe", "/c", "start", url })
				end
			end,
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
						local bufnr = 0 -- current buf
						local lang = "markdown_inline" -- use the inline parser
						local query_string = "(link_text) @target"

						local query = vim.treesitter.query.parse(lang, query_string)
						local cur_node = vim.treesitter.get_node({ lang = lang })
						local cur_row = vim.api.nvim_win_get_cursor(bufnr)[1] - 1 -- 0-indexed row

						-- iterate over matching nodes in tree on the row of the cursor
						for _, node in query:iter_captures(cur_node, bufnr, cur_row, cur_row + 1) do
							-- go to the node
							local _, node_col = node:range()
							vim.api.nvim_win_set_cursor(bufnr, { cur_row + 1, node_col - 1 })
							vim.cmd(":ObsidianFollowLink")
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
	{
		"jakewvincent/mkdnflow.nvim",
		ft = { "markdown" },
		opts = {
			to_do = {
				symbols = { " ", "~", "x", "a", "c" }, -- see MkdnToggleToDo
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
}
