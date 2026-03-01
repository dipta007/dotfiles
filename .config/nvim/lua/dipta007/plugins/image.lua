return {
	"3rd/image.nvim",
  enabled = vim.g.is_local,
	ft = "markdown",
	config = function()
		require("image").setup({
			backend = "kitty", -- WezTerm supports kitty protocol
			integrations = {
				markdown = { enabled = true },
				neorg = { enabled = false },
			},
			max_width = 1200,
			max_height = 1200,
			window_overlap_clear_enabled = true,
		})
	end,
}
