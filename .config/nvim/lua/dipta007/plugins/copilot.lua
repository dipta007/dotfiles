local config = function()
	require("copilot").setup({
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			auto_refresh = true,
			debounce = 40,
			keymap = {
				accept = "<C-y>",
				accept_word = "<C-w>",
				accept_line = false,
				next = "<C-n>",
				prev = "<C-p>",
				dismiss = "<C-e>",
			},
		},
		filetypes = {
			python = true,
			["*"] = true,
		},
		copilot_node_command = "node", -- Node.js version must be > 18.x
		server_opts_overrides = {},
	})
end
return {
	"zbirenbaum/copilot.lua",
	requires = {
		"copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
	},
	enabled = true,
	cmd = "Copilot",
	event = "InsertEnter",
	config = config,
}
