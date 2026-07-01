return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-telescope/telescope-project.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local function existing_dirs(paths)
			local dirs = {}
			for _, path in ipairs(paths) do
				local expanded = vim.fn.expand(path)
				if vim.fn.isdirectory(expanded) == 1 then
					table.insert(dirs, path)
				end
			end
			return dirs
		end

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			extensions = {
				project = {
					base_dirs = existing_dirs({
						"~/Documents/Codex",
						"~/Developer",
						"~/Dev",
						"~/Documents",
					}),
					hidden_files = true,
					order_by = "recent",
					sync_with_nvim_tree = false,
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("project")

		local keymap = vim.keymap

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Search text" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Search word under cursor" })
		keymap.set("n", "<leader>fp", "<cmd>Telescope project<cr>", { desc = "Switch project" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Todos" })
	end,
}
