return {
	"nvim-pack/nvim-spectre",
	enabled = not vim.g.vscode,
	build = false,
	cmd = "Spectre",
	opts = { open_cmd = "noswapfile vnew" },
	keys = {
		{
			"<leader>R",
			function()
				require("spectre").toggle()
			end,
			desc = "Replace in Files (Spectre)",
		},
	},
}
