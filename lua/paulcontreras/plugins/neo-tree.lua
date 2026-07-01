return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>ee", "<cmd>Neotree toggle filesystem left<cr>", desc = "Toggle explorer" },
		{ "<leader>ef", "<cmd>Neotree reveal filesystem left<cr>", desc = "Reveal current file" },
		{ "<leader>eb", "<cmd>Neotree toggle buffers left<cr>", desc = "Buffer explorer" },
		{ "<leader>eg", "<cmd>Neotree toggle git_status left<cr>", desc = "Git status explorer" },
	},
	opts = {
		close_if_last_window = true,
		enable_git_status = true,
		enable_diagnostics = true,
		filesystem = {
			follow_current_file = {
				enabled = true,
			},
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = false,
				never_show = {
					".DS_Store",
				},
			},
		},
		window = {
			width = 35,
		},
	},
}
