--- Find parent node of given type.
---@param node TSNode
---@param type string | nil
---@return TSNode | nil
local function find_parent_node(node, type)
	if node == node:root() then
		return nil
	end
	if node:type() == type or node:type() == nil then
		return node
	end
	return find_parent_node(node:parent(), type)
end

--- Find child node of given type.
---@param node TSNode
---@param node_type string | table
---@return TSNode | nil
local function find_child_node(node, node_type)
	local child = node:child(0)
	while child do
		if type(node_type) == "table" then
			if node_type[child:type()] then
				return child
			end
		else
			if child:type() == node_type then
				return child
			end
		end
		child = child:next_sibling()
	end
	return nil
end

---@class CheckToggleState
---@field value string
---@field node_name string | nil

--- @type  CheckToggleState[]
local box_types = {
	{
		value = " ",
	},
	{
		value = "/",
	},
	{
		value = "x",
	},
	{
		value = "-",
	},
	{
		value = "?",
	},
}

local function toggle_checkbox(checkbox_node, bufnr)
	local box_text = vim.treesitter.get_node_text(checkbox_node, bufnr or 0):sub(1, 3)

	-- find which node is next in the table and use that
	for i, v in pairs(box_types) do
		-- if the state matches the char in the box
		if v.value == box_text:sub(2, 2) then
			-- get the next todo state
			local next_node = box_types[(i % #box_types) + 1]

			local sr, sc = checkbox_node:range()
			local content = { next_node.value }
			-- only replace the todo char within the box
			sc = sc + 1
			vim.api.nvim_buf_set_text(bufnr, sr, sc, sr, sc + 1, content)
		end
	end

	-- list that contains node
	local list_node = find_parent_node(checkbox_node, "list")
	local parent_list = find_parent_node(list_node, "list")
	print(list_node, parent_list)
end

local function find_checkbox(node)
	local item = find_parent_node(node, "list_item")

	if item == nil then
		return
	end

	local box = find_child_node(item, {
		task_list_marker_checked = true,
		task_list_marker_unchecked = true,
		paragraph = true, -- for the extended markdown todo states
	})
	return box
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local select_course = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Choose a course",
			finder = finders.new_table({
				results = {
					"ENCM501 Principles of Computer Architecture",
					"ENSF544: Data Science for Software Engineers",
					"ENCM517 Computer Arithmetic and Computational Complexity",
					"SENG533: Software Performance Evaluation",
					"ENEL500A Capstone",
				},
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					-- print(vim.inspect(selection))
					-- vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		ft = "markdown",
		cmd = { "ObsidianQuickSwitch", "ObsidianToday" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
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
					["/"] = { char = "󰐖", hl_group = "ObsidianTodoStarted" }, -- done
					["x"] = { char = "󰄲", hl_group = "ObsidianTodoDone" }, -- done
					["-"] = { char = "󱋬", hl_group = "ObsidianTodoCancelled" }, -- cancelled
					["?"] = { char = "󰞋", hl_group = "ObsidianTodoAmbiguous" }, -- ambiguous
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
			templates = {
				-- subdir = "_t",
				date_format = "%Y-%m-%d-%a",
				time_format = "%H:%M",
				substitutions = {
					yesterday = function()
						return os.date("%Y-%m-%d", os.time() - 86400)
					end,
					course = function()
						-- return select_course(require("telescope.themes").get_dropdown({}))

						return vim.ui.select({ "tabs", "spaces" }, {
							prompt = "Select tabs or spaces:",
						}, function(choice)
							if choice == "spaces" then
								vim.o.expandtab = true
							else
								vim.o.expandtab = false
							end
						end)
					end,
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
				"ol",
				":ObsidianLink<CR>",
				mode = "v",
				desc = "Link selection",
			},
			{
				"<leader>of",
				":ObsidianQuickSwitch<CR>",
				desc = "Find Note",
			},
			{
				"<leader>os",
				":ObsidianSearch<CR>",
				desc = "Grep Notes",
				ft = { "markdown" },
			},

			{
				"<leader>ob",
				":ObsidianBacklinks<CR>",
				desc = "Obsidian Backlinks",
				ft = { "markdown" },
			},
			{
				"<leader>op",
				":ObsidianPasteImg<CR>",
				desc = "Paste Image",
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
						local cur_node = vim.treesitter.get_node({ lang = lang, ignore_injections = false })

						-- fix for if we are not in an inline block
						if cur_node:type() ~= "inline" then
							cur_node = cur_node:next_sibling()
							cur_node = cur_node:child(0)
							local r, c = cur_node:range()
							cur_node = vim.treesitter.get_node({
								lang = lang,
								ignore_injections = false,
								pos = { r, c },
							})
						end

						local cur_pos = vim.api.nvim_win_get_cursor(bufnr)
						-- 0-index correction
						local cur_row = cur_pos[1] - 1
						local cur_col = cur_pos[2] - 1

						-- iterate over matching nodes in tree on the row of the cursor
						for _, node in query:iter_captures(cur_node, bufnr, cur_row, cur_row + 1) do
							-- go to the node
							local _, node_col = node:range()
							if node_col > cur_col then
								vim.api.nvim_win_set_cursor(bufnr, { cur_row + 1, node_col })
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
					local cur_node = vim.treesitter.get_node({ lang = "markdown" })
					local box = find_checkbox(cur_node)
					print(box)
					if box then
						toggle_checkbox(box, bufnr)
					else
						vim.api.nvim_echo({ { "Item below cursor is not a todo", "WarningMsg" } }, true, {})
					end
				end,
				desc = "Toggle Checkbox",
				ft = { "markdown" },
			},
		},
	},

	{

		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		config = function()
			vim.cmd([[
			    function OpenMarkdownPreview (url)
			       execute "silent ! qutebrowser --target window '" . a:url . "'"
			     endfunction
			     let g:mkdp_browserfunc = 'OpenMarkdownPreview'
           let g:mkdp_auto_close = 1
			   ]])
		end,
		keys = {
			{
				"<leader>p",
				":MarkdownPreviewToggle<CR>",
				desc = "Markdown Preview",
				ft = { "markdown", "md" },
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
	{
		"NFrid/due.nvim",
		ft = { "markdown" },
		opts = {
			pattern_start = "[due:: ",
			pattern_end = "]",
			use_clock_time = true,
			use_seconds = false,
		},
	},
}
