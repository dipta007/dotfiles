return {
	"nvim-pack/nvim-spectre",
	enabled = not vim.g.vscode,
	build = false,
	cmd = "Spectre",
	opts = { open_cmd = "noswapfile vnew" },
	keys = {
		{
			"<leader>sr",
			function()
				require("spectre").toggle()
			end,
			desc = "Replace in Files (Spectre)",
		},
		{
			"<leader>Sw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Replace Word (Spectre)",
			mode = { "n", "v" },
		},
		{
			"<leader>Sf",
			function()
				require("spectre").open_file_search({ select_word = true })
			end,
			desc = "Replace in File (Spectre)",
		},
	},
}
