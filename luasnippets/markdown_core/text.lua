local ls = require("luasnip")
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local as = require("snippets.utils").as
local get_visual = require("snippets.utils").get_visual
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {

	----- TEXT FORMAT -----
	s({ trig = "fj", dscr = "Italic", snippetType = "autosnippet" }, fmta("*<>*", { d(1, get_visual) })),
	as({ trig = "jf", dscr = "Bold" }, fmta("**<>**", { d(1, get_visual) })),
	as({ trig = "fk", dscr = "Code" }, fmta("`<>`", { d(1, get_visual) })),
	as({ trig = "fm", dscr = "Inline math" }, fmta("$<>$", { d(1, get_visual) })),
	-----------------------

	-------- OTHER --------
	as(
		{ trig = "lk", dscr = "Link" },
		fmta("[<>](<>)", {
			i(1, "display text"),
			i(2, "url"),
		})
	),
	-----------------------

	----- ENVIRONMENTS -----
	as({ trig = "en", dscr = "Math" }, fmta("$$<>$$", { i(1) }), { condition = line_begin }),
	as(
		{ trig = "ek", dscr = "Code fenced" },
		fmta(
			[[ 
  ```<>
  <>
  ```
  ]],
			{
				i(1, "lang"),
				i(2, "code"),
			},
			{ condition = line_begin }
		)
	),
	------------------------

	----- HEADERS -----
	as({ trig = "h1", dscr = "Section" }, fmta("# <>", { i(0) }), { condition = line_begin }),
	as({ trig = "h2", dscr = "Subsection" }, fmta("## <>", { i(0) }), { condition = line_begin }),
	as({ trig = "h3", dscr = "Sub-subsection" }, fmta("### <>", { i(0) }), { condition = line_begin }),
	-------------------

	----- LISTS -----
	as({ trig = "it", dscr = "List item" }, fmta("- <>", { i(0) }), { condition = line_begin }),
	as({ trig = "ic", dscr = "List checkbox" }, fmta("- [ ] <>", { i(0) }), { condition = line_begin }),
	-----------------
}
