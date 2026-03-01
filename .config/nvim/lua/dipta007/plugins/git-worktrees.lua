return {
  "Juksuu/worktrees.nvim",
  keys = {
    { "<leader>gws", function() Snacks.picker.worktrees() end, desc = "Worktrees" },
    { "<leader>gwn", function() Snacks.picker.worktrees_new() end, desc = "New Worktree" },
    { "<leader>gwr", function() Snacks.picker.worktrees_remove() end, desc = "Remove Worktree" },
  },
  config = function()
    require("worktrees").setup()
  end,
}
