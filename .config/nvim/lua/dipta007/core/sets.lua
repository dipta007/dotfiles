-- settings
local o = vim.o
local wo = vim.wo
local g = vim.g
local opt = vim.opt

-- general settings
opt.clipboard = "unnamedplus"

--- useful for searching
o.ignorecase = true
o.smartcase = true

--- tab related
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.expandtab = true
o.autoindent = true

-- appearance
opt.termguicolors = true
opt.background = "dark"

-- backspace
opt.backspace = "indent,eol,start"

--- don't want any backup or swap files
o.backup = false
o.wb = false
o.swapfile = false

-- fold settings
-- needed for ufo plugin to work
o.foldcolumn = "1"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

-- window local settings
--- show numbers (relatively)
wo.number = true
wo.relativenumber = true

--- highlight 120th column
wo.colorcolumn = "120"

--- show sign column always
wo.signcolumn = "yes"

--- enable line wrapping
wo.linebreak = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
g.have_nerd_font = true

-- Enable mouse mode, can be useful for resizing splits for example!
opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

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
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
opt.inccommand = "split"

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
opt.confirm = true
