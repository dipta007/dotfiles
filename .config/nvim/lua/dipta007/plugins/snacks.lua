return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		animate = {
			enabled = vim.fn.has("nvim-0.10") >= 1,
			easing = "in_out_sine",
			duration = {
				step = 20,
				total = 150,
			},
		},
		bigfile = {
      notify = true,
      size = 10 * 1024 * 1024, -- 10 MB
      line_length = 5000, -- 5k characters
      enabled = true
    },
		dashboard = { enabled = true },
		explorer = {
      enabled = true,
      replace_netrw = true,
    },
		indent = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 7000,
		},
		picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
        }
      },
      enabled = true
    },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		zen = {
			enabled = true,
			toggles = {
				dim = false,
			},
		},
		statuscolumn = { enabled = true },
		words = { enabled = true },
		styles = {
			notification = {
				wo = { wrap = true } -- Wrap notifications
			},
		},
	},
	keys = {
    -- Todo Comments
		{ "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo Comments" },
		{ "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },

		-- Top Pickers & Explorer
		{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
		{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>e", function() Snacks.explorer({ path = vim.fn.expand("%:p:h") }) end, desc = "Toggle Explorer" },

    -- git
		{ "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gB", function() Snacks.picker.git_blame() end, desc = "Git Blame" },
		{ "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
		{ "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
		{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
		{ "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
		{ "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
		{ "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
		-- { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    
		-- gh
		-- { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
		-- { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
		-- { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
		-- { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },

		-- search (active)
		{ "<leader>sh", function() Snacks.picker.help() end, desc = "[S]earch [H]elp" },
		{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "[S]earch [K]eymaps" },
		{ "<leader>sf", function() Snacks.picker.files() end, desc = "[S]earch [F]iles" },
		{ "<leader>sg", function() Snacks.picker.grep() end, desc = "[S]earch by [G]rep" },
		{ "<leader>sb", function() Snacks.picker.buffers() end, desc = "[S]earch [B]uffers" },
		{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "[S]earch [D]iagnostics" },
		{ "<leader>sr", function() Snacks.picker.resume() end, desc = "[S]earch [R]esume" },
		{ "<leader>sp", function() Snacks.picker.projects() end, desc = "Projects" },
		{ "<leader>sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },

		-- LSP
		{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
		{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
		{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
		{ "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
		{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
		{ "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
		{ "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
		{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
		{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

    -- Buffer
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
		{ "<leader>br", function() Snacks.rename.rename_file() end, desc = "Rename File" },

		-- Other
		{ "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
		{ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
		{ "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
		{ "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		-- { "<leader>j",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
		-- { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		-- { "<c-_>\",      function() Snacks.terminal() end, desc = \"which_key_ignore\" },
		-- { \"]]\",         function() Snacks.words.jump(vim.v.count1) end, desc = \"Next Reference\", mode = { \"n\", \"t\" } },
		-- { \"[[\",         function() Snacks.words.jump(-vim.v.count1) end, desc = \"Prev Reference\", mode = { \"n\", \"t\" } },
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end

				-- Override print to use snacks for `:=` command
				if vim.fn.has("nvim-0.11") == 1 then
					vim._print = function(_, ...)
						dd(...)
					end
				else
					vim.print = _G.dd
				end

				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
