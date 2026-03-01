return {
	"numToStr/Navigator.nvim",
	keys = {
		{ "<C-h>", "<CMD>lua require('Navigator').left()<CR>", mode = "n", silent = true, desc = "Navigate left" },
		{ "<C-j>", "<CMD>lua require('Navigator').down()<CR>", mode = "n", silent = true, desc = "Navigate down" },
		{ "<C-k>", "<CMD>lua require('Navigator').up()<CR>", mode = "n", silent = true, desc = "Navigate up" },
		{
			"<C-l>",
			"<CMD>lua require('Navigator').right()<CR>",
			mode = "n",
			silent = true,
			desc = "Navigate right",
		},
		{
			"<C-\\>",
			"<CMD>lua require('Navigator').previous()<CR>",
			mode = "n",
			silent = true,
			desc = "Navigate previous",
		},
	},
	config = function()
		require("Navigator").setup()
	end,
}
