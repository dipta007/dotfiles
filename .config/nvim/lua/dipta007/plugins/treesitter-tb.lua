local config = function()
  require('nvim-treesitter.configs').setup {
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
          ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
          ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
          ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

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
          [']f'] = '@function.outer',
          [']c'] = '@class.outer',
          [']a'] = '@parameter.outer',
          [']i'] = '@conditional.outer',
          [']l'] = '@loop.outer',
          [']b'] = '@block.outer',
          [']s'] = '@statement.outer',
        },
        goto_next_end = {
          [']F'] = '@function.outer',
          [']C'] = '@class.outer',
          [']A'] = '@parameter.outer',
          [']I'] = '@conditional.outer',
          [']L'] = '@loop.outer',
          [']B'] = '@block.outer',
          [']S'] = '@statement.outer',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
          ['[c'] = '@class.outer',
          ['[a'] = '@parameter.outer',
          ['[i'] = '@conditional.outer',
          ['[l'] = '@loop.outer',
          ['[b'] = '@block.outer',
          ['[s'] = '@statement.outer',
        },
        goto_previous_end = {
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
  lazy = true,
  config = config,
}
