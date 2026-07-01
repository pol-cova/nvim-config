return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- timeoutlen is set in options.lua (300ms)
		icons = { rules = false }, -- don't auto-attach icons (keep it snappy)
		spec = {
			-- Group hints shown in the which-key popup
			{ "<leader>c", group = "C++ / code actions" },
			{ "<leader>d", group = "Diagnostics / DAP" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>f", group = "Find / projects" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Git hunks" },
			{ "<leader>m", group = "Format" },
			{ "<leader>r", group = "Rename / restart" },
			{ "<leader>s", group = "Splits" },
			{ "<leader>t", group = "Tabs" },
			{ "<leader>w", group = "Workspace / session" },
			{ "<leader>x", group = "Trouble / diagnostics" },
		},
	},
}
