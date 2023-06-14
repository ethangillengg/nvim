return {
	{
		"goolord/alpha-nvim",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			local function button(sc, txt, keybind, keybind_opts)
				local b = dashboard.button(sc, txt, keybind, keybind_opts)
				b.opts.hl_shortcut = "Macro"
				return b
			end

			local icons = require("ethan.icons")

			dashboard.section.header.val = {
				[[                               __                ]],
				[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
				[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
				[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
				[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
				[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
			}
			dashboard.section.buttons.val = {
				button("p", icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
				button("e", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
				button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
				button("t", icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
				button("c", icons.ui.Gear .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
				button("l", icons.misc.Package .. " Plugins", ":Lazy<CR>"),
				button("u", icons.ui.CloudDownload .. " Update", ":Lazy sync<CR>"),
				button("q", icons.ui.SignOut .. " Quit", ":qa<CR>"),
			}
			local function footer()
				-- NOTE: requires the fortune-mod package to work
				-- local handle = io.popen("fortune")
				-- local fortune = handle:read("*a")
				-- handle:close()
				-- return fortune
				return "ethan.gill@ucalgary.ca"
			end

			dashboard.section.footer.val = footer()

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
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "%=", "filename" },
				lualine_x = { "filetype" },
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
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			auto_hide = true,
			-- Set the filetypes which barbar will offset itself for
			sidebar_filetypes = {
				-- Use the default values: {event = 'BufWinLeave', text = nil}
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

	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		config = true,
	},
}
