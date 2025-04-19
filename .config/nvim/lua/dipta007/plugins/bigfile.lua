return {
 "LunarVim/bigfile.nvim",
  enabled = not vim.g.vscode,
  event="BufReadPre",
  opts={
    filesize=2,
  },
  config=function (_, opts)
    require("bigfile").setup(opts)
  end
}
