-- settings
local o = vim.o
local bo = vim.bo
local wo = vim.wo
local g = vim.g
local opt = vim.opt

-- general settings
--- useful for searching
o.ignorecase = true
o.smartcase = true

--- tab related
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.expandtab = true

--- don't want any backup or swap files
-- o.backup = false
-- o.wb = false
-- o.swapfile = false

-- fold settings
-- needed for ufo plugin to work
-- o.foldcolumn = '1'
-- o.foldlevel = 99
-- o.foldlevelstart = -1
-- o.foldenable = true

-- window local settings
--- show numbers (relatively)
wo.number = true
wo.relativenumber = true

--- highlight 88th column
wo.colorcolumn = '88'

--- always show signcolumn
wo.signcolumn = 'yes'
wo.linebreak = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
g.have_nerd_font = true

-- Enable mouse mode, can be useful for resizing splits for example!
opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Decrease update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
opt.inccommand = 'split'

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
opt.confirm = true
