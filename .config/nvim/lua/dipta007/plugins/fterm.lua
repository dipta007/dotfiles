return {
	"numToStr/FTerm.nvim",
	keys = {
		{ "<localleader>tt", function() require("FTerm").toggle() end, mode = { "n", "t" }, desc = "Toggle terminal" },
		{ "<localleader>tx", function() require("FTerm").exit() end, mode = { "n", "t" }, desc = "Exit terminal" },
	},
	config = function()
		require("FTerm").setup({
			border = "double",
			dimensions = {
				height = 0.9,
				width = 0.9,
			},
		})
	end,
}
