-- ════════════════════════════════════════════════════════════════════
--  TOOLS
--  toggleterm
-- ════════════════════════════════════════════════════════════════════

return {
  -- ── TERMINAL ──────────────────────────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    cmd  = "ToggleTerm",
    keys = { "<leader>th", "<leader>tv", "<leader>tf", [[<C-\>]] },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.35)
        end
      end,
      open_mapping = [[<C-\>]],
      shell        = vim.o.shell,
      float_opts   = { border = "curved" },
    },
  },
}
