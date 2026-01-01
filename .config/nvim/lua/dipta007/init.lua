-- shamelessly copied from https://github.com/trifiasco/dotfiles/

-- absolute basic
-- map leader is required by lazy.nvim
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Turns off netrw (default file explorer) in favor of nvim-tree or other plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- ================= START: PLUGIN MANAGER SETUP =====================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
-- ================= END: PLUGIN MANAGER SETUP =======================================

-- ================= START: PLUGINS ==================================================
require('lazy').setup({ import = 'dipta007.plugins' }, {
  change_detection = {
    notify = true,
  },
  checker = { enabled = true }
})
-- ================= END: PLUGINS ==================================================

require 'dipta007.core'
