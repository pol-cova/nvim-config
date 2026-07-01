return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local ok, treesitter = pcall(require, "nvim-treesitter.configs")
		if not ok then
			vim.notify("nvim-treesitter is unavailable; using built-in syntax highlighting", vim.log.levels.WARN)
			vim.cmd("syntax enable")
			return
		end

		treesitter.setup({
			highlight = {
				enable = true,
			},
			indent = { enable = true },
			autotag = {
				enable = true,
			},
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"yaml",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"cpp",
				"python",
				"rust",
				"java",
				"go",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
