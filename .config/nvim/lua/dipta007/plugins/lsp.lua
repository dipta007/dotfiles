local servers = {
	ruff = {
		cmd = { "ruff", "server" },
		filetypes = { "python" },
		settings = {
			ruff = {
				lint = {
					enabled = true,
				},
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
				diagnostics = {
					globals = { "vim" },
				},
				defaultConfig = {
					indent_style = "space",
					indent_size = "2",
				},
			},
		},
	},

	-- JSON (for config files)
	jsonls = {
		settings = {
			json = {
				schemas = (function()
					local ok, schemastore = pcall(require, "schemastore")
					if ok then
						return schemastore.json.schemas()
					end
					return {}
				end)(),
				validate = { enable = true },
			},
		},
	},

	-- YAML (for config files, k8s, CI/CD)
	-- yamlls = {
	-- 	settings = {
	-- 		yaml = {
	-- 			schemas = {
	-- 				kubernetes = "*.yaml",
	-- 				["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
	-- 				["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
	-- 				["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
	-- 			},
	-- 		},
	-- 	},
	-- },

	-- Bash/Shell scripts
	bashls = {},

	-- Docker
	dockerls = {},
	docker_compose_language_service = {},

	-- TOML (for pyproject.toml)
	taplo = {},

	-- Markdown
	marksman = {},
}

return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"saghen/blink.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			-- Add blink.cmp capabilities + folding range to each server
			local capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			}

			for server_name, server_config in pairs(servers) do
				server_config.capabilities = require("blink.cmp").get_lsp_capabilities(
					vim.tbl_deep_extend("force", capabilities, server_config.capabilities or {})
				)
				vim.lsp.config(server_name, server_config)
			end

			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},
}
