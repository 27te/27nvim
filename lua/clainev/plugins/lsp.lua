-- ════════════════════════════════════════════════════════════════════
--  LSP
--  mason · mason-lspconfig · nvim-lspconfig · conform · fidget
-- ════════════════════════════════════════════════════════════════════

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim",           opts = {} },
      { "williamboman/mason-lspconfig.nvim", opts = {} },
      { "j-hui/fidget.nvim",                 opts = {} },
    },
    config = function()
      -- Shared capabilities
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Keymaps on LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group    = vim.api.nvim_create_augroup("ClainevLspKeys", { clear = true }),
        callback = function(event)
          local map     = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          local builtin = require "telescope.builtin"

          map("gd",          builtin.lsp_definitions,     "Go to Definition")
          map("gD",          vim.lsp.buf.declaration,      "Go to Declaration")
          map("gr",          builtin.lsp_references,       "References")
          map("gi",          builtin.lsp_implementations,  "Implementations")
          map("gt",          builtin.lsp_type_definitions, "Type Definition")
          map("K",           vim.lsp.buf.hover,            "Hover Docs")
          map("<leader>ca",  vim.lsp.buf.code_action,      "Code Action")
          map("<leader>rn",  vim.lsp.buf.rename,           "Rename Symbol")
          map("<leader>lf",  function() vim.lsp.buf.format { async = true } end, "Format")
          map("<leader>li",  "<cmd>LspInfo<CR>",           "LSP Info")
          map("<leader>lr",  "<cmd>LspRestart<CR>",        "LSP Restart")
          map("[d",          vim.diagnostic.goto_prev,     "Prev Diagnostic")
          map("]d",          vim.diagnostic.goto_next,     "Next Diagnostic")
          map("<leader>ld",  vim.diagnostic.open_float,    "Line Diagnostics")

          -- Inlay hints (Neovim 0.10+)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method "textDocument/inlayHint" then
            map("<leader>lh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, "Toggle Inlay Hints")
          end
        end,
      })

      -- ── Server list ───────────────────────────────────────────────
      local servers = {
        -- Web
        ts_ls       = {
          settings = {
            typescript = { inlayHints = {
              includeInlayParameterNameHints          = "all",
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayVariableTypeHints           = true,
            }},
            javascript = { inlayHints = {
              includeInlayParameterNameHints = "all",
            }},
          },
        },
        eslint      = {},
        html        = {},
        cssls       = {},
        emmet_ls    = {},
        tailwindcss = {},
        jsonls      = {},

        -- PHP
        intelephense = {},

        -- Python
        pyright = {
          settings = {
            python = { analysis = { typeCheckingMode = "basic", autoSearchPaths = true } },
          },
        },

        -- Go
        gopls = {
          settings = {
            gopls = {
              analyses    = { unusedparams = true },
              staticcheck = true,
              gofumpt     = true,
              hints       = {
                parameterNames      = true,
                assignVariableTypes = true,
                rangeVariableTypes  = true,
              },
            },
          },
        },

        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
              cargo       = { allFeatures = true },
              inlayHints  = {
                parameterHints = { enable = true },
                typeHints      = { enable = true },
                chainingHints  = { enable = true },
              },
            },
          },
        },

        -- C/C++
        clangd = {},

        -- SQL
        sqls = {},

        -- Dart / Flutter (managed by flutter-tools, kept here for fallback)
        dartls = {},

        -- Markdown
        marksman = {},

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime     = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace   = {
                library         = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },

        -- Infra / DevOps
        yamlls    = {},
        taplo     = {},
        dockerls  = {},
        bashls    = {},
      }

      local ensure_installed = vim.tbl_filter(function(server)
        return server ~= "dartls"
      end, vim.tbl_keys(servers))

      require("mason-lspconfig").setup {
        ensure_installed      = ensure_installed,
        automatic_installation = true,
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      -- Diagnostic icons
      vim.diagnostic.config {
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰠠 ",
          },
        },
        virtual_text  = { prefix = "●" },
        float         = { border = "rounded", source = "if_many" },
        underline     = true,
        update_in_insert = false,
      }
    end,
  },

  -- ── FORMATTER ─────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts  = {
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
      formatters_by_ft = {
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        html            = { "prettier" },
        css             = { "prettier" },
        scss            = { "prettier" },
        json            = { "prettier" },
        jsonc           = { "prettier" },
        yaml            = { "prettier" },
        markdown        = { "prettier" },
        graphql         = { "prettier" },
        php             = { "php_cs_fixer" },
        python          = { "black", "isort" },
        go              = { "gofumpt", "goimports" },
        rust            = { "rustfmt" },
        c               = { "clang_format" },
        cpp             = { "clang_format" },
        lua             = { "stylua" },
        sql             = { "sqlfmt" },
        sh              = { "shfmt" },
        bash            = { "shfmt" },
        dart            = { "dart_format" },
      },
      formatters = {
        prettier = { prepend_args = { "--print-width", "100", "--single-quote", "--trailing-comma", "es5" } },
        black    = { prepend_args = { "--line-length", "100" } },
        stylua   = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
        shfmt    = { prepend_args = { "-i", "2" } },
      },
    },
  },
}
