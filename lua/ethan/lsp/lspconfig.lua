local lsp_servers = {
	"lua_ls",
	-- Nix
	"nil_ls",
	-- Web Dev
	"html",
	"cssls",
	"tailwindcss",
	-- "tsserver",
	"volar",
	-- "biome",
	"denols",
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
	"templ",
	"htmx",
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
		elseif lsp == "html" or lsp == "htmx" then
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			})
		elseif lsp == "tailwindcss" then
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "templ", "javascript", "typescript", "react", "vue" },
				init_options = { userLanguages = { templ = "html" } },
			})
		else
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end
	end
end

return M
