return {
  "swaits/zellij-nav.nvim",
  enabled = false,
  lazy = true,
  event = "VeryLazy",
  keys = {
    { "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>",  { noremap = true, silent = true, desc = "navigate left or tab" } },
    { "<c-j>", "<cmd>ZellijNavigateDown<cr>",     { noremap = true, silent = true, desc = "navigate down" } },
    { "<c-k>", "<cmd>ZellijNavigateUp<cr>",       { noremap = true, silent = true, desc = "navigate up" } },
    { "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", { noremap = true, silent = true, desc = "navigate right or tab" } },
  },
  opts = {},
}
