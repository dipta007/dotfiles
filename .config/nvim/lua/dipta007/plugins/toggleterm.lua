return {
	"akinsho/toggleterm.nvim",
	version = "main",
	config = true,
	enabled = false,
	init = function()
		vim.keymap.set(
			{ "n", "v", "t" },
			"<localleader>tt",
			"<cmd>ToggleTerm size=20 direction=horizontal<cr>",
			{ desc = "Toggle Terminal" }
		)

		vim.keymap.set(
			{ "n", "v", "t" },
			"<localleader>tf",
			"<cmd>ToggleTerm direction=float<cr>",
			{ desc = "Toggle Floating Terminal" }
		)

    vim.keymap.set(
      { "n", "v", "t" },
      "<localleader>tv",
      "<cmd>ToggleTerm direction=vertical size=80<cr>",
      { desc = "Toggle Vertical Terminal" }
    )

    vim.keymap.set(
      { "n", "v", "t" },
      "<localleader>tn",
      "<cmd>TermNew size=40 direction=horizontal<cr>",
      { desc = "New Terminal" }
    )

    vim.keymap.set(
      { "n", "v", "t" },
      "<localleader>ts",
      "<cmd>TermSelect<cr>",
      { desc = "Select Terminal" }
    )

    vim.keymap.set(
      { "n", "v", "t" },
      "<localleader>tc",
      "<cmd>ToggleTermSetName<cr>",
      { desc = "Rename Terminal" }
    )

    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
}
