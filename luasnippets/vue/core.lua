local ls = require("luasnip")
local i = ls.insert_node
local d = ls.dynamic_node
local as = require("snippets.utils").as
local get_visual = require("snippets.utils").get_visual
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	s(
		{ trig = "computed", dscr = "Vue computed property" },
		fmt(
			[[
const {} = computed<{}>(() => {{
  return {};
}});
]],
			{
				i(1, "val"),
				i(2, "Type"),
				i(3, "res"),
			},
			{ condition = line_begin }
		)
	),

	s(
		{ trig = "ref", dscr = "Vue reactive ref" },
		fmt("const {} = ref<{}>({});", {
			i(1, "val"),
			i(2, "Type"),
			i(3, ""),
		}, { condition = line_begin })
	),
	s(
		{ trig = "defineProps", dscr = "Vue props" },
		fmt(
			[[

const {} = defineProps<{{
  {}: {}
}}>();
			]],
			{
				i(1, "props"),
				i(2, "val"),
				i(3, "Type"),
			},
			{ condition = line_begin }
		)
	),
}
