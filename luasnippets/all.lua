local ls = require("luasnip")
local d = ls.dynamic_node
local as = require("snippets.utils").as
local get_visual = require("snippets.utils").get_visual
local in_ts_node_type = require("snippets.utils").in_ts_node_type

local function in_comment_node()
	return in_ts_node_type("comment")
end

return {
	as({ trig = "fj", dscr = "Italic", condition = in_comment_node }, fmt("*{}*", { d(1, get_visual) })),
	as({ trig = "jf", dscr = "Bold", condition = in_comment_node }, fmt("**{}**", { d(1, get_visual) })),
	as({ trig = "fk", dscr = "Code", condition = in_comment_node }, fmt("`{}`", { d(1, get_visual) })),
	as({ trig = "fm", dscr = "Inline math", condition = in_comment_node }, fmt("${}$", { d(1, get_visual) })),
}
