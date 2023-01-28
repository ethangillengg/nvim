return {
	{ "nvim-lualine/lualine.nvim", opts = { options = { theme = "auto" } } }, --nice line at bottom
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
			require("alpha").setup(dashboard.opts)
		end,
	}, --greeter
}