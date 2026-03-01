-- [[ LSP Configuration — Neovim 0.11+ native API ]]

-- Buffer-local keymaps when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach-keymaps", { clear = true }),
	callback = function(event)
		local bufnr = event.buf
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

		map("<leader>ld", vim.diagnostic.open_float, "Line Diagnostic")
		map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
		map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")

		-- Navigation keymaps (gd, gr, gi, etc.) handled by snacks.lua pickers

		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("<leader>k", vim.lsp.buf.signature_help, "Signature Help")
	end,
})

-- Helper: detect python venv path
local function get_python_path(workspace)
	-- Case 1: activated virtual env
	if vim.env.VIRTUAL_ENV then
		return vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
	end

	-- Case 2: .venv in project root
	if workspace then
		local root = vim.fs.root(workspace, ".git") or workspace
		local venv = vim.fs.joinpath(root, ".venv")
		if vim.uv.fs_stat(venv) then
			return vim.fs.joinpath(venv, "bin", "python")
		end
	end

	-- Case 3: system fallback
	return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

local config = function()
	-- Mason: install LSP servers
	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = { "pyright", "ruff", "lua_ls", "jsonls", "bashls", "taplo", "marksman" },
		-- mason-lspconfig 2.x: automatic_enable is on by default,
		-- but we exclude rust_analyzer since rustaceanvim handles it
		automatic_enable = {
			exclude = { "rust_analyzer" },
		},
	})

	-- Shared capabilities: blink.cmp + folding range for nvim-ufo
	vim.lsp.config("*", {
		capabilities = vim.tbl_deep_extend(
			"force",
			require("blink.cmp").get_lsp_capabilities({}, true),
			{
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			}
		),
	})

	-- Server configs
	vim.lsp.config("pyright", {
		single_file_support = true,
		settings = {
			pyright = {
				disableOrganizeImports = true,
			},
			python = {
				analysis = {
					-- using ruff for linting
					ignore = { "*" },
				},
			},
		},
		on_init = function(client)
			client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
		end,
	})

	vim.lsp.config("ruff", {
		cmd = { "ruff", "server" },
		filetypes = { "python" },
		settings = {
			ruff = {
				lint = {
					enabled = true,
				},
			},
		},
	})

	-- rust_analyzer is NOT configured here — rustaceanvim manages it entirely

	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
				diagnostics = {
					globals = { "vim", "Snacks" },
				},
				defaultConfig = {
					indent_style = "space",
					indent_size = "2",
				},
			},
		},
	})

	vim.lsp.config("jsonls", {
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
	})

	-- Enable servers
	vim.lsp.enable({ "pyright", "ruff", "lua_ls", "jsonls", "bashls", "taplo", "marksman" })
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "saghen/blink.cmp" },
		{ "b0o/schemastore.nvim" },
	},
}
