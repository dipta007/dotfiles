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
        next = '<C-j>',
        prev = '<C-k>',
        dismiss = '<C-e>',
      },
    },
    filetypes = {
      python = true,
      ['*'] = true,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {},
  }
end
return {
  'zbirenbaum/copilot.lua',
  enabled = true, -- Disabled in favor of official Copilot LSP for sidekick NES
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = config,
}
