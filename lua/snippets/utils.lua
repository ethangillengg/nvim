local M = {}
local ts = require("vim.treesitter")
local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node
local s = ls.snippet

--- GENERAL ---
function M.get_visual(_, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else
		return sn(nil, i(1, ""))
	end
end

M.as = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
---------------

--- LATEX ---
local function in_markdown_mathzone()
	local buf = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	col = col - 1
	local parser = ts.get_parser(buf)
	parser:parse()
	if
		parser:children()["markdown_inline"] ~= nil
		and parser:children()["markdown_inline"]:children()["latex"] ~= nil
		and parser:children()["markdown_inline"]:children()["latex"]:contains({ row, col, row, col })
	then
		return true
	else
		return false
	end
end

local function in_tex_mathzone()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

function M.in_any_mathzone()
	return in_markdown_mathzone() or in_tex_mathzone()
end

function M.in_tex_env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end
-------------

return M
