local ls = require("luasnip")
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local as = require("snippets.utils").as
local get_visual = require("snippets.utils").get_visual
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {

	----- TEXT FORMAT -----
	as({ trig = "fi", dscr = "Italic" }, fmta("*<>*", { d(1, get_visual) })),
	as({ trig = "fb", dscr = "Bold" }, fmta("**<>**", { d(1, get_visual) })),
	as({ trig = "fk", dscr = "Code" }, fmta("`<>`", { d(1, get_visual) })),
	as({ trig = "fn", dscr = "Inline math" }, fmta("$<>$", { d(1, get_visual) })),
	as({ trig = "en", dscr = "Math" }, fmta("$$<>$$", { d(1, get_visual) })),
	-----------------------

	----- ENVIRONMENTS -----
	-- as({ trig = "ek", dscr = "Code environment" }, "verbatim"),
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
	-- env_snippet({ trig = "en", dscr = "Equation environment" }, "equation"),
	-- env_snippet({ trig = "ei", dscr = "Itemize environment" }, "itemize"),
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
