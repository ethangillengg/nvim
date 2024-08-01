-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
	{
		"lewis6991/gitsigns.nvim",
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
				map("n", "<leader>gb", gitsigns.blame_line, { desc = "[G]it [B]lame Line" })
				map("n", "<leader>gd", gitsigns.diffthis, { desc = "[G]it [D]iff against Index" })
				map("n", "<leader>gD", function()
					gitsigns.diffthis("@")
				end, { desc = "[G]it [D]iff Against Last Commit" })
				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle Git Show [B]lame Line" })
				map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle Git Show [D]eleted" })
			end,
		},
	},
}
