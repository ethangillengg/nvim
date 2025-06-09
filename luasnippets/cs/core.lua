local ls = require("luasnip")
local i = ls.insert_node
local as = require("snippets.utils").as
local line_begin = require("luasnip.extras.expand_conditions").line_begin
local in_ts_node_type = require("snippets.utils").in_ts_node_type

local function in_xmlcomment_node()
	return in_ts_node_type("comment") and vim.api.nvim_get_current_line():match("^%s*///") ~= nil
end
return {

	-- 	as(
	-- 		{
	-- 			trig = "///",
	-- 			dscr = "XML Comment",
	-- 			condition = line_begin,
	-- 		},
	-- 		fmt(
	-- 			[[
	-- /// <summary>
	-- /// {}
	-- /// </summary>
	-- 	]],
	-- 			{
	-- 				i(1, ""),
	-- 			}
	-- 		)
	-- 	),

	as({
		trig = "crr",
		dscr = "XML See",
		condition = in_xmlcomment_node,
	}, fmt('<see cref="{}"/>', { i(1, "") }, {})),

	as({
		trig = "acr",
		dscr = "XML See Also",
		condition = in_xmlcomment_node,
	}, fmt('<seealso cref="{}"/>', { i(1, "") }, {})),
}
