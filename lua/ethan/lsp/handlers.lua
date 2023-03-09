local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

local status_navic_ok, navic = pcall(require, "nvim-navic")
if not status_cmp_ok then
	return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
			false
		)
	end
end

-- Keymaps
local function lsp_keymaps(bufnr)
	local opts = { buffer = bufnr, noremap = true, silent = true }

	--[[ vim.keymap.set(mode, key, command, { noremap = true, silent = true }) ]]
	vim.keymap.set("n", "gD", function()
		vim.lsp.buf.declaration()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "gi", function()
		vim.lsp.buf.implementation()
	end, opts)
	vim.keymap.set("n", "<F2>", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "gr", function()
		vim.lsp.buf.references({})
	end, opts)
	vim.keymap.set("n", "gh", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts)
	vim.keymap.set("n", "gl", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev({ border = "rounded" })
	end, opts)
	vim.keymap.set("n", "gl", function()
		vim.diagnostic.open_float({ border = "rounded" })
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next({ border = "rounded" })
	end, opts)
	vim.keymap.set("n", "J", function()
		vim.diagnostic.goto_next({ border = "rounded" })
	end, opts)
	vim.keymap.set("n", "<c-.>", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("i", "<c-.>", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format()
	end, opts)
	--[[ vim.api.nvim_buf_set_keymap(bufnr, "n", "F", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) ]]
	--[[ vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) ]]
	--[[ vim.api.nvim_buf_set_keymap(bufnr, "n", "<c-.>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) ]]
	--vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({ async = true })']])
end

M.on_attach = function(client, bufnr)
	--[[ only use null-ls for formatting ]]
	if client.name ~= "null-ls" then
		client.server_capabilities.document_formatting = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
	end

	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

function M.start_format_on_save()
	vim.cmd([[
    augroup format_on_save
      autocmd!
      autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })
    augroup end
  ]])
end

function M.enable_format_on_save()
	M.start_format_on_save()
	vim.notify("Enabled format on save")
end

function M.disable_format_on_save()
	M.remove_augroup("format_on_save")
	vim.notify("Disabled format on save")
end

function M.toggle_format_on_save()
	if vim.fn.exists("#format_on_save#BufWritePre") == 0 then
		M.enable_format_on_save()
	else
		M.disable_format_on_save()
	end
end

function M.remove_augroup(name)
	if vim.fn.exists("#" .. name) == 1 then
		vim.cmd("au! " .. name)
	end
end

vim.cmd([[ command! LspToggleAutoFormat execute 'lua require("ethan.lsp.handlers").toggle_format_on_save()' ]])

M.start_format_on_save()

return M
