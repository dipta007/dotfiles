local config = function()
  require('copilot').setup {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 75,
      keymap = {
        accept = '<C-y>',
        accept_word = '<C-w>',
        accept_line = '<C-l>',
        next = '<]]>',
        prev = '<[[>',
        dismiss = '<C-e>',
      },
    },
    filetypes = {
      python = true,
      ['*'] = false,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {},
  }
end
return {
  'zbirenbaum/copilot.lua',
  enabled = not vim.g.vscode,
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = config,
}
