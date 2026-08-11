-- Detect a vault from a buffer: walk up its path for a `.obsidian/` folder,
-- the same marker obsidian.nvim uses (workspace.lua find_vault_root).
local function detect_vault(buf)
	local file = vim.api.nvim_buf_get_name(buf or 0)
	if file == "" then
		return nil
	end
	return vim.fs.root(file, ".obsidian")
end

return {
	"obsidian-nvim/obsidian.nvim",
	enabled = vim.g.is_local,
	version = "*", -- use latest release, remove to use latest commit
	lazy = true, -- loaded on demand by the init autocmd below.
	-- Load obsidian only when a markdown file that lives in a vault is opened,
	-- no matter where nvim launched (parent dir, picker, :e later). Non-vault
	-- markdown never triggers load, so setup() is never called without a
	-- workspace (which errors). Detection walks UP from the file for .obsidian.
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(ev)
				-- already loaded? nothing to do; its own autocmds handle the buffer.
				if package.loaded["obsidian"] then
					return
				end
				if not detect_vault(ev.buf) then
					return
				end
				require("lazy").load({ plugins = { "obsidian.nvim" } })
				-- lazy.load ran config()+setup(), which registered obsidian's
				-- FileType->BufEnter autocmds (group obsidian_setup). They did NOT
				-- fire for this already-open buffer, so drive that group manually to
				-- wire keymaps + start the LSP. Targeted group avoids re-run loops.
				vim.api.nvim_exec_autocmds("FileType", { buffer = ev.buf, group = "obsidian_setup", modeline = false })
				vim.api.nvim_exec_autocmds("BufEnter", { buffer = ev.buf, group = "obsidian_setup", modeline = false })
			end,
		})
	end,
	config = function(_, opts)
		require("obsidian").setup(opts)
		-- Conceal markup only for vault notes, keyed on obsidian's own event
		-- (fires when entering a vault note), not a fixed path.
		vim.api.nvim_create_autocmd("User", {
			pattern = "ObsidianNoteEnter",
			callback = function()
				vim.opt_local.conceallevel = 2
			end,
		})
	end,
	opts = {
		legacy_commands = false, -- this will be removed in the next major release
		workspaces = {
			-- Dynamic: resolve to the vault of the current buffer at setup time.
			{
				name = "personal",
				path = function()
					return detect_vault() or vim.fn.getcwd()
				end,
			},
		},
		templates = {
			folder = "Templates",
		},
		attachments = {
			folder = "Files",
		},
		checkbox = {
			enabled = true,
			create_new = false,
			-- order = { " ", "~", "!", ">", "x" },
			order = { " ", "x" },
		},
		comment = {
			enabled = true,
		},
		frontmatter = {
			enabled = true,
			sort = { "dg-publish", "dg-note-icon", "id", "aliases", "tags" },
		},
	},
}
