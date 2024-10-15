local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local as = require("snippets.utils").as
local in_tex_env = require("snippets.utils").in_tex_env
local in_any_mathzone = require("snippets.utils").in_any_mathzone
local get_visual = require("snippets.utils").get_visual

return {
	as(
		{ trig = "%", dscr = "Percent" },
		fmta("\\%<>", {
			i(0),
		})
	),

	as({ trig = "rr", dscr = "Right Arrow" }, fmta("\\rightarrow <>", { i(0) }), { condition = in_any_mathzone }),
	as({ trig = "ll", dscr = "Left Arrow" }, fmta("\\leftarrow <>", { i(0) }), { condition = in_any_mathzone }),

	as(
		{ trig = "([^%a])ff", dscr = "Fraction", regTrig = true, wordTrig = false },
		fmta("\\frac{<>}{<>}", { i(1), i(2) }),
		{ condition = in_any_mathzone }
	),

	as(
		{ trig = "([^%a])mm", dscr = "Math", regTrig = true, wordTrig = false },
		fmta("<>$<>$", {
			f(function(_, snip)
				return snip.captures[1]
			end),
			d(1, get_visual),
		})
	),

	as(
		{ trig = "sm", dscr = "Sum" },
		fmta([[\sum_{<>}^{<>}{<>}]], { i(1, "from"), i(2, "to"), i(3) }),
		{ condition = in_any_mathzone }
	),

	as(
		{ trig = "flr", dscr = "Floor", wordTrig = false },
		fmta("\\lfloor{<>}\\rfloor", { i(1) }),
		{ condition = in_any_mathzone }
	),

	as(
		{ trig = "sr", dscr = "Square root", wordTrig = false },
		fmta("\\sqrt{<>}", { i(0) }),
		{ condition = in_any_mathzone }
	),

	s(
		{ trig = "it", dscr = "Let" },
		fmta([[\item <>]], {
			i(1),
		}),
		{
			condition = function()
				return in_tex_env("itemize")
			end,
		}
	),

	s(
		{ trig = "let", dscr = "Let" },
		fmta([[\item Let $<>$ be <>.]], {
			i(1, "{variable}"),
			i(2, "{description}"),
		}),
		{
			condition = function()
				return in_tex_env("itemize")
			end,
		}
	),
	-------------------
}
