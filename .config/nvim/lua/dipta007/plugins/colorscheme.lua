return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night", -- darker punchy bg, distinct vivid syntax hues
				transparent = false, -- solid bg = less eye strain
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
				},
				-- Calm markdown tweaks (no background boxes):
				--   inline `code` -> soft cyan
				--   **bold**      -> warm yellow + bold
				--   *italic*      -> left plain (slant only)
				-- Headings, lists, links keep TokyoNight defaults.
				on_highlights = function(hl, c)
					hl["@markup.raw.markdown_inline"] = { fg = c.cyan }         -- code, no bg
					hl["@markup.strong"] = { fg = c.yellow, bold = true }       -- bold
				end,
			})
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
}
