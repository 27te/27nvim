-- ════════════════════════════════════════════════════════════════════
--  FLUTTER
--  flutter-tools.nvim
-- ════════════════════════════════════════════════════════════════════

return {
  {
    "akinsho/flutter-tools.nvim",
    ft           = "dart",
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
    opts         = {
      ui       = { border = "rounded" },
      debugger = { enabled = false },  -- no DAP
      lsp      = {
        capabilities = function()
          return vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
          )
        end,
        settings = {
          showTodos             = true,
          completeFunctionCalls = true,
        },
      },
    },
  },
}
