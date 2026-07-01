return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Formatters
				"prettier", -- JS/TS/HTML/CSS/JSON/YAML/Markdown
				"stylua", -- Lua
				"isort", -- Python imports
				"black", -- Python
				"clang-format", -- C/C++
				"shfmt", -- shell / zsh
				"gofumpt", -- Go (stricter gofmt)

				-- Linters
				"eslint_d", -- JS/TS (fast eslint daemon)
				"pylint", -- Python
				"shellcheck", -- Shell
				"luacheck", -- Lua
				"golangci-lint", -- Go (multi-linter runner)

				-- DAP
				"codelldb", -- C/C++ debugger adapter
				-- NOTE: clang-tidy is NOT a standalone Mason package on macOS;
				--       it ships with the clangd package above.
			},
		})
	end,
}
