local config = function()
  require('nvim-treesitter.configs').setup {
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
          ['ab'] = '@block.outer',
          ['ib'] = '@block.inner',
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          -- ["]m"] = "@function.outer",
          -- ["]]"] = "@class.outer",
          [']f'] = '@function.outer',
          [']c'] = '@class.outer',
          [']a'] = '@parameter.outer',
          [']i'] = '@conditional.outer',
          [']l'] = '@loop.outer',
          [']b'] = '@block.outer',
          [']s'] = '@statement.outer',
        },
        goto_next_end = {
          -- ["]M"] = "@function.outer",
          -- ["]["] = "@class.outer",
          [']F'] = '@function.outer',
          [']C'] = '@class.outer',
          [']A'] = '@parameter.outer',
          [']I'] = '@conditional.outer',
          [']L'] = '@loop.outer',
          [']B'] = '@block.outer',
          [']S'] = '@statement.outer',
        },
        goto_previous_start = {
          -- ["[m"] = "@function.outer",
          -- ["[["] = "@class.outer",
          ['[f'] = '@function.outer',
          ['[c'] = '@class.outer',
          ['[a'] = '@parameter.outer',
          ['[i'] = '@conditional.outer',
          ['[l'] = '@loop.outer',
          ['[b'] = '@block.outer',
          ['[s'] = '@statement.outer',
        },
        goto_previous_end = {
          -- ["[M"] = "@function.outer",
          -- ["[]"] = "@class.outer",
          ['[F'] = '@function.outer',
          ['[C'] = '@class.outer',
          ['[A'] = '@parameter.outer',
          ['[I'] = '@conditional.outer',
          ['[L'] = '@loop.outer',
          ['[B'] = '@block.outer',
          ['[S'] = '@statement.outer',
        },
      },
    },
  }
end

return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  event = 'VeryLazy',
  config = config,
}
