-- ════════════════════════════════════════════════════════════════════
--  GIT & DIAGNOSTICS
--  gitsigns · lazygit · trouble
-- ════════════════════════════════════════════════════════════════════

return {
  -- ── GITSIGNS ──────────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame      = true,
      current_line_blame_opts = { delay = 500 },
      on_attach = function(bufnr)
        local gs  = require "gitsigns"
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Git: " .. desc })
        end
        map("<leader>gp", gs.preview_hunk,      "Preview Hunk")
        map("<leader>gb", gs.blame_line,         "Blame Line")
        map("<leader>gB", gs.blame,              "Blame File")
        map("<leader>gs", gs.stage_hunk,         "Stage Hunk")
        map("<leader>gu", gs.undo_stage_hunk,    "Undo Stage")
        map("<leader>gd", gs.diffthis,           "Diff This")
        map("]g",         gs.next_hunk,          "Next Hunk")
        map("[g",         gs.prev_hunk,          "Prev Hunk")
      end,
    },
  },

  -- ── LAZYGIT ───────────────────────────────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    cmd          = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- ── TROUBLE ───────────────────────────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd  = "Trouble",
    opts = { auto_close = true, use_diagnostic_signs = true },
  },
}
