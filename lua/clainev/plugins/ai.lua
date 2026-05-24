-- ════════════════════════════════════════════════════════════════════
--  AI
--  avante.nvim (Claude / GPT inline assistant)
-- ════════════════════════════════════════════════════════════════════

return {
  {
    "yetone/avante.nvim",
    event        = "VeryLazy",
    build        = vim.g.is_windows
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or  "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "HakonHarnes/img-clip.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      provider  = "claude",
      providers = {
        claude = {
          model        = "claude-sonnet-4-20250514",
          api_key_name = "ANTHROPIC_API_KEY",
        },
        openai = {
          model        = "gpt-4o",
          api_key_name = "OPENAI_API_KEY",
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_keymaps = true,
      },
      windows = {
        width          = 35,
        sidebar_header = { rounded = true },
      },
    },
  },
}
