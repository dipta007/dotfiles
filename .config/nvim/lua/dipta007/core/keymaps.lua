-- Note: two ways to setup keymap
-- vim.keymap.set - default opts = {noremap = true}
-- vim.api.nvim_set_keymap - no default opts
local maps = require("dipta007.utils")
local imap = maps.imap
local nmap = maps.nmap
local nimap = maps.nimap

local opts_noremap_silent = { noremap = true, silent = true }
local opts_noremap = { noremap = true, silent = false }

-- Things I can't live without
nimap({ "<D-s>", "<CMD>w!<CR>", opts_noremap })
nmap({ "<leader>w", "<CMD>w!<CR>", opts_noremap })

-- window management
nmap({ "<leader>wv", "<C-w>v", opts_noremap }) -- split window vertically
nmap({ "<leader>wh", "<C-w>s", opts_noremap }) -- split window horizontally
nmap({ "<leader>we", "<C-w>=", opts_noremap }) -- make split windows equal width & height
nmap({ "<leader>wx", "<cmd>close<CR>", opts_noremap }) -- close current split window

-- tab management
nmap({ "<leader>to", "<cmd>tabnew<CR>", opts_noremap }) -- open new tab
nmap({ "<leader>td", "<cmd>tabclose<CR>", opts_noremap }) -- close current tab
nmap({ "<leader>tn", "<cmd>tabn<CR>", opts_noremap }) -- go to next tab
nmap({ "<leader>tp", "<cmd>tabp<CR>", opts_noremap }) -- go to previous tab
nmap({ "<leader>tf", "<cmd>tabnew %<CR>", opts_noremap }) -- move current buffer to new tab

-- buffer management
nmap({ "]b", "<cmd>bnext<CR>", opts_noremap })
nmap({ "[b", "<cmd>bprevious<CR>", opts_noremap })
nmap({ "<leader><tab>", "<cmd>b#<CR>", opts_noremap }) -- Toggle last buffer
nmap({ "<leader>bn", "<cmd>enew<CR>", opts_noremap }) -- New buffer

vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts_noremap_silent)


-- Move by screen row on wrapped lines, but keep real-line jumps when a count
-- is given (e.g. 5j) so the jumplist still works.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Shamelessly copying from the primeagen
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- delete/paste without overwriting the current register
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist() end, { desc = "Open diagnostic [Q]uickfix list" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Jump to last edit position when reopening a file.
-- Skip commit msgs (want top) and buffers where the mark is past EOF.
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Restore last cursor position",
	group = vim.api.nvim_create_augroup("last-edit-pos", { clear = true }),
	callback = function(args)
		if vim.bo[args.buf].filetype == "gitcommit" then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line = mark[1]
		if line > 0 and line <= vim.api.nvim_buf_line_count(args.buf) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Rebalance splits when the terminal window is resized.
vim.api.nvim_create_autocmd("VimResized", {
	desc = "Equalize splits on resize",
	group = vim.api.nvim_create_augroup("resize-splits", { clear = true }),
	command = "tabdo wincmd =",
})
