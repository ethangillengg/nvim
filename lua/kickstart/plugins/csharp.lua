return {
	"seblyng/roslyn.nvim",
	ft = { "cs", "cshtml" },
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
		filewatching = "auto",
	},
	dependencies = {
		-- {
		-- 	"khoido2003/roslyn-filewatch.nvim",
		-- 	build = "nvim -l build.lua --", -- Compiles or downloads the Native Rust module fallback
		-- 	config = function()
		-- 		require("roslyn_filewatch").setup()
		-- 	end,
		-- },
	},
	init = function()
		-- We add the Razor file types before the plugin loads.
		-- vim.filetype.add({
		-- 	extension = {
		-- 		razor = "razor",
		-- 		cshtml = "razor",
		-- 	},
		-- })
	end,
	config = function(_, opts)
		require("roslyn").setup(opts)

		vim.treesitter.language.register("c_sharp", "csharp", "cshtml")
		vim.lsp.config("roslyn", {
			on_attach = function() end,
			cmd = {
				"Microsoft.CodeAnalysis.LanguageServer",
				"--logLevel=Information",
				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
				"--stdio",
			},
			settings = {

				["csharp|background_analysis"] = {

					-- dotnet_analyzer_diagnostics_scope = "fullSolution",
					-- dotnet_compiler_diagnostics_scope = "fullSolution",
					dotnet_analyzer_diagnostics_scope = "openFiles",
					dotnet_compiler_diagnostics_scope = "openFiles",
				},
				["csharp|inlay_hints"] = {
					csharp_enable_inlay_hints_for_implicit_object_creation = true,
					csharp_enable_inlay_hints_for_implicit_variable_types = true,
				},
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
				["csharp|completion"] = {

					dotnet_show_completion_items_from_unimported_namespaces = true,
					dotnet_show_name_completion_suggestions = true,
				},
			},
		})

		-- for refreshing diagnotics more frequently since roslyn is buggy
		-- see: https://github.com/seblyng/roslyn.nvim/wiki#diagnostic-refresh
		-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		-- 	pattern = "*",
		-- 	callback = function()
		-- 		local clients = vim.lsp.get_clients({ name = "roslyn" })
		-- 		if not clients or #clients == 0 then
		-- 			return
		-- 		end
		--
		-- 		local buffers = vim.lsp.get_buffers_by_client_id(clients[1].id)
		-- 		for _, buf in ipairs(buffers) do
		-- 			vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = buf })
		-- 		end
		-- 	end,
		-- })

		-- for auto inserting summary comments
		-- see: https://github.com/seblyng/roslyn.nvim/wiki#textdocument_vs_onautoinsert
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local bufnr = args.buf

				if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
					vim.api.nvim_create_autocmd("InsertCharPre", {
						desc = "Roslyn: Trigger an auto insert on '/'.",
						buffer = bufnr,
						callback = function()
							local char = vim.v.char

							if char ~= "/" then
								return
							end

							local row, col = unpack(vim.api.nvim_win_get_cursor(0))
							row, col = row - 1, col + 1
							local uri = vim.uri_from_bufnr(bufnr)

							local params = {
								_vs_textDocument = { uri = uri },
								_vs_position = { line = row, character = col },
								_vs_ch = char,
								_vs_options = {
									tabSize = vim.bo[bufnr].tabstop,
									insertSpaces = vim.bo[bufnr].expandtab,
								},
							}

							-- NOTE: We should send textDocument/_vs_onAutoInsert request only after
							-- buffer has changed.
							vim.defer_fn(function()
								client:request(
									---@diagnostic disable-next-line: param-type-mismatch
									"textDocument/_vs_onAutoInsert",
									params,
									function(err, result, _)
										if err or not result then
											return
										end

										vim.snippet.expand(result._vs_textEdit.newText)
									end,
									bufnr
								)
							end, 1)
						end,
					})
				end
			end,
		})
	end,
}
