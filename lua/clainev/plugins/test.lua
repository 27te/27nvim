-- ════════════════════════════════════════════════════════════════════
--  TESTS — NEOTEST
--  pytest · Jest · Vitest · go test · cargo test (nextest) · Pest
-- ════════════════════════════════════════════════════════════════════

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adaptadores por stack
      "nvim-neotest/neotest-python",      -- pytest (Flask, FastAPI)
      "nvim-neotest/neotest-jest",        -- Jest (NestJS)
      "marilari88/neotest-vitest",        -- Vitest (Bun/Elysia, React)
      "fredrikaverpil/neotest-golang",    -- go test
      "rouge8/neotest-rust",              -- cargo nextest (Axum)
      "V13Axel/neotest-pest",             -- Pest (Laravel)
    },
    keys = {
      { "<leader>nn", function() require("neotest").run.run() end,                   desc = "Run Nearest Test" },
      { "<leader>nf", function() require("neotest").run.run(vim.fn.expand "%") end,  desc = "Run File Tests" },
      { "<leader>nd", function() require("neotest").run.run { strategy = "dap" } end, desc = "Debug Nearest Test" },
      { "<leader>nl", function() require("neotest").run.run_last() end,              desc = "Run Last Test" },
      { "<leader>nS", function() require("neotest").run.stop() end,                  desc = "Stop Test" },
      { "<leader>ns", function() require("neotest").summary.toggle() end,            desc = "Test Summary" },
      { "<leader>no", function() require("neotest").output.open { enter = true } end, desc = "Test Output" },
      { "<leader>nO", function() require("neotest").output_panel.toggle() end,       desc = "Test Output Panel" },
      { "<leader>nw", function() require("neotest").watch.toggle(vim.fn.expand "%") end, desc = "Watch File" },
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-python" { dap = { justMyCode = false } },
          require "neotest-jest" {},
          require "neotest-vitest" {},
          require "neotest-golang" {},
          require "neotest-rust" {},   -- requiere cargo-nextest instalado
          require "neotest-pest" {},
        },
        output = { open_on_run = false },
        quickfix = { enabled = false },
      }
    end,
  },
}
