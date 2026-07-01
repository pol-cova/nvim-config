return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Only use linter names that actually exist in nvim-lint.
		-- Rust: no standalone linter in nvim-lint (use LSP / rust-analyzer instead).
		-- Go:   "golangcilint" is the correct nvim-lint name (no hyphen, no underscore).
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			python = { "pylint" },
			lua = { "luacheck" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			go = { "golangcilint" },
			-- C/C++: clangtidy is only useful WITH compile_commands.json (see guard below)
			c = { "clangtidy" },
			cpp = { "clangtidy" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- clangtidy produces noisy errors for single-file CP code and for files
		-- that include GCC-only headers such as bits/stdc++.h.
		local function has_compile_commands()
			local root = vim.fn.getcwd()
			return vim.fn.filereadable(root .. "/compile_commands.json") == 1
				or vim.fn.filereadable(root .. "/build/compile_commands.json") == 1
		end

		local function uses_competitive_programming_header()
			local ok, lines = pcall(vim.api.nvim_buf_get_lines, 0, 0, 80, false)
			if not ok then
				return false
			end

			for _, line in ipairs(lines) do
				if line:find("#include%s*<bits/stdc%+%+.h>") then
					return true
				end
			end

			return false
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				local ft = vim.bo.filetype
				local linters = lint._resolve_linter_by_ft(ft)
				if #linters == 0 then
					return
				end

				if (ft == "c" or ft == "cpp") and not has_compile_commands() then
					return
				end

				if ft == "cpp" and uses_competitive_programming_header() then
					return
				end

				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
