local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local as = require("snippets.utils").as
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local env_snippet = function(args, name)
	return as(
		args,
		fmta(
			string.format(
				[[
      \begin{%s}
          <>
      \end{%s}
    ]],
				name,
				name
			),
			{ i(0) }
		),
		{ condition = line_begin }
	)
end

return {
	--- ENVIRONMENTS -----
	env_snippet({ trig = "ek", dscr = "Code environment" }, "verbatim"),
	env_snippet({ trig = "ei", dscr = "Itemize environment" }, "itemize"),
	env_snippet({ trig = "eI", dscr = "Enumerate environment" }, "enumerate"),
	env_snippet({ trig = "sln", dscr = "Solution environment" }, "sol"),
	env_snippet({ trig = "eqn", dscr = "Equation environment" }, "equation"),
	as({ trig = "qq", descr = "Equation environment" }, fmta("\\[ <> \\]", { i(0) }), { condition = line_begin }),
	as(
		{ trig = "qs", descr = "Aligned Equation environment" },
		fmta(
			[[\[
\begin{aligned}
  <>
\end{aligned}
\] ]],
			{
				i(0),
			}
		),
		{ condition = line_begin }
	),

	as(
		{ trig = "etb", dscr = "Tabular environment" },
		fmta(
			[[
	       \begin{tabular}{ |c|c|c| }
	         \hline
	         <>       & <>       & <>       \\
	         \hline
	         <>       &          &          \\
	         <>       &          &          \\
	         <>       &          &          \\
	         \hline
	       \end{tabular}
	   ]],
			{
				i(1, "Column 1"),
				i(2, "Column 2"),
				i(3, "Column 3"),
				i(4, "Row 1"),
				i(5, "Row 2"),
				i(6, "Row 3"),
			}
		)
	),

	as(
		{ trig = "ev", dscr = "Environment" },
		fmta(
			[[
	     \begin{<>}
	         <>
	     \end{<>}
	   ]],
			{
				i(1),
				i(2),
				rep(1), -- this node repeats insert node i(1)
			}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "hr", dscr = "Hyprref" },
		fmta([[\href{<>}{<>}]], {
			i(1, "url"),
			i(2, "display name"),
		})
	),
	------------------------
}
