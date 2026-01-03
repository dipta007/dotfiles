return {
  {
    'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup()
    end,
  },
  {
    'numToStr/FTerm.nvim',
    enabled = true,
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
