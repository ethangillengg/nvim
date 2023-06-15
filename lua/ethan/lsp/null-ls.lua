local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting

local sources = {
	-- webdev stuff
	-- formatting.deno_fmt, -- chose deno for ts/js files cuz its very fast!
	-- formatting.prettierd.with({ filetypes = { "html", "markdown", "css", "vue" } }), -- so prettier works only on these filetypes
	formatting.prettierd,
	formatting.rustfmt,
	-- Lua
	formatting.stylua,
	-- C#
	formatting.csharpier,
	-- C++
	formatting.clang_format,
	-- nix
	formatting.alejandra,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	-- you can reuse a shared lspconfig on_attach callback here
	debug = true,
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})
