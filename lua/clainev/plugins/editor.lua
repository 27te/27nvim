-- ════════════════════════════════════════════════════════════════════
--  EDITOR PLUGINS
--  telescope · treesitter · autopairs · surround
--  mini · todo-comments · undotree · markdown · database
-- ════════════════════════════════════════════════════════════════════

return {

  -- ── FUZZY FINDER ─────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    event        = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = vim.g.is_windows
            and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
            or  "make",
        cond  = function()
          return vim.g.is_windows
              and vim.fn.executable "cmake" == 1
              or  vim.fn.executable "make" == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = {
            "node_modules", ".git/", "dist/", "build/",
            "__pycache__", "*.lock", "vendor/",
          },
          layout_strategy  = "horizontal",
          layout_config    = { prompt_position = "top", width = 0.87, height = 0.80 },
          sorting_strategy = "ascending",
          path_display     = { "truncate" },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      }
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require "telescope.builtin"
      local map     = vim.keymap.set
      map("n", "<leader>ff", builtin.find_files,             { desc = "Find Files" })
      map("n", "<leader>fw", builtin.live_grep,              { desc = "Live Grep" })
      map("n", "<leader>fb", builtin.buffers,                { desc = "Find Buffers" })
      map("n", "<leader>fo", builtin.oldfiles,               { desc = "Recent Files" })
      map("n", "<leader>fh", builtin.help_tags,              { desc = "Help Tags" })
      map("n", "<leader>fd", builtin.diagnostics,            { desc = "Diagnostics" })
      map("n", "<leader>fk", builtin.keymaps,                { desc = "Keymaps" })
      map("n", "<leader>fs", builtin.lsp_document_symbols,   { desc = "LSP Symbols" })
      map("n", "<leader>fS", builtin.lsp_workspace_symbols,  { desc = "Workspace Symbols" })
      map("n", "<leader>fg", builtin.git_commits,            { desc = "Git Commits" })
      map("n", "<leader>fG", builtin.git_branches,           { desc = "Git Branches" })
      map("n", "<leader>f/", function()
        builtin.current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown { winblend = 10, previewer = false }
        )
      end, { desc = "Fuzzy in buffer" })
    end,
  },

  -- ── TREESITTER ────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    lazy  = false,
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end
      configs.setup {
        ensure_installed = {
          "html", "css", "javascript", "typescript", "tsx",
          "json", "jsonc", "lua", "python", "go", "rust",
          "c", "cpp", "dart", "php",
          "sql", "markdown", "markdown_inline",
          "yaml", "toml", "dockerfile",
          "bash", "regex", "graphql",
          "gitignore", "gitcommit", "diff", "vim", "vimdoc",
        },
        sync_install  = false,
        auto_install  = true,
        highlight     = { enable = true, additional_vim_regex_highlighting = false },
        indent        = { enable = true },
      }
    end,
  },

  -- Auto-close HTML/JSX tags
  { "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },

  -- ── AUTOPAIRS ────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    opts   = { check_ts = true },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── SURROUND ─────────────────────────────────────────────────────
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

  -- ── mini.nvim utilities ───────────────────────────────────────────
  {
    "echasnovski/mini.nvim",
    version = false,
    config  = function()
      require("mini.comment").setup {}    -- gcc / gc comments
      require("mini.cursorword").setup {} -- highlight word under cursor
    end,
  },

  -- ── TODO COMMENTS ────────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {},
  },

  -- ── UNDO TREE ────────────────────────────────────────────────────
  { "mbbill/undotree", cmd = "UndotreeToggle" },

  -- ── MARKDOWN PREVIEW ─────────────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd   = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft    = "markdown",
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- ── DATABASE CLIENT ───────────────────────────────────────────────
  {
    "tpope/vim-dadbod",
    cmd          = { "DB", "DBUI" },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    config = function()
      vim.g.db_ui_save_location  = vim.fn.stdpath "data" .. "/db_ui"
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
}
