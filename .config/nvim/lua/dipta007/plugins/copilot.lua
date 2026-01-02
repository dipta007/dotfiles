local config = function()
  require('copilot').setup {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 75,
      keymap = {
          accept = "<C-y>",
          accept_word = "<C-w>",
          accept_line = false,
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-e>",
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
  enabled = true,
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = config,
}
