-- ════════════════════════════════════════════════════════════════════
--  TOOLS
--  toggleterm (+lazydocker) · kulala (REST) · persistence · nvim-lint
-- ════════════════════════════════════════════════════════════════════

return {
  -- ── TERMINAL ──────────────────────────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    cmd  = "ToggleTerm",
    keys = { "<leader>th", "<leader>tv", "<leader>tf", "<leader>td", [[<C-\>]] },
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
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- LazyDocker en terminal flotante (capítulo Docker del libro)
      local Terminal   = require("toggleterm.terminal").Terminal
      local lazydocker = Terminal:new { cmd = "lazydocker", direction = "float", hidden = true }
      vim.keymap.set("n", "<leader>td", function()
        if vim.fn.executable "lazydocker" == 1 then
          lazydocker:toggle()
        else
          vim.notify("lazydocker no está instalado (scoop install lazydocker)", vim.log.levels.WARN)
        end
      end, { desc = "LazyDocker" })
    end,
  },

  -- ── REST CLIENT (.http — reemplaza Postman/Thunder Client) ────────
  {
    "mistweaverco/kulala.nvim",
    ft   = { "http", "rest" },
    keys = {
      { "<leader>Rs", function() require("kulala").run() end,         desc = "Send Request" },
      { "<leader>Ra", function() require("kulala").run_all() end,     desc = "Send All Requests" },
      { "<leader>Rr", function() require("kulala").replay() end,      desc = "Replay Last Request" },
      { "<leader>Rt", function() require("kulala").toggle_view() end, desc = "Toggle Body/Headers" },
      { "<leader>Rc", function() require("kulala").copy() end,        desc = "Copy as cURL" },
      { "<leader>Ri", function() require("kulala").inspect() end,     desc = "Inspect Request" },
    },
    opts = { global_keymaps = false },
    init = function()
      vim.filetype.add { extension = { http = "http" } }
    end,
  },

  -- ── SESSIONS ──────────────────────────────────────────────────────
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts  = {},
    keys  = {
      { "<leader>sr", function() require("persistence").load() end,                desc = "Restore Session (cwd)" },
      { "<leader>sl", function() require("persistence").load { last = true } end,  desc = "Restore Last Session" },
      { "<leader>sd", function() require("persistence").stop() end,                desc = "Don't Save Session" },
    },
  },

  -- ── EXTRA LINTERS (lo que no cubre LSP) ───────────────────────────
  {
    "mfussenegger/nvim-lint",
    event  = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        dockerfile = { "hadolint" },
      }
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group    = vim.api.nvim_create_augroup("ClainevLint", { clear = true }),
        callback = function()
          if lint.linters_by_ft[vim.bo.filetype] then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
