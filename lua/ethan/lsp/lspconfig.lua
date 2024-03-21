local lsp_servers = {
	"lua_ls",
	-- Nix
	"nil_ls",
	-- Web Dev
	"html",
	"cssls",
	"tsserver",
	"volar",
	"biome",
	-- Rust
	"rust_analyzer",
	-- Python
	"pyright",
	"ruff_lsp",
	-- C#
	"csharp_ls",
	-- C/C++
	"clangd",
	"glslls",
	-- Bash
	"bashls",
	-- Markdown
	-- "marksman",
	-- Latex
	"texlab",
	-- Go
	"gopls",
	-- XML
	"lemminx",
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
