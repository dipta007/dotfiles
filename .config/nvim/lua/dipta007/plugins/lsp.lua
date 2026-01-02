local servers = {
	-- clangd = {},
	-- gopls = {},
	-- copilot = {},
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
	-- rust_analyzer = {},
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
	yamlls = {
		settings = {
			yaml = {
				schemas = {
					kubernetes = "*.yaml",
					["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
					["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
					["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
				},
			},
		},
	},

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

local config = function()
	-- Setup LSP keymaps on attach
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
		callback = function(ev)
			local bufnr = ev.buf

			local nmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

			nmap("<leader>ld", vim.diagnostic.open_float, "[L]oad Diagnostic")
			nmap("[d", vim.diagnostic.goto_prev)
			nmap("]d", vim.diagnostic.goto_next)

			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")

			nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
			nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
			nmap("<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "[W]orkspace [L]ist Folders")

			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				vim.lsp.buf.format()
			end, { desc = "Format current buffer with LSP" })
		end,
	})

	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = { "*.py", "*.js", "*.ts" },
		callback = function()
			vim.lsp.buf.format({ async = false })
		end,
	})

	local capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
		},
	}

	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

	-- Ensure the servers are installed via mason
	local mason_lspconfig = require("mason-lspconfig")
	mason_lspconfig.setup({
		ensure_installed = vim.tbl_keys(servers),
	})

	-- Configure each server using the new Neovim 0.11+ API
	for server_name, server_config in pairs(servers) do
		server_config.capabilities = require("blink.cmp").get_lsp_capabilities(server_config.capabilities)
		vim.lsp.config(server_name, server_config)
	end

	-- Enable all configured servers
	vim.lsp.enable(vim.tbl_keys(servers))
end

return {
	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	config = config,
	enabled = true,
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ "williamboman/mason.nvim", config = true },
		{ "williamboman/mason-lspconfig.nvim", version = "*" },
		"saghen/blink.nvim",
		-- JSON schemas for jsonls
		"b0o/schemastore.nvim",
	},
}
