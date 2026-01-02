return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'catppuccin/nvim',
  enabled = true,
  name = 'catppuccin',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    require("catppuccin").setup {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = true,
      term_colors = true,
      auto_integrations = true,
      float = {
        border = "rounded",
        transparent = true,
        solid = true,
      }
    }
    vim.cmd.colorscheme 'catppuccin-mocha'
  end,
}
