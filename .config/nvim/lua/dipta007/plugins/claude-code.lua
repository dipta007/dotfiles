return {
	"coder/claudecode.nvim",
	enabled = false,
	dependencies = {
		"folke/snacks.nvim",
	},
	cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeAdd", "ClaudeCodeTreeAdd" },
	config = true,
	opts = {
		-- Optional: Set your OpenAI API key here or use the environment variable OPENAI_API_KEY
		--
		terminal = {
			snacks_win_opts = {
				keys = {
					nav_h = {
						"<C-h>",
						function()
							vim.cmd("stopinsert")
							require("Navigator").left()
						end,
						mode = "t",
						desc = "Navigate left",
					},
					nav_j = {
						"<C-j>",
						function()
							vim.cmd("stopinsert")
							require("Navigator").down()
						end,
						mode = "t",
						desc = "Navigate down",
					},
					nav_k = {
						"<C-k>",
						function()
							vim.cmd("stopinsert")
							require("Navigator").up()
						end,
						mode = "t",
						desc = "Navigate up",
					},
					nav_l = {
						"<C-l>",
						function()
							vim.cmd("stopinsert")
							require("Navigator").right()
						end,
						mode = "t",
						desc = "Navigate right",
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader>cc",
			function()
				vim.cmd("ClaudeCode")
			end,
			desc = "Toggle Claude Code",
		},
		{
			"<leader>cb",
			function()
				vim.cmd("ClaudeCodeAdd %")
			end,
			desc = "Add current buffer",
		},
		{
			"<leader>cp",
			function()
				vim.cmd("ClaudeCodeSend")
			end,
			desc = "Send to Claude Code",
		},
		{
			"<leader>ap",
			function()
				vim.cmd("ClaudeCodeTreeAdd")
			end,
			desc = "Add file",
			ft = { "snacks_explorer", "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
	},
}
