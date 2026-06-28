return {
	"brianhuster/live-preview.nvim",
  enabled = vim.g.is_local,
	cmd = "LivePreview",
	dependencies = {
		"folke/snacks.nvim",
	},
	-- start only (not toggle). :LivePreview start re-targets current buf; close via :LivePreview close.
	keys = {
		{
			"<leader>m",
			"<cmd>LivePreview start<cr>",
			ft = { "markdown", "asciidoc", "html", "svg" },
			desc = "Live Preview (start)",
		},
	},
}
