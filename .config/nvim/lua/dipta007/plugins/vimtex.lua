return {
	"lervag/vimtex",
	init = function()
		-- VimTeX configuration goes here, e.g.
		-- vim.g.vimtex_view_method = "zathura"

		-- xelatex with latexmk for better font support
		vim.g.vimtex_compiler_latexmk = {
			executable = "latexmk",
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
