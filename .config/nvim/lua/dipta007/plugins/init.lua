return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup()
    end,
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { "tpope/vim-fugitive" },
  {
    'numToStr/FTerm.nvim',
    enabled = not vim.g.vscode,
    config = function()
      require('FTerm').setup {
        border = 'double',
        dimensions = {
          height = 0.9,
          width = 0.9,
        },
      }
    end,
  },
  --    -- DAP
  --    {
  --        "mfussenegger/nvim-dap",
  --        dependencies = {
  --          "nvim-neotest/nvim-nio",
  --          "rcarriga/nvim-dap-ui",
  --          "theHamsta/nvim-dap-virtual-text",
  --          "nvim-telescope/telescope-dap.nvim",
  --        },
  --      },
  --      -- Python
  --      {
  --        "mfussenegger/nvim-dap-python",
  --        dependencies = {
  --          "mfussenegger/nvim-dap",
  --        },
  --        config = function()
  --          -- Use mason's debugpy installation
  --          local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
  --          require("dap-python").setup(debugpy_path)
  --        end
  --      },
}
