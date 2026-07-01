return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline", -- command-line completion
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- VSCode-style snippets (friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Custom competitive programming snippets
    require("paulcontreras.snippets.cpp")

    -- Don't jump out of snippet when we move into another buffer
    luasnip.config.setup({ enable_autosnippets = true })

    -- ─────────────────────────────────────────────
    --  Main insert-mode completion
    -- ─────────────────────────────────────────────
    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noselect",
      },

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      mapping = cmp.mapping.preset.insert({
        -- Navigate completion menu
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),

        -- Scroll docs in the floating preview
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Manually trigger / abort
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),

        -- Confirm only when an item is explicitly selected
        ["<CR>"] = cmp.mapping.confirm({ select = false }),

        -- Tab: cycle menu items AND jump forward through snippet placeholders
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- S-Tab: reverse cycle AND jump backward through snippet placeholders
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip",  priority = 750 },
        { name = "buffer",   priority = 500 },
        { name = "path",     priority = 250 },
      }),

      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",   -- show icon + kind text
          maxwidth = 50,
          ellipsis_char = "...",
          show_labelDetails = true,
        }),
      },

      -- Show ghost-text inline (VSCode-style preview)
      experimental = {
        ghost_text = { hl_group = "Comment" },
      },
    })

    -- ─────────────────────────────────────────────
    --  Search (/) completion from buffer words
    -- ─────────────────────────────────────────────
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    -- ─────────────────────────────────────────────
    --  Command (:) completion
    -- ─────────────────────────────────────────────
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        { { name = "path" } },
        { { name = "cmdline" } }
      ),
      matching = { disallow_symbol_nonprefix_matching = false },
    })
  end,
}
