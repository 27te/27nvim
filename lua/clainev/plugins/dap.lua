-- ════════════════════════════════════════════════════════════════════
--  DAP — DEBUGGER
--  nvim-dap · dap-ui · virtual-text · dap-go · dap-python
--  Adaptadores (via Mason): debugpy · delve · codelldb
--  js-debug-adapter · php-debug-adapter (Xdebug)
-- ════════════════════════════════════════════════════════════════════

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      { "leoluz/nvim-dap-go", opts = {} },
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<F5>",       function() require("dap").continue() end,          desc = "Debug: Continue" },
      { "<F10>",      function() require("dap").step_over() end,         desc = "Debug: Step Over" },
      { "<F11>",      function() require("dap").step_into() end,         desc = "Debug: Step Into" },
      { "<F12>",      function() require("dap").step_out() end,          desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function()
          require("dap").set_breakpoint(vim.fn.input "Condición: ")
        end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,          desc = "Continue / Start" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,     desc = "Run to Cursor" },
      { "<leader>dl", function() require("dap").run_last() end,          desc = "Run Last" },
      { "<leader>dr", function() require("dap").repl.toggle() end,       desc = "Toggle REPL" },
      { "<leader>dt", function() require("dap").terminate() end,         desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle Debug UI" },
      { "<leader>de", function() require("dapui").eval() end,            desc = "Eval",             mode = { "n", "v" } },
    },
    config = function()
      local dap   = require "dap"
      local dapui = require "dapui"

      dapui.setup()

      -- Abrir/cerrar la UI automáticamente con la sesión
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"]     = function() dapui.close() end

      vim.fn.sign_define("DapBreakpoint",          { text = "", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped",             { text = "", texthl = "DiagnosticInfo", linehl = "Visual" })

      -- ── Python (debugpy de Mason) ─────────────────────────────────
      local mason_pkgs = vim.fn.stdpath "data" .. "/mason/packages"
      local debugpy_py = vim.g.is_windows
          and mason_pkgs .. "/debugpy/venv/Scripts/python.exe"
          or  mason_pkgs .. "/debugpy/venv/bin/python"
      if vim.uv.fs_stat(debugpy_py) then
        require("dap-python").setup(debugpy_py)
      end

      -- ── Go: configurado por nvim-dap-go (delve) ───────────────────

      -- ── Rust / C / C++ (codelldb) ─────────────────────────────────
      dap.adapters.codelldb = {
        type       = "server",
        port       = "${port}",
        executable = { command = "codelldb", args = { "--port", "${port}" } },
      }
      local codelldb_launch = {
        name    = "Ejecutar binario",
        type    = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Ruta al ejecutable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd         = "${workspaceFolder}",
        stopOnEntry = false,
      }
      dap.configurations.rust = { codelldb_launch }
      dap.configurations.c    = { codelldb_launch }
      dap.configurations.cpp  = { codelldb_launch }

      -- ── Node / TypeScript (js-debug-adapter) ──────────────────────
      dap.adapters["pwa-node"] = {
        type       = "server",
        host       = "localhost",
        port       = "${port}",
        executable = { command = "js-debug-adapter", args = { "${port}" } },
      }
      for _, ft in ipairs { "javascript", "typescript", "javascriptreact", "typescriptreact" } do
        dap.configurations[ft] = {
          {
            name    = "Ejecutar archivo actual (node)",
            type    = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd     = "${workspaceFolder}",
            runtimeExecutable = "node",
          },
          {
            name      = "Adjuntar a proceso (--inspect)",
            type      = "pwa-node",
            request   = "attach",
            processId = function() return require("dap.utils").pick_process() end,
            cwd       = "${workspaceFolder}",
          },
        }
      end

      -- ── PHP (Xdebug, puerto 9003) ─────────────────────────────────
      dap.adapters.php = { type = "executable", command = "php-debug-adapter" }
      dap.configurations.php = {
        {
          name    = "Escuchar Xdebug",
          type    = "php",
          request = "launch",
          port    = 9003,
        },
      }
    end,
  },
}
