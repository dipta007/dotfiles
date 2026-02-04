return {
  'lewis6991/gitsigns.nvim',
  enabled = true,
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  --   on_attach = function(bufnr)
  --     local gs = require('gitsigns')

  --     local function map(mode, l, r, desc)
  --       vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
  --     end

  --     -- Stage hunk (works with visual selection for partial staging)
  --     map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
  --     map('v', '<leader>hs', function()
  --       gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  --     end, 'Stage selected lines')

  --     -- Undo staged hunk
  --     map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')

  --     -- Reset hunk (discard changes)
  --     map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
  --     map('v', '<leader>hr', function()
  --       gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  --     end, 'Reset selected lines')

  --     -- Stage/reset entire buffer
  --     map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
  --     map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')

  --     -- Blame
  --     map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
  --     map('n', '<leader>hB', gs.toggle_current_line_blame, 'Toggle line blame')

  --     -- Diff
  --     map('n', '<leader>hd', gs.diffthis, 'Diff against index')
  --     map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff against last commit')
  --   end,
  },
}
