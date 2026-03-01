return {
  'richwomanbtc/overleaf.nvim',
  config = function()
    require('overleaf').setup({
      cookie = 's%3AEYQ19d4XK8tfbdZb8FYeLjEFjWwRRGUi.4Dx3fS2uoZPVsCi0irVKjR4Pem8zaywDjobLswNDZ5E',
      node_path = '/Users/dipta007/.nvm/versions/node/v24.11.0/bin/node',
    })
  end,
  build = 'cd node && npm install',
}
