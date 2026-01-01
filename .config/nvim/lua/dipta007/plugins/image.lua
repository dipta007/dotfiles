return {
	"3rd/image.nvim",
  enabled = vim.fn.has("macunix") == 1,
	config = function()
		require("image").setup({
			backend = "kitty", -- WezTerm supports kitty protocol
			integrations = {
				markdown = { enabled = true },
				neorg = { enabled = false },
			},
			max_width = 400,
			max_height = 400,
			window_overlap_clear_enabled = true,
		})
	end,
}
