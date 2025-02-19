local ls = require("luasnip")
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local as = require("snippets.utils").as
local get_visual = require("snippets.utils").get_visual
local line_begin = require("luasnip.extras.expand_conditions").line_begin
local in_cs_xmlcomment = require("snippets.utils").in_cs_xmlcomment

return {

	as(
		{
			trig = "///",
			dscr = "XML Comment",
			condition = line_begin,
		},
		fmt(
			[[
/// <summary>
/// {}
/// </summary>
	]],
			{
				i(1, ""),
			}
		)
	),

	as({
		trig = "crr",
		dscr = "XML See",
		condition = in_cs_xmlcomment,
	}, fmt('<see cref="{}"/>', { i(1, "") }, {})),

	as({
		trig = "acrr",
		dscr = "XML See Also",
		condition = in_cs_xmlcomment,
	}, fmt('<seealso cref="{}"/>', { i(1, "") }, {})),
}
