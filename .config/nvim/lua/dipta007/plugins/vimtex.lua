return {
	"lervag/vimtex",
  enabled = vim.g.is_local,
	ft = { "tex", "latex", "bib" },
	init = function()
		vim.g.vimtex_view_method = "skim"
		-- xelatex with latexmk for better font support
		vim.g.vimtex_compiler_latexmk = {
			executable = "latexmk",
			out_dir = "build",
			options = {
				"-pdf",
				-- "-pdflatex=xelatex",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
			},
		}
		vim.g.vimtex_compiler_latexmk_engines = {
			_ = "-pdf",
			pdflatex = "-pdf",
			xelatex = "-xelatex",
			lualatex = "-lualatex",
		}
		vim.g.vimtex_compiler_engine = "pdflatex"
	end,
}
