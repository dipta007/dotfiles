local config = function()
  require('nvim-treesitter.configs').setup {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      'bash',
      'c',
      'html',
      'javascript',
      'json',
      'lua',
      'luadoc',
      'luap',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'regex',
      'rust',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
      'dockerfile',
      'terraform',
      'sql',
      'csv',
      'tsv',
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
  }

  local parsers = require 'nvim-treesitter.parsers'
  function _G.ensure_treesitter_language_installed()
    local lang = parsers.get_buf_lang()
    if parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) then
      vim.schedule_wrap(function()
        vim.cmd('TSInstall ' .. lang)
      end)()
    end
  end
end

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = config,
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
}
