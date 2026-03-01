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
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function()
    require("bufferline").go_to(i, true)
  end, { silent = true })
end

-- buffer management
nmap({ "]b", "<cmd>bnext<CR>", opts_noremap })
nmap({ "[b", "<cmd>bprevious<CR>", opts_noremap })
nmap({ "<leader><tab>", "<cmd>b#<CR>", opts_noremap }) -- Toggle last buffer
nmap({ "<leader>bn", "<cmd>enew<CR>", opts_noremap }) -- New buffer

vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts_noremap_silent)

-- LSP keymaps (global LspAttach autocmd — no plugin dependency)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach-keymaps", { clear = true }),
	callback = function(ev)
		local bufnr = ev.buf
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("<leader>ld", vim.diagnostic.open_float, "Line Diagnostic")
		map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
		map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")
		map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
		map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
		map("<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "Workspace List Folders")

	end,
})

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
