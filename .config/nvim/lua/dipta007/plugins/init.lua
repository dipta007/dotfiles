return {
  {
    'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup()
    end,
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { "tpope/vim-fugitive" },
  {
    'numToStr/FTerm.nvim',
    enabled = not vim.g.vscode,
    config = function()
      require('FTerm').setup {
        border = 'double',
        dimensions = {
          height = 0.9,
          width = 0.9,
        },
      }
    end,
  },
}
