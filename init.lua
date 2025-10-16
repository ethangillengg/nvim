require("kickstart.options") -- default vim options

--
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Quick save mappings
vim.keymap.set("n", "<leader>w", ":wa<cr>")
if not vim.g.vscode then
	vim.keymap.set("n", "<leader>q", ":wqa<cr>")
end

-- Multiline on single wrapped
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Dont stop visual mode on indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<c-,>", "<gv")
vim.keymap.set("v", "<c-.>", ">gv")

vim.keymap.set("n", "<c-,>", "<<")
vim.keymap.set("n", "<c-.>", ">>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

-- Quickfix list navigation
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>", { desc = "Go to next quickfix entry" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>", { desc = "Go to previous quickfix entry" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--

-- Toggle options
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "[T]oggle [W]rap" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch" })
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{
		"abecodes/tabout.nvim",
		cond = not vim.g.vscode,
		opts = {
			tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
			backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
			act_as_tab = true, -- shift content if tab out is not possible
			act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
			default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
			default_shift_tab = "<C-d>", -- reverse shift default action,
			enable_backwards = true, -- well ...
			completion = false, -- if the tabkey is used in a completion pum
			tabouts = {
				{ open = "'", close = "'" },
				{ open = '"', close = '"' },
				{ open = "`", close = "`" },
				{ open = "(", close = ")" },
				{ open = "[", close = "]" },
				{ open = "{", close = "}" },
			},
			ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
			exclude = {},
		},
	},

	{
		"numToStr/Comment.nvim",
		cond = not vim.g.vscode,
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
	--
	-- This is often very useful to both group configuration, as well as handle
	-- lazy loading plugins that don't need to be loaded immediately at startup.
	--
	-- For example, in the following configuration, we use:
	--  event = 'VimEnter'
	--
	-- which loads which-key before all the UI elements are loaded. Events can be
	-- normal autocommands events (`:help autocmd-events`).
	--
	-- Then, because we use the `config` key, the configuration only runs
	-- after the plugin has been loaded:
	--  config = function() ... end

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		cond = not vim.g.vscode,
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()

			-- Document existing key chains
			require("which-key").add({
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>p", group = "[P]roject" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>l", group = "[L]SP" },
				{ "<leader>g", group = "[G]it" },
			})
		end,
	},

	-- quickfix list
	-- { "itchyny/vim-qfedit", ft = "qf" },
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		lazy = false,
		opts = {},
	},
	-- { -- Fuzzy Finder (files, lsp, etc)
	-- 	"nvim-telescope/telescope.nvim",
	-- 	cond = not vim.g.vscode,
	-- 	event = "VimEnter",
	-- 	branch = "0.1.x",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		{
	-- 			"nvim-telescope/telescope-fzf-native.nvim",
	--
	-- 			-- `build` is used to run some command when the plugin is installed/updated.
	-- 			-- This is only run then, not every time Neovim starts up.
	-- 			build = "make",
	--
	-- 			-- `cond` is a condition used to determine whether this plugin should be
	-- 			-- installed and loaded.
	-- 			cond = function()
	-- 				return vim.fn.executable("make") == 1
	-- 			end,
	-- 		},
	-- 		{ "nvim-telescope/telescope-ui-select.nvim" },
	-- 		{ "debugloop/telescope-undo.nvim" },
	--
	-- 		-- Useful for getting pretty icons, but requires a Nerd Font.
	-- 		{ "echasnovski/mini.icons", enabled = vim.g.have_nerd_font },
	-- 	},
	-- 	config = function()
	-- 		-- [[ Configure Telescope ]]
	-- 		-- See `:help telescope` and `:help telescope.setup()`
	-- 		require("telescope").setup({
	-- 			-- You can put your default mappings / updates / etc. in here
	-- 			--  All the info you're looking for is in `:help telescope.setup()`
	-- 			defaults = {
	-- 				prompt_prefix = " ",
	-- 				selection_caret = "❯ ",
	-- 				sorting_strategy = "ascending",
	-- 				layout_config = {
	-- 					prompt_position = "top",
	-- 					height = { padding = 0 },
	-- 					width = { padding = 0 },
	-- 					-- preview_width = 0.55,
	-- 				},
	-- 				mappings = {
	-- 					i = {
	-- 						["<C-j>"] = require("telescope.actions").move_selection_next,
	-- 						["<C-k>"] = require("telescope.actions").move_selection_previous,
	-- 					},
	-- 				},
	-- 			},
	-- 			extensions = {
	-- 				["ui-select"] = {
	-- 					require("telescope.themes").get_dropdown(),
	-- 				},
	-- 			},
	-- 		})
	--
	-- 		-- Enable Telescope extensions if they are installed
	-- 		pcall(require("telescope").load_extension, "fzf")
	-- 		pcall(require("telescope").load_extension, "ui-select")
	-- 		pcall(require("telescope").load_extension("undo"))
	--
	-- 		-- See `:help telescope.builtin`
	-- 		local builtin = require("telescope.builtin")
	-- 		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	-- 		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	-- 		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	-- 		vim.keymap.set("n", "<c-p>", builtin.find_files, { desc = "[S]earch [F]iles" })
	-- 		vim.keymap.set("n", "<leader>sb", builtin.builtin, { desc = "[S]earch Select [T]elescope" })
	-- 		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	-- 		vim.keymap.set("n", "<leader>su", "<cmd>Telescope undo<cr>", { desc = "[S]earch [U]ndo Tree" })
	-- 		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	-- 		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	-- 		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	-- 		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	-- 		vim.keymap.set("n", "<leader>sj", builtin.jumplist, { desc = "[S]earch [J]umps" })
	-- 		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
	-- 		vim.keymap.set("n", "<leader>gt", builtin.git_status, { desc = "[G]it telescope status" })
	--
	-- 		-- Slightly advanced example of overriding default behavior and theme
	-- 		vim.keymap.set("n", "<leader>s/", function()
	-- 			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
	-- 			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
	-- 				previewer = false,
	-- 			}))
	-- 		end, { desc = "[/] Fuzzily search in current buffer" })
	--
	-- 		-- Shortcut for searching your Neovim configuration files
	-- 		vim.keymap.set("n", "<leader>sn", function()
	-- 			builtin.find_files({ cwd = vim.fn.stdpath("config") })
	-- 		end, { desc = "[S]earch [N]eovim files" })
	-- 	end,
	-- },

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,
		lazy = false,
		dependencies = {
			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			{ "folke/neodev.nvim", opts = {} },
			{ "saghen/blink.cmp" },

			{
				"smjonas/inc-rename.nvim",
				config = true,
			},
		},
		config = function()
			vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "[L]SP [i]nfo" })
			vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "[L]SP [r]estart all" })
			local signs = {
				{ name = "DiagnosticSignError", text = "" },
				{ name = "DiagnosticSignWarn", text = "" },
				{ name = "DiagnosticSignHint", text = "" },
				{
					name = "DiagnosticSignInfo",
					text = "",
				},
			}

			for _, sign in ipairs(signs) do
				vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
			end

			vim.diagnostic.config({
				-- show signs
				signs = {
					active = signs,
				},
				update_in_insert = true,
				severity_sort = true,
			})

			-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
			-- and elegantly composed help section, `:help lsp-vs-treesitter`

			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					-- print(vim.inspect(event))
					-- vim.cmd([[new ]])
					-- local client = vim.lsp.get_client_by_id(event.data.client_id)
					-- vim.api.nvim_put({ vim.inspect(client.name) }, "", true, true)

					-- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					-- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					-- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					--
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					-- map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					-- map("<leader>ss", require("telescope.builtin").lsp_document_symbols, "[S]earch document [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					-- map(
					-- 	"<leader>sps",
					-- 	require("telescope.builtin").lsp_dynamic_workspace_symbols,
					-- 	"[S]earch [P]roject [S]ymbols"
					-- )

					vim.keymap.set("n", "<leader>rn", function()
						return ":IncRename " .. vim.fn.expand("<cword>")
					end, { expr = true })
					vim.keymap.set("n", "<F2>", function()
						return ":IncRename " .. vim.fn.expand("<cword>")
					end, { expr = true })

					map("gl", function()
						vim.diagnostic.open_float({ scope = "line" })
					end, "[G]et [l]ine diagnostics")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap.
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("<leader>D", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).

					vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
					vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({
									group = "kickstart-lsp-highlight",
									buffer = event2.buf,
								})
							end,
						})
					end

					-- The following autocommand is used to enable inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local servers = {
				-- Nix
				nil_ls = {},
				-- Web Dev
				html = {},
				cssls = {},
				ts_ls = {
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = "/home/ethan/.bun/install/global/node_modules/@vue/typescript-plugin",
								languages = { "javascript", "typescript", "vue" },
							},
						},
					},
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
						"vue",
					},
				},
				eslint = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
						"vue",
					},
				},
				oxlint = {
					filetypes = {
						"javascript",
						"typescript",
						"vue",
					},
				},
				tailwindcss = {
					filetypes = { "templ", "javascript", "typescript", "react", "vue" },
					init_options = { userLanguages = { templ = "html" } },
					-- cmd = { "/home/ethan/.bun/bin/tailwindcss-language-server", "--stdio" },
				},
				jsonls = {

					cmd = { "/home/ethan/.bun/bin/vscode-json-languageserver", "--stdio" },
				},
				-- -- eslint = {},
				-- -- Using the typescript plugin instead for now
				-- -- volar = {},
				-- -- Rust
				-- rust_analyzer = {},
				-- -- Python
				-- pyright = {},
				-- ruff = {},
				-- C/C++
				-- clangd = {},
				-- glslls = {},
				-- Bash
				bashls = {},
				-- Latex
				-- texlab = {},
				-- Go
				-- gopls = {},
				-- C#
				-- roslyn = {
				-- 	filetypes = { "csharp", "c_sharp", "cs" },
				-- 	cmd = {
				-- 		"Microsoft.CodeAnalysis.LanguageServer",
				-- 		"--logLevel=Information",
				-- 		"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
				-- 		"--stdio",
				-- 	},
				-- 	settings = {
				-- 		["csharp|inlay_hints"] = {
				-- 			csharp_enable_inlay_hints_for_implicit_object_creation = true,
				-- 			csharp_enable_inlay_hints_for_implicit_variable_types = true,
				-- 		},
				-- 		["csharp|code_lens"] = {
				-- 			dotnet_enable_references_code_lens = true,
				-- 		},
				-- 	},
				-- },
				-- templ = {},
				-- htmx = {
				-- 	filetypes = { "html", "templ" },
				-- },
				-- XML
				lemminx = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
			}
			-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
			for server, config in pairs(servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(
					vim.tbl_extend(
						"keep",
						config.capabilities or {},
						{ textDocument = { completion = { completionItem = { snippetSupport = false } } } }
					)
				)
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end,
	},
	--
	{ -- Autoformat
		"stevearc/conform.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			formatters = {
				-- Daemonized script for running csharpier
				csharpierd = {
					command = "bash",
					-- args = { "-c" },
					args = {
						vim.fn.stdpath("config") .. "/scripts/csharpierd.sh",
						"$FILENAME",
					},
					-- stdin = false,
				},
			},
			format_after_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true, cs = true }
				return {
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					stop_after_first = true,
				}
			end,
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			-- javascript = { { "prettierd", "prettier" } },
			formatters_by_ft = {
				html = { "prettierd" },
				css = { "prettierd" },
				scss = { "prettierd" },
				json = { "prettierd" },
				vue = { "prettierd" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				nix = { "alejandra" },
				lua = { "stylua" },
				cpp = { "clang_format" },
				glsl = { "clang_format" },
				python = { "ruff_format" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				-- yaml = { "yamlfmt" },
				tex = { "latexindent" },
				asm = { "asmfmt" },
				xml = { "xmlformat" },
				go = { "gopls" },
				cs = { "csharpierd" },
			},
		},
	},

	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"echasnovski/mini.icons",
			"saghen/blink.compat",
			{ "zbirenbaum/copilot.lua" },
			{
				"supermaven-inc/supermaven-nvim",
				opts = {
					keymaps = {
						accept_suggestion = "<c-y>", -- handled by nvim-cmp / blink.cmp
					},
					-- disable_inline_completion = true,
				},
			},
		},
		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',
		opts = {
			keymap = {

				preset = "none",
				["<c-k>"] = { "select_prev", "fallback" },
				["<c-j>"] = { "select_next", "fallback" },
				["<C-s>"] = { "show" },
				-- ["<C-y>"] = { "select_and_accept", "fallback" },
				["<enter>"] = {
					"accept",
					function(cmp)
						cmp.accept({
							callback = function()
								vim.api.nvim_feedkeys("\n", "n", true)
							end,
						})
					end,
					"fallback",
				},
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<A-k>"] = { "scroll_documentation_up", "fallback" },
				["<A-j>"] = { "scroll_documentation_down", "fallback" },
			},
			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			completion = {
				accept = { auto_brackets = { enabled = true } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100,
					treesitter_highlighting = true,
					window = {
						min_width = 60,
						max_height = 80,
						direction_priority = {
							menu_north = { "e", "w" },
							menu_south = { "e", "w" },
						},
					},
				},
				menu = {
					auto_show = function(ctx)
						return ctx.mode ~= "cmdline"
					end,
					draw = {
						columns = {
							{
								"label",
								"kind",
								"kind_icon",
								gap = 1,
							},
						},
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
							},
							label = {
								width = { fill = true, min = 24, max = 24 },
							},
							kind = {
								ellipsis = true,
								width = { max = 6 },
							},
						},
					},
				},
			},
			snippets = { preset = "luasnip" },
			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "snippets", "lsp", "path", "buffer" },
				providers = {
					buffer = {
						min_keyword_length = 5,
						max_items = 5,
					},
					snippets = {
						score_offset = 1,
					},

					-- supermaven = {
					-- 	name = "supermaven",
					-- 	module = "blink.compat.source",
					-- 	-- score_offset = 10,
					-- 	async = true,
					-- 	transform_items = function(_, items)
					-- 		local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
					-- 		local kind_idx = #CompletionItemKind + 1
					-- 		CompletionItemKind[kind_idx] = "Copilot"
					-- 		for _, item in ipairs(items) do
					-- 			item.kind = kind_idx
					-- 		end
					-- 		return items
					-- 	end,
					-- },
				},
			},
		},
		snippets = {
			expand = function(snippet)
				require("luasnip").lsp_expand(snippet)
			end,
			active = function(filter)
				if filter and filter.direction then
					return require("luasnip").jumpable(filter.direction)
				end
				return require("luasnip").in_snippet()
			end,
			jump = function(direction)
				require("luasnip").jump(direction)
			end,
		},
	},
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		"ellisonleao/gruvbox.nvim",
		cond = not vim.g.vscode,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			vim.cmd.colorscheme("gruvbox")
		end,
		opts = {
			contrast = "hard",
			overrides = {
				SignColumn = {
					-- bg = "#1d2021"
					bg = "#181a1c",
				},
			},
			palette_overrides = {
				-- gruvbox dark
				-- dark0_hard = "#1d2021",
				-- dark0_hard = "#131819",
				dark0_hard = "#181a1c",
			},
		},
	},
	{
		"catppuccin/nvim",
		enabled = false,
		cond = not vim.g.vscode,
		name = "catppuccin",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"max397574/better-escape.nvim",
		cond = not vim.g.vscode,
		event = "InsertEnter",
		opts = {
			timeout = 300,
			mappings = {
				-- map kj and kk as well
				i = {
					k = {
						k = "<Esc>",
						j = "<Esc>",
					},
				},
			},
		},
	},
	--
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		cond = not vim.g.vscode,
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			local spec_treesitter = require("mini.ai").gen_spec.treesitter
			require("mini.ai").setup({
				n_lines = 500,

				custom_textobjects = {
					f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
				},
			})

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
			require("mini.move").setup()
			require("mini.splitjoin").setup({
				mappings = { toggle = "<s-m>" },
			})

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"vim",
				"vimdoc",
				"cpp",
				"javascript",
				"typescript",
				"json",
				"python",
				"query",
				"regex",
				"tsx",
				"vue",
				"css",
				"jsdoc",
				"rust",
				"yaml",
				"nix",
				"glsl",
				"query",
				"go",
				"templ",
				"c_sharp",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = true, disable = { "yaml" } },
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			-- Prefer git instead of curl in order to improve connectivity in some environments
			require("nvim-treesitter.install").prefer_git = true
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
	{
		"otavioschwanck/arrow.nvim",
		dependencies = { "echasnovski/mini.icons" },
		lazy = false,
		opts = {
			show_icons = true,
			separate_save_and_remove = true,
			leader_key = "<leader>;", -- Recommended to be a single key
			window = {
				border = "single",
			},
		},
		keys = {
			{
				"<leader>a",
				function()
					require("arrow.persist").toggle()
				end,
				mode = "n",
				desc = "[A]rrow Save",
			},
			{
				"<C-h>",
				function()
					require("arrow.persist").next()
				end,
				mode = "n",
				desc = "Arrow Next",
			},
			{
				"<C-l>",
				function()
					require("arrow.persist").previous()
				end,
				mode = "n",
				desc = "Arrow Prev",
			},
		},
	},

	-- {
	-- 	"glacambre/firenvim",
	-- 	cond = vim.g.started_by_firevim,
	-- 	build = ":call firenvim#install(0)",
	-- },
	{
		"utilyre/barbecue.nvim",
		cond = not vim.g.vscode,
		name = "barbecue",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
		keys = {
			{
				"<leader>tq",
				"<cmd>Barbecue toggle<cr>",
				mode = "n",
				desc = "[T]oggle barbe[C]ue",
			},
		},
	},

	-- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.

	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	require("kickstart.plugins.snacks"),
	require("kickstart.plugins.autopairs"),
	require("kickstart.plugins.neo-tree"),
	require("kickstart.plugins.gitsigns"),
	require("kickstart.plugins.luasnip"),
	require("kickstart.plugins.markdown"),

	-- proj-specific
	require("kickstart.plugins.csharp"),

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	--    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
	-- { import = 'custom.plugins' },
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
