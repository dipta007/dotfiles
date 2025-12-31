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
imap({ "kj", "<ESC>" })
nimap({ "<D-s>", "<CMD>w!<CR>", opts_noremap })
nmap({ ";", ":", opts_noremap })
-- nmap{'<leader>q', ':bd!<CR>'}

--> Navigator - vim-tmux-navigator
nmap({ "<C-h>", "<CMD>lua require('Navigator').left()<CR>", opts_noremap_silent })
nmap({ "<C-k>", "<CMD>lua require('Navigator').up()<CR>", opts_noremap_silent })
nmap({ "<C-l>", "<CMD>lua require('Navigator').right()<CR>", opts_noremap_silent })
nmap({ "<C-j>", "<CMD>lua require('Navigator').down()<CR>", opts_noremap_silent })
nmap({ "<C-\\>", "<CMD>lua require('Navigator').previous()<CR>", opts_noremap_silent })

-- window management
nmap({ "<leader>sv", "<C-w>v", opts_noremap }) -- split window vertically
nmap({ "<leader>sh", "<C-w>s", opts_noremap }) -- split window horizontally
nmap({ "<leader>se", "<C-w>=", opts_noremap }) -- make split windows equal width & height
nmap({ "<leader>sx", "<cmd>close<CR>", opts_noremap }) -- close current split window

-- tab management
-- nmap({ "<leader>to", "<cmd>tabnew<CR>", opts_noremap }) -- open new tab
-- nmap({ "<leader>tx", "<cmd>tabclose<CR>", opts_noremap }) -- close current tab
-- nmap({ "<leader>tn", "<cmd>tabn<CR>", opts_noremap }) -- go to next tab
-- nmap({ "<leader>tp", "<cmd>tabp<CR>", opts_noremap }) -- go to previous tab
-- nmap({ "<leader>tf", "<cmd>tabnew %<CR>", opts_noremap }) -- move current buffer to new tab

-- -- Neotree Keymaps
if not vim.g.vscode then
	nmap({ "<C-n>", "<cmd> Neotree filesystem reveal float toggle<CR>", opts_noremap })
	nmap({ "<C-b>", "<cmd> Neotree filesystem reveal left toggle<CR>", opts_noremap })
end

--> fugitive - git stuff
if not vim.g.vscode then
	nmap({ "<leader>gs", "<CMD> Git<CR>", opts_noremap_silent })
	nmap({ "<leader>gb", "<CMD> Git blame<CR>", opts_noremap_silent })
	nmap({ "<leader>gv", "<CMD> Gvdiffsplit<CR>", opts_noremap_silent })
end

-- -- Terminal related
if not vim.g.vscode then
	vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts_noremap_silent)
	-- Can directly map to keys, but better to expose the commands as a vim user command
	-- Close Vs Exit: Close doesn't kill the process, Exit does
	vim.api.nvim_create_user_command("FTermOpen", require("FTerm").open, { bang = true })
	vim.api.nvim_create_user_command("FTermClose", require("FTerm").close, { bang = true })
	vim.api.nvim_create_user_command("FTermExit", require("FTerm").exit, { bang = true })
	vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })

	nmap({ "<localleader>tt", "<CMD>FTermToggle<CR>", opts_noremap_silent })
	nmap({ "<localleader>tx", "<CMD>FTermExit<CR>", opts_noremap_silent })
	nmap({ "<localleader>tc", "<CMD>FTermClose<CR>", opts_noremap_silent })
end

-- LSP related mappings
-- :Format is an custom user-command. It's basically calling vim.lsp.buf.format()
nmap({ "<leader>lf", "<CMD>Format<CR>", opts_noremap_silent })

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
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
