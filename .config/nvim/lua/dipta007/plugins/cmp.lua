vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append 'c'

local config = function()
  local cmp = require 'cmp'
  cmp.setup {
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
      -- { name = 'luasnip' },
    },
    mapping = {
      ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      ['<CR>'] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { 'i', 'c' }
      ),
    },
  }
end

return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  enabled = false,
  config = config,
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    -- Snippet Engine & its associated nvim-cmp source
    -- "L3MON4D3/LuaSnip",
    -- {
    --     "L3MON4D3/LuaSnip",
    --     -- follow latest release.
    --     version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    --     -- install jsregexp (optional!).
    --     -- build = "make install_jsregexp"
    -- },
    -- "saadparwaiz1/cmp_luasnip",

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
  },
}
