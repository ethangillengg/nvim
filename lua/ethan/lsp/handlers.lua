local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local function lsp_keymaps(bufnr)
	local opts = { buffer = bufnr, noremap = true, silent = true }
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
	vim.keymap.set("n", "<leader>ra", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "gr", function()
		vim.lsp.buf.references({})
	end, opts)
	vim.keymap.set("n", "gl", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "<C-J>", function()
		vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.ERROR } })
	end, opts)
	vim.keymap.set("n", "<C-K>", function()
		vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.ERROR } })
	end, opts)

	vim.keymap.set("n", "J", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
end

M.on_attach = function(_, bufnr)
	lsp_keymaps(bufnr)
end

return M
