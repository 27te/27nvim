-- ════════════════════════════════════════════════════════════════════
--  COMPLETION
--  nvim-cmp · LuaSnip · friendly-snippets · lspkind
-- ════════════════════════════════════════════════════════════════════

return {
  {
    "hrsh7th/nvim-cmp",
    event        = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      {
        "L3MON4D3/LuaSnip",
        build        = vim.g.is_windows and "" or "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
      },
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp     = require "cmp"
      local luasnip = require "luasnip"
      local lspkind = require "lspkind"

      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },

        mapping = cmp.mapping.preset.insert {
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-y>"]     = cmp.mapping.confirm { select = true },
          ["<CR>"]      = cmp.mapping.confirm { select = true },
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },

        sources = cmp.config.sources(
          {
            { name = "nvim_lsp", priority = 1000 },
            { name = "luasnip",  priority = 750 },
            { name = "nvim_lua", priority = 600 },
          },
          {
            { name = "buffer", priority = 500 },
            { name = "path",   priority = 250 },
          }
        ),

        formatting = {
          format = lspkind.cmp_format {
            mode          = "symbol_text",
            maxwidth      = 50,
            ellipsis_char = "…",
            menu          = {
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
              nvim_lua = "[Lua]",
            },
          },
        },

        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }
    end,
  },
}
