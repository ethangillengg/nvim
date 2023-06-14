local lsp_servers = {
	"lua_ls",
	"rust_analyzer",
}

local M = {}

M.setup = function()
	local lspconfig = require("lspconfig")
	local on_attach = require("ethan.lsp.handlers").on_attach
	local capabilities = require("ethan.lsp.handlers").capabilities

	for _, lsp in ipairs(lsp_servers) do
		if lsp == "lua_ls" then
			lspconfig[lsp].setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
				on_attach = on_attach,
				capabilities = capabilities,
			})
		else
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end
	end
end

M.lsp_servers = lsp_servers

return M
