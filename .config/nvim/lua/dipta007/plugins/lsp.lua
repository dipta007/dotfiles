-- -- [[ Configure LSP ]]
-- --  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('<leader>ld', ':lua vim.diagnostic.open_float()<CR>', '[L]oad Diagnostic')
  nmap('[d', ':lua vim.diagnostic.goto_prev()<CR>')
  nmap(']d', ':lua vim.diagnostic.goto_next()<CR>')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  --    gopls = {
  --        filetypes = { "go", "gomod" },
  --        settings = {
  --            gopls = {
  --                analyses = {
  --                    unusedparams = true,
  --                },
  --                staticcheck = true,
  --            },
  --        },
  --    },
  pyright = {
    single_file_support = true,
    settings = {
      pyright = {
        -- disableLanguageServices = true,
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- using ruff for linting
          ignore = { '*' },
          -- autoImportCompletions = true,
          -- autoSearchPaths = true,
          -- diagnosticMode = "workspace", -- openFilesOnly, workspace
          -- typeCheckingMode = "basic", -- off, basic, strict
          -- useLibraryCodeForTypes = true,
        },
      },
    },
  },
  ruff = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    settings = {
      ruff = {
        lint = {
          enabled = true,
        },
      },
    },
  },
  -- install rust_analyzer manually from: rustup component add rust-analyzer rustfmt
  -- don't call setup for rust_analyzer, local rust_analyzer will be picked up automatically by rustacean.nvim
  -- rust_analyzer = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      defaultConfig = {
        indent_style = 'space',
        indent_size = '2',
      },
    },
  },
}

-- setup null-ls to handle linting and formatting
-- require("null-ls").setup({
-- 	sources = {
-- 		require("null-ls").builtins.formatting.stylua,
-- 		require("null-ls").builtins.formatting.isort,
-- 		require("null-ls").builtins.formatting.black,
-- 	},
-- })

local config = function()
  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  local util = require 'lspconfig/util'
  local path = util.path

  local function get_python_path(workspace)
    -- [ref1](https://github.com/neovim/nvim-lspconfig/issues/500)
    -- [ref2](https://github.com/VonHeikemen/lsp-zero.nvim/issues/195)

    -- Case 01:
    -- check if there's already an activated virtual env
    -- from manual activation or pyenv local
    if vim.env.VIRTUAL_ENV then
      return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end

    -- Case 02:
    -- we can search the workspace directory for virtual env
    -- even if it's not activated, we can point pyright to that
    -- and we will have LSP functionalities without explicitly activating venv
    -- In fact you can go wild here, like instead of searching workspace you can search a global directory of venvs if that's what you want
    -- (useful for uv and local venvs)
    if workspace then
      local root = util.find_git_ancestor(workspace) or workspace
      local venv = path.join(root, '.venv')
      if path.exists(venv) then
        return path.join(venv, 'bin', 'python')
      end
    end
    -- Case 03:
    -- Fallback to system Python.
    return exepath 'python3' or exepath 'python' or 'python'
  end

  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
        on_init = function(client)
          if server_name == 'pyright' then
            -- why and what?
            -- pyright doesn't work if you use `pyenv local` to specify auto-activate virtualenv on entering a directory
            -- Although if you manually activate the virtual env -> pyright will respect that
            -- See [ref](https://github.com/neovim/nvim-lspconfig/issues/717)
            --
            -- Solution:
            -- Option #1: Add pyrightconfig.json with pythonPath, venvPath and venv
            -- you can optionally use a [pyenv plugin](https://github.com/alefpereira/pyenv-pyright) to avoid manually managing this
            -- Option #2: Hook up correct python path before LSP init
            -- what we are doing right now
            local python_path = get_python_path(client.config.root_dir)
            print(python_path)
            client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
          end
        end,
      }
    end,
  }
end

return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  config = config,
  enabled = not vim.g.vscode,
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
  },
}
