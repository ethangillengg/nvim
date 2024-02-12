local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local as = require("snippets.utils").as

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
		)
	)
end

return {
	--- ENVIRONMENTS -----
	env_snippet({ trig = "ek", dscr = "Code environment" }, "verbatim"),
	env_snippet({ trig = "en", dscr = "Equation environment" }, "equation"),
	env_snippet({ trig = "ei", dscr = "Itemize environment" }, "itemize"),

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
		)
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
