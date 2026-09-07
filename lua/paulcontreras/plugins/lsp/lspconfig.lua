return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- ─── On-attach keymaps ────────────────────────────────────────────────
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Hover documentation"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Signature help"
				keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- ─── Capabilities (merged with cmp) ───────────────────────────────────
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- ─── Diagnostics ──────────────────────────────────────────────────────
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "E",
					[vim.diagnostic.severity.WARN] = "W",
					[vim.diagnostic.severity.INFO] = "I",
					[vim.diagnostic.severity.HINT] = "H",
				},
			},
			virtual_text = { prefix = "●" },
			severity_sort = true,
		})

		-- ─── LSP configs ──────────────────────────────────────────────────────
		vim.lsp.config("*", { capabilities = capabilities })

		vim.lsp.config("cmake", {})
		vim.lsp.config("html", {})
		vim.lsp.config("ltex", {})
		vim.lsp.config("pyright", {})
		vim.lsp.config("tailwindcss", {
			cmd = {
				vim.fn.stdpath("data") .. "/mason/bin/tailwindcss-language-server",
				"--stdio",
			},
		})

		local cpp = require("paulcontreras.core.cpp")

		local clangd_caps = vim.deepcopy(capabilities)
		clangd_caps.offsetEncoding = { "utf-16" }

		vim.lsp.config("clangd", {
			capabilities = clangd_caps,
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
				"--all-scopes-completion",
				"--pch-storage=memory",
				"--query-driver=" .. cpp.query_drivers(),
			},
			init_options = {
				fallbackFlags = cpp.fallback_flags(),
				usePlaceholders = true,
				completeUnimported = true,
				clangdFileStatus = true,
			},
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		})

		local inlay = {
			includeInlayParameterNameHints = "literals",
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = false,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		}
		vim.lsp.config("ts_ls", {
			settings = {
				typescript = { inlayHints = inlay },
				javascript = { inlayHints = inlay },
			},
		})

		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					analyses = {
						unusedparams = true,
						shadow = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})

		local ok, schemastore = pcall(require, "schemastore")
		vim.lsp.config("jsonls", {
			settings = {
				json = {
					schemas = ok and schemastore.json.schemas() or {},
					validate = { enable = true },
				},
			},
		})

		vim.lsp.config("emmet_ls", {
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"ts_ls",
				"lua_ls",
				"pyright",
				"gopls",
				"emmet_ls",
				"tailwindcss",
				"jsonls",
				"html",
				"cmake",
				"ltex",
			},
			automatic_enable = {
				"clangd",
				"ts_ls",
				"lua_ls",
				"pyright",
				"gopls",
				"emmet_ls",
				"tailwindcss",
				"jsonls",
				"html",
				"cmake",
				"ltex",
			},
		})
	end,
}
