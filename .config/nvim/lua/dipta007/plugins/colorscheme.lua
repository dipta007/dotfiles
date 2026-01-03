return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
    require("gruvbox").setup({
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "soft", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = true,
    })
    vim.g.gruvbox_italic = 1
    vim.cmd([[colorscheme gruvbox]])
  end,
}

-- return { -- You can easily change to a different colorscheme.
--   -- Change the name of the colorscheme plugin below, and then
--   -- change the command in the config to whatever the name of that colorscheme is.
--   --
--   'catppuccin/nvim',
--   enabled = true,
--   name = 'catppuccin',
--   priority = 1000, -- Make sure to load this before all the other start plugins.
--   config = function()
--     require("catppuccin").setup {
--       flavour = "mocha", -- latte, frappe, macchiato, mocha
--       transparent_background = true,
--       term_colors = true,
--       auto_integrations = true,
--       float = {
--         border = "rounded",
--         transparent = true,
--         solid = true,
--       }
--     }
--     vim.cmd.colorscheme 'catppuccin-mocha'
--   end,
-- }
