return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  -- yarn (via npx), not npm: plugin commits yarn.lock; npm rewrites it and
  -- dirties the tree, so lazy refuses to update. yarn respects the lockfile.
  build = "cd app && npx --yes yarn@1 install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
  -- ft on key: buffer-local to markdown. Commands are -buffer scoped, so a
  -- global map would error in other filetypes.
  -- disabled: <leader>m now toggles live-preview.nvim instead (see live-preview.lua)
  -- keys = {
  --   { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview (toggle)" },
  -- },
}
