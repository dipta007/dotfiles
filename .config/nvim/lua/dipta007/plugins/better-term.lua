return {
  enabled = true,
	"CRAG666/betterTerm.nvim",
	keys = {
		{
			mode = { "n", "t" },
			"<localleader>tt",
			function()
				require("betterTerm").open()
			end,
			desc = "Open BetterTerm 0",
		},
		{
			mode = { "n", "t" },
			"<localleader>ts",
			function()
				require("betterTerm").select()
			end,
			desc = "Select terminal",
		},
		{
			mode = { "n", "t" },
			"<localleader>tc",
			function()
				require("betterTerm").rename()
			end,
			desc = "Rename terminal",
		},
	},
	opts = {
		position = "bot",
		size = 16,
		jump_tab_mapping = "<C-$tab>",
		index_base = 1,
	},
}
