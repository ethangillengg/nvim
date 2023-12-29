return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")

			---@param sc string Shortcut key.
			---@param txt string Text to display for the button.
			---@param keybind string | function Action to perform when the button is pressed. Either a string or a function.
			---@param keybind_opts table? Options to pass to the keymap function.
			local function button(sc, txt, keybind, keybind_opts)
				local b
				if type(keybind) == "string" then
					b = dashboard.button(sc, txt, keybind, keybind_opts)
				else
					b = dashboard.button(sc, txt, "", keybind_opts)
					b.opts.keymap = {
						"n",
						sc,
						"",
						{
							callback = keybind,
							noremap = true,
							silent = true,
							nowait = true,
						},
					}
				end
				b.opts.hl_shortcut = "Macro"

				return b
			end

			local icons = require("ethan.icons")

			dashboard.section.header.val = {
				[[                                                    ]],
				[[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
				[[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
				[[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
				[[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
				[[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
				[[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
			}

			dashboard.section.buttons.val = {
				button("p", icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
				button("e", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
				-- button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
				-- button("t", icons.ui.Abc .. " Find text", ":Telescope live_grep <CR>"),
				button("n", icons.ui.Note .. " Notes", function()
					local notes_dir

					local this_os = vim.loop.os_uname().sysname
					if this_os == "Linux" or this_os == "Darwin" then
						notes_dir = vim.fn.expand("~/Notes", nil, nil)
					elseif this_os == "Windows_NT" then
						notes_dir = vim.fn.expand("$USERPROFILE/Notes", nil, nil)
					end

					vim.api.nvim_set_current_dir(notes_dir)

					vim.cmd("edit index.md")
				end),
				button("l", icons.misc.Package .. " Plugins", ":Lazy<CR>"),
				button("u", icons.ui.CloudDownload .. " Update", ":Lazy sync<CR>"),

				button("c", icons.ui.Gear .. " Config", function()
					local config_dir

					local this_os = vim.loop.os_uname().sysname
					if this_os == "Linux" or this_os == "Darwin" then
						config_dir = vim.fn.expand("$HOME/.config/nvim", nil, nil)
					elseif this_os == "Windows_NT" then
						config_dir = vim.fn.expand("$LOCALAPPDATA/nvim", nil, nil)
					end

					vim.api.nvim_set_current_dir(config_dir)

					vim.cmd("edit init.lua")
				end),
				button("q", icons.ui.SignOut .. " Quit", ":qa<CR>"),
			}

			-- Print Lazy stats in footer
			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

					dashboard.section.footer.val = " Neovim loaded "
						.. stats.loaded
						.. "/"
						.. stats.count
						.. " plugins in "
						.. ms
						.. "ms"
						.. " 🚀"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})

			dashboard.section.header.opts.hl = "Include"
			dashboard.section.buttons.opts.hl = "Macro"
			dashboard.section.footer.opts.hl = "Type"

			dashboard.opts.opts.noautocmd = true

			return dashboard
		end,
		config = function(_, dashboard)
			-- hide the statusline
			vim.opt_global.laststatus = 0
			require("alpha").setup(dashboard.opts)
		end,
	}, --greeter
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"linrongbin16/lsp-progress.nvim",
		},
		event = "BufReadPost",
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = { "diff", "%=", "filename" },
				lualine_x = { "diagnostics", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "%=", "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		},
		config = true,
	},
	{
		"romgrk/barbar.nvim",
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			auto_hide = true,
			animation = false,
			highlight_visible = true,
			icons = {
				separator = { left = "", right = "" },
			},
			sidebar_filetypes = {
				NvimTree = true,
			},
		},

		keys = {
			{ "<Tab>", ":BufferNext<CR>", desc = "Next buffer" },
			{ "<S-Tab>", ":BufferPrevious<CR>", desc = "Previous buffer" },
			{ "<leader>x", ":BufferClose<CR>", desc = "Close buffer" },
			{ "<leader>X", ":BufferCloseAllButCurrent<CR>", desc = "Close all buffers (except current)" },
		},
	},
}
