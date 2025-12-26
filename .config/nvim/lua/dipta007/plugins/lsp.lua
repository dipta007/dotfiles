-- [[ Configure LSP ]]
-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed.
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {
    single_file_support = true,
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- using ruff for linting
          ignore = { '*' },
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
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        diagnostics = {
          globals = { 'vim' },
        },
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
        },
      },
    },
  },
}

local config = function()
  -- Setup LSP keymaps on attach
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
    callback = function(ev)
      local bufnr = ev.buf

      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('<leader>ld', vim.diagnostic.open_float, '[L]oad Diagnostic')
      nmap('[d', vim.diagnostic.goto_prev)
      nmap(']d', vim.diagnostic.goto_next)

      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')

      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end,
  })

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  -- Configure default capabilities for all LSP servers using the new vim.lsp.config API
  vim.lsp.config('*', {
    capabilities = capabilities,
  })

  -- Configure each server
  for server_name, server_config in pairs(servers) do
    vim.lsp.config(server_name, server_config)
  end

  -- Ensure the servers above are installed via mason
  local mason_lspconfig = require 'mason-lspconfig'
  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  -- Enable all configured servers
  vim.lsp.enable(vim.tbl_keys(servers))
end

return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  config = config,
  enabled = not vim.g.vscode,
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim', version = '*', },
  },
}
