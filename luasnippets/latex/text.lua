local ls = require("luasnip")
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local as = require("snippets.utils").as
local in_any_mathzone = require("snippets.utils").in_any_mathzone
local get_visual = require("snippets.utils").get_visual
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	----- TEXT FORMAT -----
	as({ trig = "fj", dscr = "Text" }, fmta("\\text{<>}", { d(1, get_visual) })),
	as({ trig = "fl", dscr = "Italic" }, fmta("\\textit{<>}", { d(1, get_visual) })),
	as({ trig = "fb", dscr = "Bold" }, fmta("\\textbf{<>}", { d(1, get_visual) })),
	as({ trig = "fk", dscr = "Code" }, fmta("\\texttt{<>}", { d(1, get_visual) })),
	as({ trig = "fn", dscr = "Inline math" }, fmta("$<>$", { d(1, get_visual) })),
	-----------------------
	----- SCRIPTS -----
	as({ trig = "ss", dscr = "Subscript", wordTrig = false }, fmta("_{<>}", { i(0) }), { condition = in_any_mathzone }),
	as(
		{ trig = "sd", dscr = "Vert subscript", wordTrig = false },
		fmta("_{\\mathrm{<>}}", { i(0) }),
		{ condition = in_any_mathzone }
	),
	as(
		{ trig = "su", dscr = "Superscript", wordTrig = false },
		fmta("^{<>}", { i(0) }),
		{ condition = in_any_mathzone }
	),
	-------------------

	----- HEADERS -----
	as({ trig = "h1", dscr = "Top-level section" }, fmta([[\section{<>}]], { i(1) }), { condition = line_begin }),
	as({ trig = "h2", dscr = "Subsection" }, fmta([[\subsection{<>}]], { i(1) }), { condition = line_begin }),
	as({ trig = "h3", dscr = "Sub-subsection" }, fmta([[\subsubsection{<>}]], { i(1) }), { condition = line_begin }),
	as({ trig = "ex", dscr = "Exercise" }, fmta([[\section{Exercise <>}]], { i(1) }), { condition = line_begin }),
	-----------------
}