local M = {}

local scope_types = {
	class_declaration = true,
	record_declaration = true,
	struct_declaration = true,
	interface_declaration = true,
	enum_declaration = true,
}

local member_types = {
	method_declaration = "Method",
	constructor_declaration = "Constructor",
	destructor_declaration = "Destructor",
	property_declaration = "Property",
	field_declaration = "Field",
	event_declaration = "Event",
	event_field_declaration = "Event",
	indexer_declaration = "Indexer",
	operator_declaration = "Operator",
	conversion_operator_declaration = "Operator",
	class_declaration = "Class",
	record_declaration = "Record",
	struct_declaration = "Struct",
	interface_declaration = "Interface",
	enum_declaration = "Enum",
	enum_member_declaration = "Enum Member",
	delegate_declaration = "Delegate",
}

local function find_scope(node)
	while node do
		if scope_types[node:type()] then
			return node
		end
		node = node:parent()
	end
end

local function get_name(node, bufnr)
	local name = node:field("name")[1]

	if name then
		return vim.treesitter.get_node_text(name, bufnr)
	end

	if node:type() == "field_declaration" or node:type() == "event_field_declaration" then
		local declaration = node:field("declaration")[1]

		if not declaration then
			for child in node:iter_children() do
				if child:type() == "variable_declaration" then
					declaration = child
					break
				end
			end
		end

		if declaration then
			local names = {}

			for child in declaration:iter_children() do
				if child:type() == "variable_declarator" then
					local identifier = child:field("name")[1]

					if identifier then
						table.insert(names, vim.treesitter.get_node_text(identifier, bufnr))
					end
				end
			end

			if #names > 0 then
				return table.concat(names, ", ")
			end
		end
	end

	if node:type() == "indexer_declaration" then
		return "this[]"
	end

	local text = vim.treesitter.get_node_text(node, bufnr)
	return (text:match("^[^\r\n]+") or ""):sub(1, 100)
end

local function make_member(node, bufnr)
	local row, col = node:range()

	return {
		name = get_name(node, bufnr),
		kind = member_types[node:type()],
		row = row,
		col = col,
	}
end

local function get_members(scope, bufnr)
	local members = {}

	local body = scope:field("body")[1]

	if not body then
		for child in scope:iter_children() do
			if child:type() == "declaration_list" or child:type() == "enum_member_declaration_list" then
				body = child
				break
			end
		end
	end

	if not body then
		return members
	end

	for child in body:iter_children() do
		if member_types[child:type()] then
			table.insert(members, make_member(child, bufnr))
		end
	end

	return members
end

-- Collect document-level symbols, including those inside namespaces.
-- Don't descend into types, so their methods/fields aren't included.
local function get_document_symbols(root, bufnr)
	local symbols = {}

	local function visit(node)
		local node_type = node:type()

		if member_types[node_type] then
			table.insert(symbols, make_member(node, bufnr))
			return
		end

		if
			node_type == "compilation_unit"
			or node_type == "namespace_declaration"
			or node_type == "file_scoped_namespace_declaration"
			or node_type == "declaration_list"
		then
			for child in node:iter_children() do
				visit(child)
			end
		end
	end

	visit(root)

	return symbols
end

local function show_picker(symbols, title, bufnr, winid)
	if #symbols == 0 then
		vim.notify("No symbols found", vim.log.levels.INFO)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = title,

			finder = finders.new_table({
				results = symbols,
				entry_maker = function(symbol)
					return {
						value = symbol,
						display = string.format("%-12s %s", symbol.kind, symbol.name),
						ordinal = symbol.name .. " " .. symbol.kind,
					}
				end,
			}),

			sorter = conf.generic_sorter({}),

			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if not selection then
						return
					end

					if vim.api.nvim_win_is_valid(winid) then
						vim.api.nvim_set_current_win(winid)
					end

					vim.api.nvim_set_current_buf(bufnr)
					vim.api.nvim_win_set_cursor(0, {
						selection.value.row + 1,
						selection.value.col,
					})
				end)

				return true
			end,
		})
		:find()
end

function M.open()
	local bufnr = vim.api.nvim_get_current_buf()
	local winid = vim.api.nvim_get_current_win()

	-- Ignore special buffers and unnamed buffers.
	if vim.bo[bufnr].buftype ~= "" or vim.api.nvim_buf_get_name(bufnr) == "" then
		return
	end

	-- Ignore buffers without a filetype.
	if vim.bo[bufnr].filetype == "" then
		return
	end

	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)

	if not ok or not parser then
		vim.notify("Tree-sitter parser not available", vim.log.levels.WARN)
		return
	end

	local trees = parser:parse()
	local tree = trees and trees[1]

	if not tree then
		return
	end

	local root = tree:root()
	local node = vim.treesitter.get_node({ bufnr = bufnr })
	local scope = node and find_scope(node)

	local symbols
	local title

	if scope then
		symbols = get_members(scope, bufnr)
		title = get_name(scope, bufnr)
	else
		symbols = get_document_symbols(root, bufnr)
		title = "Document Symbols"
	end

	show_picker(symbols, title, bufnr, winid)
end

return M
