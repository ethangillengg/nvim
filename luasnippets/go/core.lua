local ls = require("luasnip")
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local as = require("snippets.utils").as
local get_visual = require("snippets.utils").get_visual
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {

	----- TEXT FORMAT -----
	s(
		{ trig = "err", dscr = "Error Check" },
		fmta(
			[[
	if <> != nil {
    <>
	}
	]],
			{
				i(1, "err"),
				i(2, "panic(err)"),
			},
			{ condition = line_begin }
		)
	),
}
