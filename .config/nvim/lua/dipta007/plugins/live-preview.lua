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
			function()
				-- Server runs IN-PROCESS (libuv socket inside this nvim), so the PID owning
				-- the port is a whole nvim editor. Old code killed the "foreign" port owner
				-- => it killed OTHER open nvims. Instead give each nvim its own free port so
				-- nothing is ever killed and every nvim can preview at once.
				local lp = require("livepreview")
				local config = require("livepreview.config").config
				if not lp.is_running() then
					-- bind(port 0) => OS hands back a free ephemeral port. pick it once per
					-- nvim; re-pressing while running reuses it (start re-targets the buf).
					local s = assert(vim.uv.new_tcp())
					s:bind("127.0.0.1", 0)
					config.port = s:getsockname().port
					s:close()
				end
				vim.cmd("LivePreview start")
			end,
			ft = { "markdown", "asciidoc", "html", "svg" },
			desc = "Live Preview (start)",
		},
	},
}
