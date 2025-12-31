-- Replace entire file with:
return {
  'nvim-lualine/lualine.nvim',
  enabled = not vim.g.vscode,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        globalstatus = true,  -- Single statusline for all windows
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          'filename',
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
          },
        },
        lualine_x = {
          {
            -- Show active LSP clients
            function()
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              if #buf_clients == 0 then
                return 'LSP Inactive'
              end

              local buf_client_names = {}
              for _, client in pairs(buf_clients) do
                table.insert(buf_client_names, client.name)
              end

              return ' ' .. table.concat(buf_client_names, ', ')
            end,
            color = { gui = 'bold' },
          },
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    }
  end,
}
