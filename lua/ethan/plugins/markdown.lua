return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		ft = "markdown",
		cmd = { "ObsidianQuickSwitch", "ObsidianToday" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
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
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. "-" .. suffix
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
						local cur_pos = vim.api.nvim_win_get_cursor(bufnr)
						-- 0-indexe correction
						local cur_row = cur_pos[1] - 1
						local cur_col = cur_pos[2] - 1

						-- iterate over matching nodes in tree on the row of the cursor
						for _, node in query:iter_captures(cur_node, bufnr, cur_row, cur_row + 1) do
							-- go to the node
							local _, node_col = node:range()
							if node_col > cur_col then
								vim.api.nvim_win_set_cursor(bufnr, { cur_row + 1, node_col - 1 })
								vim.cmd(":ObsidianFollowLink")
								return
							end
						end

						vim.api.nvim_echo({ { "No link below the cursor", "WarningMsg" } }, true, {})
					end
				end,
				mode = "n",
				desc = "Follow Link",
				ft = { "markdown" },
			},

			{
				"<C-]>",
				function()
					local bufnr = 0 -- current buf
					local lang = "markdown_inline" -- use the inline parser
					local query_string = "(link_text) @target"
				end,
				desc = "Toggle Checkbox",
				ft = { "markdown" },
			},
		},
	},
	{

		"tadmccorkle/markdown.nvim",
		event = "VeryLazy",
		ft = { "markdown" },

		opts = {
			on_attach = function(bufnr)
				local function toggle(key)
					return "<Esc>gv<Cmd>lua require'markdown.inline'" .. ".toggle_emphasis_visual'" .. key .. "'<CR>"
				end
				local opts = { buffer = bufnr }

				vim.keymap.set({ "n", "i" }, "<M-o>", "<Cmd>MDListItemBelow<CR>", opts)
				vim.keymap.set("x", "<C-b>", toggle("b"), opts)
				vim.keymap.set("x", "<C-i>", toggle("i"), opts)
			end,
		},
	},
}
