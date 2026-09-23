-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
	-- {
	-- 	"akinsho/git-conflict.nvim",
	-- 	enabled = true,
	-- 	lazy = false,
	-- 	opts = {
	-- 		-- disable_diagnostics = true,
	-- 		highlights = {
	-- 			incoming = "DiffAdd",
	-- 			current = "DiffChange",
	-- 		},
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<leader>gq",
	-- 			"<cmd>GitConflictListQf<CR>",
	-- 			mode = "",
	-- 			desc = "[G]it list conflicts",
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"esmuellert/codediff.nvim",
	-- 	cmd = "CodeDiff",
	-- 	keys = {
	-- 		{
	-- 			"<leader>gd",
	-- 			"<cmd>CodeDiff<CR>",
	-- 			mode = "",
	-- 			desc = "[G]it code [d]iff",
	-- 		},
	--
	-- 		{
	-- 			"<leader>gq",
	-- 			"<cmd>CodeDiff<CR>",
	-- 			mode = "",
	-- 			desc = "[G]it code diff",
	-- 		},
	--
	-- 		{
	-- 			"<leader>gc",
	-- 			"<cmd>term git commit<CR>",
	-- 			mode = "",
	-- 			desc = "[G]it [c]ommit ",
	-- 		},
	-- 	},
	-- },
	{
		"NeogitOrg/neogit",
		lazy = true,
		dependencies = {
			-- Only one of these is needed.
			"sindrets/diffview.nvim", -- optional
			"esmuellert/codediff.nvim", -- optional

			-- For a custom log pager
			"m00qek/baleia.nvim", -- optional

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			"nvim-mini/mini.pick", -- optional
			"folke/snacks.nvim", -- optional
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
		},
		config = function()
			local function highlights()
				local links = {
					NeogitChangeDeleted = "DiagnosticError",
					NeogitChangeModified = "DiagnosticWarn",
					NeogitChangeAdded = "DiagnosticO",

					-- NeogitNormal = "Normal",
					-- NeogitFloat = "NormalFloat",
					-- NeogitFloatBorder = "FloatBorder",

					NeogitDiffAdd = "DiffAdd",
					NeogitDiffDelete = "DiffDelete",
					NeogitDiffContext = "Normal",
					NeogitDiffHeader = "Title",
					--
					NeogitDiffAddHighlight = "DiffAdd",
					NeogitDiffDeleteHighlight = "DiffDelete",
					NeogitDiffContextHighlight = "CursorLine",
					--
					NeogitDiffAddCursor = "DiffAdd",
					NeogitDiffDeleteCursor = "DiffDelete",
					NeogitDiffContextCursor = "CursorLine",

					NeogitDiffDeleteInline = "CodeDiffCharDelete",
					NeogitDiffAddInline = "CodeDiffCharInsert",

					NeogitBranch = "Identifier",
					NeogitRemote = "Constant",
					NeogitTagName = "Tag",
					NeogitObjectId = "Comment",

					NeogitSectionHeader = "Title",

					NeogitHunkHeader = "CursorLine",
					NeogitHunkHeaderCursor = "CursorLine",
					NeogitHunkHeaderHighlight = "Visual",

					NeogitFilePath = "Directory",

					NeogitCommitViewHeader = "ArrowCurrentFile",
					NeogitCommitViewDescription = "Normal",
					NeogitActiveItem = "ArrowCurrentFile",
				}

				for group, link in pairs(links) do
					vim.api.nvim_set_hl(0, group, { link = link })
				end
			end

			-- Neogit respects groups that already exist.
			highlights()

			require("neogit").setup()

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = highlights,
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		cond = not vim.g.vscode,
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to Next Git [C]hange" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to Previous Git [C]hange" })

				-- Actions
				-- visual mode
				map("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[G]it [S]tage Hunk" })
				map("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[G]it [S]tage Hunk" })
				-- normal mode
				map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "[G]it [S]tage Hunk" })
				map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[G]it [R]eset Hunk" })
				map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "[G]it [S]tage Buffer" })
				map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "[G]it [U]ndo Stage Hunk" })
				map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "[G]it [R]eset Buffer" })
				map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "[G]it [P]review Hunk" })
				map("n", "<leader>gb", gitsigns.blame, { desc = "[G]it [B]lame" })
				-- map("n", "<leader>gd", gitsigns.diffthis, { desc = "[G]it [D]iff against Index" })
				-- map("n", "<leader>gD", function()
				-- 	gitsigns.diffthis("@")
				-- end, { desc = "[G]it [D]iff Against Last Commit" })
				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle Git Show [B]lame Line" })
				map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle Git Show [D]eleted" })
			end,
		},
	},
}
