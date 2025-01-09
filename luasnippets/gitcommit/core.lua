local ls = require("luasnip")
local d = ls.dynamic_node
local as = require("snippets.utils").as
local get_visual = require("snippets.utils").get_visual

return {
	s({ trig = "fj", dscr = "Italic", snippetType = "autosnippet" }, fmt("*{}*", { d(1, get_visual) })),
	as({ trig = "jf", dscr = "Bold" }, fmt("**{}**", { d(1, get_visual) })),
	as({ trig = "fk", dscr = "Code" }, fmt("`{}`", { d(1, get_visual) })),
	as({ trig = "fm", dscr = "Inline math" }, fmt("${}$", { d(1, get_visual) })),
}
