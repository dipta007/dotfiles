return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night", -- darker punchy bg, distinct vivid syntax hues
				transparent = false, -- solid bg = less eye strain
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
				},
			})
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
}
