return {
	"Vigemus/iron.nvim",
	enabled = not vim.g.vscode,
	cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
	keys = {
		{
			"<leader>rs",
			mode = { "n", "x" },
			function()
				require("iron.core").send_motion()
			end,
			desc = "Send to REPL",
		},
		{
			"<leader>rr",
			function()
				require("iron.core").send_line()
			end,
			desc = "Send Line to REPL",
		},
		{
			"<leader>rf",
			function()
				require("iron.core").send_file()
			end,
			desc = "Send File to REPL",
		},
		{ "<leader>ro", "<cmd>IronRepl<cr>", desc = "Open REPL" },
		{ "<leader>rR", "<cmd>IronRestart<cr>", desc = "Restart REPL" },
		{ "<leader>rh", "<cmd>IronHide<cr>", desc = "Hide REPL" },
		{ "<leader>rF", "<cmd>IronFocus<cr>", desc = "Focus REPL" },
		{
			"<leader>rc",
			function()
				require("iron.core").send(nil, string.char(12))
			end,
			desc = "Clear REPL",
		},
	},
	config = function()
		local iron = require("iron.core")
		iron.setup({
			config = {
				scratch_repl = true,
				repl_definition = {
					python = {
						command = { "ipython", "--no-autoindent" },
						format = require("iron.fts.common").bracketed_paste,
					},
					sh = {
						command = { "bash" },
					},
				},
				repl_open_cmd = require("iron.view").right(80),
			},
			keymaps = {
				visual_send = "<leader>rs",
				send_line = "<leader>rr",
			},
			highlight = {
				italic = true,
			},
		})
	end,
}
