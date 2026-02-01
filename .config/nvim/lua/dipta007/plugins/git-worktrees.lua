return {
  "Juksuu/worktrees.nvim",
  config = function()
    require("worktrees").setup()
    vim.keymap.set("n", "<leader>gws", function() Snacks.picker.worktrees() end)
    vim.keymap.set("n", "<leader>gwn", function() Snacks.picker.worktrees_new() end)
    vim.keymap.set("n", "<leader>gwr", function() Snacks.picker.worktrees_remove() end)
  end,
}
