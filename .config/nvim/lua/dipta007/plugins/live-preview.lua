return {
	"brianhuster/live-preview.nvim",
  enabled = vim.g.is_local,
	cmd = "LivePreview",
	dependencies = {
		"folke/snacks.nvim",
	},
}
