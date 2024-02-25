local checkbox_types = {
	[" "] = { char = "󰄱", hl_group = "ObsidianTodo" }, -- Not Done
	["i"] = { char = "󰐖", hl_group = "ObsidianTodoStarted" }, -- In Progress
	["x"] = { char = "󰄲", hl_group = "ObsidianTodoDone" }, -- Done
	["c"] = { char = "󱋬", hl_group = "ObsidianTodoCancelled" }, -- Cancelled
	["a"] = { char = "󰞋", hl_group = "ObsidianTodoAmbiguous" }, -- Ambiguous
}

return {
	{
		"epwalsh/obsidian.nvim",
		ft = "markdown",
		version = "*", -- recommended, use latest release instead of latest commit
		cmd = { "ObsidianQuickSwitch", "ObsidianToday" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		init = function()
			local set_header_hl = function(level, hl_group)
				vim.api.nvim_set_hl(0, "@markup.heading." .. level .. ".markdown", hl_group)
				vim.api.nvim_set_hl(0, "@markup.heading." .. level .. ".marker.markdown", hl_group)
			end
			set_header_hl("1", { link = "Function" })
			set_header_hl("2", { link = "Constant" })
			set_header_hl("3", { link = "Identifier" })
			set_header_hl("4", { link = "Operator" })
			set_header_hl("5", { link = "Keyword" })
		end,
		opts = {
			workspaces = {
				{
					name = "notes",
					path = "~/Notes",
				},
			},
			notes_subdir = "Inbox",
			completion = {
				min_chars = 0,
				prepend_note_path = false,
			},
			ui = {
				enable = true, -- set to false to disable all additional syntax features
				checkboxes = checkbox_types,
				hl_groups = {
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianTodoStarted = { bold = true, fg = "#f7d26c" },
					ObsidianTodoDone = { bold = true, fg = "#89ddff" },
					ObsidianTodoAmbiguous = { bold = true, fg = "#c792ea" },
					ObsidianTodoCancelled = { bold = true, fg = "#ff5370" },
				},
			},
			note_frontmatter_func = function(note)
				local out = { aliases = note.aliases, tags = note.tags }
				-- `note.metadata` contains any manually added fields in the frontmatter.
				-- So here we just make sure those fields are kept in the frontmatter.
				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end
				return out
			end,
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

				-- 2024 February 25th, 12:45 -> 2402251245
				return tostring(os.date("%y%m%d%H%M") .. "-" .. suffix)
			end,

			image_name_func = function()
				-- 2024 February 25th, 12:45 -> 2402251245
				return string.format("%s-", os.time())
			end,
			attachments = {
				img_folder = "img",
			},

			templates = {
				subdir = "_t",
				date_format = "%Y-%m-%d-%a",
				time_format = "%H:%M",
				substitutions = {
					date = function()
						return tostring(os.date("%y%m%d%H%M") .. "-")
					end,
				},
			},
		},

		keys = {
			{ "<leader>on", ":ObsidianNew ", desc = "Note: New note" },
			{ "ol", "<cmd>:ObsidianLink<CR>", mode = "v", desc = "Note: Link selection" },
			{ "<leader>ot", "<cmd>:ObsidianTemplate<CR>", desc = "Note: Insert template" },
			{ "<C-p>", "<cmd>:ObsidianQuickSwitch<CR>", desc = "Note: Find Note", ft = "markdown" },
			{ "<leader>of", "<cmd>:ObsidianQuickSwitch<CR>", desc = "Note: Find Note" },
			{ "<leader>os", "<cmd>:ObsidianSearch<CR>", desc = "Note: Grep notes", ft = "markdown" },
			{ "<leader>ob", "<cmd>:ObsidianBacklinks<CR>", desc = "Note: Obsidian backlinks", ft = "markdown" },
			{ "<leader>og", "<cmd>:ObsidianTags<CR>", desc = "Note: Search tags" },
			{ "<leader>oi", "<cmd>:ObsidianPasteImg<CR>", desc = "Note: Paste image", ft = "markdown" },
			{ "<leader>or", "<cmd>:ObsidianRename<CR>", desc = "Note: Rename", ft = "markdown" },
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
				desc = "Note: Follow Link",
				ft = { "markdown" },
			},
		},
	},
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		ft = { "markdown" },
		build = "deno task --quiet build:fast",
		opts = {
			app = { "qutebrowser", "--target", "window" },
		},
		config = function(_, opts)
			require("peek").setup(opts)
			-- refer to `configuration to change defaults`
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,

		keys = {
			{
				"<leader>op",
				":PeekOpen<CR>",
				desc = "Notes: Markdown preview",
				ft = { "markdown" },
			},
		},
	},
	{
		"bullets-vim/bullets.vim",
		ft = { "markdown" },
		config = function()
			vim.g.bullets_set_mappings = 0
			vim.g.bullets_checkbox_markers = " ix"
		end,
		keys = {
			{
				"<C-]>",
				"<cmd>ToggleCheckbox<CR>",
				desc = "Toggle checkbox",
				ft = { "markdown" },
			},
			{
				">",
				"<cmd>BulletDemote<CR>",
				desc = "Demote Bullet",
				ft = { "markdown" },
			},
			{
				"<",
				"<cmd>BulletPromote<CR>",
				desc = "Promote Bullet",
				ft = { "markdown" },
			},
		},
	},
	{
		"jbyuki/nabla.nvim",
		ft = { "markdown" },
		config = function()
			local nb = require("nabla")

			-- fix since nabla sets wrap to off
			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				pattern = { "*.md" },
				callback = function()
					local wrap = vim.o.wrap
					nb.enable_virt({ autogen = false })
					if wrap then
						vim.cmd("set wrap")
					end
				end,
			})
		end,
		keys = {
			{
				"<S-k>",
				function()
					require("nabla").popup({
						border = "rounded",
						title = "LaTeX",
					})
				end,
				desc = "Show LaTeX preview",
				ft = { "markdown" },
			},

			{
				"<C-k>",
				function()
					-- check if wrap was on
					local wrap = vim.o.wrap
					local conceallevel = vim.o.conceallevel
					require("nabla").toggle_virt()
					-- fix since nabla sets wrap to off
					if wrap then
						vim.cmd("set wrap")
					end

					if conceallevel == 2 then
						vim.cmd("set conceallevel=0")
					else
						vim.cmd("set conceallevel=2")
					end
				end,
				desc = "Toggle virtual LaTeX",
				ft = { "markdown" },
			},
		},
	},
	-- {
	-- 	"3rd/image.nvim",
	-- 	-- enabled = false,
	-- 	opts = {
	-- 		backend = "kitty",
	-- 		integrations = {
	-- 			markdown = {
	-- 				enabled = true,
	-- 				clear_in_insert_mode = true,
	-- 				download_remote_images = true,
	-- 				only_render_image_at_cursor = false,
	-- 				filetypes = { "markdown" },
	-- 			},
	-- 		},
	--
	-- 		max_width = nil,
	-- 		max_height = nil,
	-- 		max_width_window_percentage = nil,
	-- 		max_height_window_percentage = 50,
	-- 		window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
	-- 	},
	-- },
}
