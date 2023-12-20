return {
	{
		"jakewvincent/mkdnflow.nvim",
		lazy = false,
		opts = {
			to_do = {
				symbols = { " ", "~", "X" },
			},
			links = {
				implicit_extension = nil,
				transform_explicit = false,
				transform_implicit = false,
			},
			modules = {
				cmp = true,
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

		keys = {
			{
				"<CR>",
				-- Follow a link, but don't create one if there isn't one
				function()
					local flow = require("mkdnflow")

					-- Copied + modified from the source code for followLink()
					-- https://github.com/jakewvincent/mkdnflow.nvim/blob/main/lua/mkdnflow/links.lua
					local link = flow.links.getLinkUnderCursor()

					if not link then -- try to find another link on the line
						local cur_line = tostring(vim.api.nvim_get_current_line())
						local link_regex = vim.regex("\\[.*\\]") -- regex for markdown links
						local col = link_regex:match_str(cur_line)

						if col then
							-- go to the col where we found a link
							vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col })
							link = flow.links.getLinkUnderCursor()
						end

						if not link or not col then -- still couldn't find a link
							vim.api.nvim_echo({ { "No link below the cursor", "WarningMsg" } }, true, {})
							return
						end
					end

					-- push to jumplist
					vim.cmd([[normal! m`]])

					-- follow the link
					local path, anchor = flow.links.getLinkPart(link, "source")
					flow.paths.handlePath(path, anchor)

					-- push to jumplist
					vim.cmd([[normal! m`]])
				end,
				mode = "n",
				desc = "Follow Link",
				ft = { "markdown" },
			},
		},
	},
	{ "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
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
