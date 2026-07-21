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
				-- Port 5500 is fixed & shared across every nvim. If another project's
				-- server owns it, our file resolves against ITS webroot -> 404. Kill the
				-- foreign owner (never ourselves: server runs in-process) so this buf wins.
				local utils = require("livepreview.utils")
				local port = require("livepreview.config").config.port
				local me = vim.uv.os_getpid()
				local function foreign()
					return vim.tbl_filter(function(p)
						return p.pid ~= me
					end, utils.processes_listening_on_port(port))
				end
				local owners = foreign()
				if #owners > 0 then
					for _, p in ipairs(owners) do
						utils.kill(p.pid)
					end
					-- wait for OS to free the socket; bind() isn't error-checked, so
					-- starting too early would silently fail to listen.
					vim.wait(2000, function()
						return #foreign() == 0
					end, 50)
				end
				vim.cmd("LivePreview start")
			end,
			ft = { "markdown", "asciidoc", "html", "svg" },
			desc = "Live Preview (start)",
		},
	},
}
