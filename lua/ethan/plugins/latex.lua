return {
	{
		ft = { "tex", "markdown" },
		"lervag/vimtex",
	},
	{
		"frabjous/knap",
		ft = { "tex" },
		opts = {
			-- Use stdin
			textopdf = 'pdflatex -jobname "$(basename -s .pdf %outputfile%)"',
			textopdfbufferasstdin = true,
		},
		config = function(_, opts)
			vim.g.knap_settings = opts
		end,
		keys = {
			{
				"<F7>",
				function()
					require("knap").toggle_autopreviewing()
				end,
				desc = "Latex Preview",
				ft = { "latex", "tex" },
			},
		},
	},
}
