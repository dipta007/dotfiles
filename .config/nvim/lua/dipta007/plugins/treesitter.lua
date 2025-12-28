return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    -- Enable treesitter highlighting and indentation (built into Neovim)
    vim.treesitter.language.register('markdown', 'mdx')

    -- Auto-install parsers when opening files
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- Incremental selection keymaps
    vim.keymap.set('n', '<C-space>', function()
      require('nvim-treesitter.incremental_selection').init_selection()
    end, { desc = 'Init treesitter selection' })
    vim.keymap.set('x', '<C-space>', function()
      require('nvim-treesitter.incremental_selection').node_incremental()
    end, { desc = 'Increment treesitter selection' })
    vim.keymap.set('x', '<bs>', function()
      require('nvim-treesitter.incremental_selection').node_decremental()
    end, { desc = 'Decrement treesitter selection' })
  end,
}
