return {
	"akinsho/bufferline.nvim",
  enabled = true,
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs", -- or "buffers" if you prefer buffer-based workflow
				separator_style = "slant", -- or "padded_slant", "thick", "thin"
				show_buffer_close_icons = true,
				show_close_icon = true,
				close_icon = "󰅖",
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				indicator = {
					style = "icon",
					icon = "▎",
				},
				numbers = "ordinal",
				always_show_bufferline = false,
			},
		})
	end,
}
