-- Vault path resolves per-machine via ~ (username differs: roydipta / dipta007 / sroy).
local vault = vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/DeepBrain"
-- Only enable when the vault actually exists on this machine (work machines have no vault).
local has_vault = vim.fn.isdirectory(vault) == 1

return {
	"obsidian-nvim/obsidian.nvim",
  enabled = vim.g.is_local and has_vault,
	version = "*", -- use latest release, remove to use latest commit
	ft = "markdown",
	config = function(_, opts)
		require("obsidian").setup(opts)
		-- Conceal markup ONLY for vault files (pattern-scoped, not all markdown).
		-- obsidian's own UI already self-scopes to the vault via find_workspace.
		vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
			pattern = vault .. "/**.md",
			callback = function()
				vim.opt_local.conceallevel = 2
			end,
		})
	end,
	opts = {
		legacy_commands = false, -- this will be removed in the next major release
		workspaces = {
			{
				name = "personal",
				path = vault,
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
