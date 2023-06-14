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
	vim.keymap.set("n", "<F2>", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "gr", function()
		vim.lsp.buf.references({})
	end, opts)
	vim.keymap.set("n", "gl", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev({ border = "rounded" })
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next({ border = "rounded" })
	end, opts)
	vim.keymap.set("n", "J", function()
		vim.diaknostic.goto_next({ border = "rounded", severity = vim.diagnostic.severity.ERROR })
	end, opts)
	-- vim.keymap.set("n", "K", function()
	-- 	vim.diagnostic.goto_prev({ border = "rounded", severity = vim.diagnostic.severity.ERROR  })
	-- end, opts)
	vim.keymap.set("i", "<c-.>", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format()
	end, opts)
	-- vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({ async = true })']])
end

M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false

	lsp_keymaps(bufnr)
end

return M
