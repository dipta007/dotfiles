return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },
	enabled = true,

	version = "1.*",

	opts = {
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			-- set to 'none' to disable the 'default' preset
			preset = "default",
			-- ["<C-space>"] = { }, -- if you want to disable it, set to false or {}
			["<Cr>"] = { "accept", "fallback" },
			["<C-y>"] = {},
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = { documentation = { auto_show = false } },

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		-- See the fuzzy documentation for more options
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
