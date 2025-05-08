return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    require('mini.comment').setup { options = { ignore_blank_line = true } }
    require('mini.pairs').setup()
    if not vim.g.vscode then
      require('mini.animate').setup()
    end

    require('mini.indentscope').setup {
      symbol = '│',
      options = { try_as_border = true },
      draw = { animation = require('mini.indentscope').gen_animation.none() },
    }
    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
