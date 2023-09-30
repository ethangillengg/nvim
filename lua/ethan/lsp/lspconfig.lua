local lsp_servers = {
	"lua_ls",
	"nil_ls",
	"html",
	"cssls",
	"tsserver",
	"clangd",
	"volar",
	"csharp_ls",
	"rust_analyzer",
	"glslls",
}

local M = {}

M.setup = function()
	local lspconfig = require("lspconfig")
	local rt = require("rust-tools")
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
		elseif lsp == "rust_analyzer" then
			local opts = {
				server = {
					on_attach = on_attach,
					capabilities = capabilities,
				},
			}
			rt.setup(opts)
		else
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end
	end
end

return M
