return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- use latest release, remove to use latest commit
	ft = "markdown",
	config = function(_, opts)
		require("obsidian").setup(opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.opt_local.conceallevel = 2
			end,
		})
		vim.opt_local.conceallevel = 2
	end,
	opts = {
		legacy_commands = false, -- this will be removed in the next major release
		workspaces = {
			{
				name = "personal",
				path = "/Users/dipta007/Library/Mobile Documents/iCloud~md~obsidian/Documents/DeepBrain/",
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
