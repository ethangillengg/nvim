local status_ok, wilder = pcall(require, "wilder")
if not status_ok then
	return
end

wilder.setup({
	modes = { ":", "/", "?" },
	renderer = wilder.popupmenu_renderer({
		pumblend = 20,
	}),
})

wilder.set_option(
	"renderer",
	wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
		highlights = {
			border = "FloatBorder", -- highlight to use for the border
		},
		-- 'single', 'double', 'rounded' or 'solid'
		-- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
		border = "rounded",
	}))
)
