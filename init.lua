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

	-- NOTE: Plugins can also be added by using a table,
	-- with the first argument being the link and the following
	-- keys can be used to configure plugin behavior/loading/etc.
	--
	-- Use `opts = {}` to force a plugin to be loaded.
	--
	--  This is equivalent to:
	--    require('Comment').setup({})

	-- "gc" to comment visual regions/lines
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

	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		lazy = false,
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			defaults = {
				prompt = " ",
				file_icons = "mini",
			},
			keymap = {
				builtin = {

					["<a-k>"] = "preview-page-up",
					["<a-j>"] = "preview-page-down",
				},
			},
			winopts = {
				-- border="none",
				fullscreen = true,
			},
		},
		keys = {
			{ "<c-p>", "<cmd>FzfLua files<cr>", desc = "[F]ind [F]iles" },
			{ "<leader>sf", "<cmd>FzfLua files<cr>", desc = "[S]earch [F]iles" },
			{ "<leader>sw", "<cmd>FzfLua live_grep<cr>", desc = "[F]ind [F]iles" },
			{ "<leader>sW", "<cmd>FzfLua grep_cword<cr>", desc = "[F]ind [F]iles" },
			{ "<leader>sh", "<cmd>FzfLua helptags<cr>", desc = "[S]earch [H]elp" },
			{ "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "[S]earch [K]eymaps" },
			{ "<leader>ss", "<cmd>FzfLua builtin<cr>", desc = "[S]earch Fzf [B]uiltins" },
			{ "<leader>s.", "<cmd>FzfLua oldfiles<cr>", desc = "[S]earch Recent Files" },
			{ "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "[S]earch [Q]uickfix" },
			{ "<leader>st", "<cmd>FzfLua treesitter<cr>", desc = "[S]earch [T]S Symbols" },
			{ "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "[S]earch [J]umps" },
			{ "<leader>sc", "<cmd>FzfLua jumps<cr>", desc = "[S]earch [J]umps" },
			{ "<leader>sgl", "<cmd>FzfLua git_commits<cr>", desc = "[S]earch [G]it [L]og" },
			-- 		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			-- 		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			-- 		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			-- 		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			-- 		vim.keymap.set("n", "<leader>gt", builtin.git_status, { desc = "[G]it telescope status" })
			-- 		vim.keymap.set("n", "<leader>su", "<cmd>Telescope undo<cr>", { desc = "[S]earch [U]ndo Tree" })
		},
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,
		dependencies = {
			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			{
				"aznhe21/actions-preview.nvim",
				opts = {
					diff = {
						ctxlen = 10,
					},
				},
			},
			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			{ "folke/neodev.nvim", opts = {} },
			"saghen/blink.cmp",

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

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame symbol")
					map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
					map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")
					map("gD", require("fzf-lua").lsp_typedefs, "[G]oto Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ss", require("fzf-lua").lsp_document_symbols, "[F]ind document [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map("<leader>sps", require("fzf-lua").lsp_live_workspace_symbols, "[F]ind [P]roject [S]ymbols")

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
					map("<leader>ca", require("actions-preview").code_actions, "[C]ode [A]ction")

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
					local client = vim.lsp.get_client_by_id(event.data.client_id)
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
						"typescript",
						"vue",
					},
				},
				tailwindcss = {
					filetypes = { "templ", "javascript", "typescript", "react", "vue" },
					init_options = { userLanguages = { templ = "html" } },
					cmd = { "/home/ethan/.bun/bin/tailwindcss-language-server", "--stdio" },
				},
				-- eslint = {},
				-- Using the typescript plugin instead for now
				-- volar = {},
				-- Rust
				rust_analyzer = {},
				-- Python
				pyright = {},
				ruff = {},
				-- C/C++
				clangd = {},
				glslls = {},
				-- Bash
				bashls = {},
				-- Latex
				texlab = {},
				-- Go
				gopls = {},
				templ = {},
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
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				require("lspconfig")[server].setup(config)
			end
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		keys = {
			{
				"<leader>f",
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
				yaml = { "yamlfmt" },
				tex = { "latexindent" },
				asm = { "asmfmt" },
				xml = { "xmlformat" },
				go = { "gopls" },
				cs = { "csharpierd" },
			},
		},
	},

	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		cond = not vim.g.vscode,
		build = (function()
			-- Build Step is needed for regex support in snippets.
			-- This step is not supported in many windows environments.
			-- Remove the below condition to re-enable on windows.
			if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
				return
			end
			return "make install_jsregexp"
		end)(),
		dependencies = {
			-- `friendly-snippets` contains a variety of premade snippets.
			--    See the README about individual language/framework/plugin snippets:
			--    https://github.com/rafamadriz/friendly-snippets
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			"nvim-treesitter/nvim-treesitter",
			"lervag/vimtex",
		},
		event = "InsertEnter",
		config = function()
			local ls = require("luasnip")
			vim.keymap.set({ "i" }, "<c-k>", function()
				ls.expand()
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<c-l>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<c-h>", function()
				ls.jump(-1)
			end, { silent = true })

			ls.setup({
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
				update_events = { "TextChanged", "TextChangedI" },
				region_check_events = {
					"CursorMoved",
					"CursorMovedI",
					"CursorHold",
					"InsertEnter",
					"TextChanged",
				},
				ft_func = function()
					local ft = require("luasnip.extras.filetype_functions").from_filetype()
					if vim.tbl_contains(ft, "latex") then
						return ft
					end

					-- set both markdown and inline to the same filetype
					if vim.tbl_contains(ft, "markdown") then
						table.insert(ft, "markdown_core")
					elseif vim.tbl_contains(ft, "markdown_inline") then
						table.insert(ft, "markdown_core")
						table.insert(ft, "latex")
					end

					return ft
				end,
				load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
					-- load latex for inline math
					markdown = { "markdown_core", "latex" },
					markdown_inline = { "markdown_core", "latex" },
					tex = { "latex" },
				}),
			})

			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/luasnippets" })
		end,
		keys = {
			{

				"<leader>L",
				function()
					require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/luasnippets" })
				end,
			},
		},
	},

	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"L3MON4D3/LuaSnip",
			"echasnovski/mini.icons",
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
				["<C-y>"] = { "select_and_accept", "fallback" },
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
				list = {

					selection = function(ctx)
						return ctx.mode == "cmdline" and "auto_insert" or "preselect"
					end,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
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
			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "luasnip", "buffer" },
				providers = {
					buffer = {
						min_keyword_length = 5,
						max_items = 5,
					},
				},
				cmdline = function()
					local type = vim.fn.getcmdtype()
					-- Search forward and backward
					if type == "/" or type == "?" then
						return { "buffer" }
					end
					-- Commands
					if type == ":" then
						return { "cmdline" }
					end
					return {}
				end,
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
		--
		"ellisonleao/gruvbox.nvim",
		cond = not vim.g.vscode,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			vim.cmd.colorscheme("gruvbox")
		end,
		opts = {
			contrast = "hard",
			overrides = {
				SignColumn = { bg = "#1d2021" },
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
		cond = not vim.g.vscode,
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

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
				"latex",
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

	-- {
	-- 	"ckolkey/ts-node-action",
	--    dependencies = { "nvim-treesitter" },
	-- 	opts = {},
	-- 	keys = {
	-- 		{
	-- 			"<c-m>",
	-- 			function()
	-- 				require("ts-node-action").node_action()
	-- 			end,
	-- 			mode = "n",
	-- 			desc = "TS: Trigger Node Action",
	-- 		},
	-- 	},
	-- },

	{
		"glacambre/firenvim",
		cond = vim.g.started_by_firevim,
		build = ":call firenvim#install(0)",
	},
	{
		"utilyre/barbecue.nvim",
		cond = not vim.g.vscode,
		name = "barbecue",
		event = { "BufReadPre", "BufNewFile" },
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
	{ "anuvyklack/pretty-fold.nvim", opts = {} },
	{
		"seblj/roslyn.nvim",
		opts = {
			exe = "Microsoft.CodeAnalysis.LanguageServer",
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
	-- require 'kickstart.plugins.debug',
	require("kickstart.plugins.indent_line"),
	require("kickstart.plugins.dap"),
	require("kickstart.plugins.test"),
	-- require 'kickstart.plugins.lint',
	require("kickstart.plugins.autopairs"),
	require("kickstart.plugins.neo-tree"),
	require("kickstart.plugins.gitsigns"), -- adds gitsigns recommend keymaps
	require("custom.plugins.init"),
	require("kickstart.plugins.markdown"),

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
