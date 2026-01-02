return {
	"folke/sidekick.nvim",
  event = "LspAttach",
	opts = {
    nes = {
      enabled = true,
      debounce = 100,
    }
	},
	keys = {
    -- Next Edit Suggestion Keybindings
    {
      "<C-y>",
      function()
        if require("sidekick").nes_jump_or_apply() then
          return
        end
        return "<C-y>"
      end,
      mode = "n",  -- Normal mode only for NES
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<C-e>",
      function()
        if not require("sidekick").clear() then
          return "<Esc>"
        end
      end,
      mode = { "i", "n" },
      expr = true,
      desc = "Clear Sidekick or normal Esc",
    },
    -- Sidekick CLI Keybindings
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").close()
			end,
			desc = "Detach a CLI Session",
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send File",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
		-- Example of a keybinding to open Claude directly
		{
			"<leader>ac",
			function()
				require("sidekick.cli").toggle({ name = "claude", focus = true })
			end,
			desc = "Sidekick Toggle Claude",
		},
	},
}
