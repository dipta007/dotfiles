--[[
   this file will contain keybindings
   api to set keybindings is - vim.api.nvim_set_keymap
]]

-- Note: two ways to setup keymap
-- vim.keymap.set - default opts = {noremap = true}
-- vim.api.nvim_set_keymap - no default opts
local maps = require 'dipta007.utils'
local imap = maps.imap
local nmap = maps.nmap
local nimap = maps.nimap

local opts_noremap_silent = { noremap = true, silent = true }
local opts_noremap = { noremap = true, silent = false }

-- Things I can't live without
nmap { '<D-s>', ':w!<CR>', opts_noremap }
nmap { ';', ':', opts_noremap }
-- nmap{'<leader>q', ':bd!<CR>'}

-- reload stuff that almost never works
nmap { '<leader>r', ':Lazy reload ' }
nmap { '<leader><leader>x', ': source %<CR>' }

-- opens/close quickfix list
-- nmap { '<leader>c', ':copen<cr>' }
-- nmap { '<leader>x', ':cclose<cr>' }

-- toggle highlight last search
-- nmap { '<leader>n', ':set hlsearch!<cr>' }

--> Navigator - vim-tmux-navigator
nmap { '<C-h>', "<CMD>lua require('Navigator').left()<CR>", opts_noremap_silent }
nmap { '<C-k>', "<CMD>lua require('Navigator').up()<CR>", opts_noremap_silent }
nmap { '<C-l>', "<CMD>lua require('Navigator').right()<CR>", opts_noremap_silent }
nmap { '<C-j>', "<CMD>lua require('Navigator').down()<CR>", opts_noremap_silent }
nmap { '<C-\\>', "<CMD>lua require('Navigator').previous()<CR>", opts_noremap_silent }

-- -- Neotree Keymaps
nmap { '<C-n>', '<cmd> Neotree filesystem reveal float toggle<CR>', opts_noremap }
nmap { '<C-b>', '<cmd> Neotree filesystem reveal left toggle<CR>', opts_noremap }

-- Telescope Keymaps
-- local builtin = require 'telescope.builtin'
-- nmap { '<leader>t', builtin.find_files, {} }
-- nmap { '<leader>f', builtin.live_grep, {} }
-- nmap { '<leader>b', builtin.buffers, {} }
-- nmap { '<leader>h', builtin.help_tags, {} }

--> fugitive - git stuff
-- nmap { '<leader>gs', '<CMD> Git<CR>', opts_noremap_silent }
-- nmap { '<leader>gb', '<CMD> Git blame<CR>', opts_noremap_silent }
-- nmap { '<leader>gv', '<CMD> Gvdiffsplit<CR>', opts_noremap_silent }
--
-- nmap {'<leader>p', [[<cmd>lua require('nabla').popup()<CR>]], opts_noremap_silent}
--
-- -- telekasten keymaps
-- nmap { '<leader>zf', [[<cmd>lua require('telekasten').find_notes()<CR>]], opts_noremap_silent }
-- nmap { '<leader>zd', [[<cmd>lua require('telekasten').find_daily_notes()<CR>]], opts_noremap_silent }
-- nmap { '<leader>zw', [[<cmd>lua require('telekasten').find_weekly_notes()<CR>]], opts_noremap_silent }
-- nmap { '<leader>zg', [[<cmd>lua require('telekasten').search_notes()<CR>]], opts_noremap_silent }
--
-- nmap { '<leader>zT', [[<cmd>lua require('telekasten').goto_today()<CR>]], opts_noremap_silent }
-- nmap { '<leader>zW', [[<cmd>lua require('telekasten').goto_thisweek()<CR>]], opts_noremap_silent }
--
-- nmap { '<leader>zn', [[<cmd>lua require('telekasten').new_note()<CR>]], opts_noremap_silent }
-- nmap { '<leader>zN', [[<cmd>lua require('telekasten').new_template_note()<CR>]], opts_noremap_silent }
--
-- nmap { '<leader>zt', [[<cmd>lua require('telekasten').toggle_todo()<CR>]], opts_noremap_silent }
--
-- nmap { '<leader>zr', [[<cmd>lua require('telekasten').rename_note()<CR>]], opts_noremap_silent }
-- nmap { '<leader>za', [[<cmd>lua require('telekasten').show_tags()<CR>]], opts_noremap_silent }
-- nmap { '<leader>zb', [[<cmd>lua require('telekasten').show_backlinks()<CR>]], opts_noremap_silent }
-- nmap { '<leader>zF', [[<cmd>lua require('telekasten').find_friends()<CR>]], opts_noremap_silent }
-- nmap { '<leader>zz', [[<cmd>lua require('telekasten').follow_link()<CR>]], opts_noremap_silent }
--
-- nmap { '<leader>z', [[<cmd>lua require('telekasten').panel()<CR>]], opts_noremap_silent }

-- -- Terminal related
vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]], opts_noremap_silent)
-- Can directly map to keys, but better to expose the commands as a vim user command
-- Close Vs Exit: Close doesn't kill the process, Exit does
vim.api.nvim_create_user_command('FTermOpen', require('FTerm').open, { bang = true })
vim.api.nvim_create_user_command('FTermClose', require('FTerm').close, { bang = true })
vim.api.nvim_create_user_command('FTermExit', require('FTerm').exit, { bang = true })
vim.api.nvim_create_user_command('FTermToggle', require('FTerm').toggle, { bang = true })

nmap { '<localleader>tt', '<CMD>FTermToggle<CR>', opts_noremap_silent }
nmap { '<localleader>tx', '<CMD>FTermExit<CR>', opts_noremap_silent }
nmap { '<localleader>tc', '<CMD>FTermClose<CR>', opts_noremap_silent }

-- TODO: scratch terminal for ephimeral build commands. Possibilities are endless

-- TODO: custom terminal to attach things like btop, lazygit etc.
-- LSP related mappings
-- :Format is an custom user-command. It's basically calling vim.lsp.buf.format()
nmap { '<leader>lf', '<CMD>Format<CR>', opts_noremap_silent }

-- Shamelessly copying from the primeagen
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- delete/paste without overwriting the current register
vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
