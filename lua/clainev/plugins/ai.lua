-- ════════════════════════════════════════════════════════════════════
--  AI
--  avante.nvim (Claude / GPT inline assistant)
-- ════════════════════════════════════════════════════════════════════

-- Monkey-patch para normalizar rutas temporales en Windows (plenary.path se parcha en config)
if vim.fn.has("win32") == 1 then
  -- 1. Normalizar vim.fn.tempname para usar barras invertidas de Windows
  local original_tempname = vim.fn.tempname
  vim.fn.tempname = function()
    local temp = original_tempname()
    if temp then
      return temp:gsub("/", "\\")
    end
    return temp
  end
end

-- Inicialización de variables de entorno ficticias para los proxies/LMs locales
vim.env.CLAINEV_FREE_API_KEY = "free"
vim.env.OLLAMA_API_KEY = "ollama"

return {
  {
    "yetone/avante.nvim",
    event        = "VeryLazy",
    version      = false, -- always use the latest version
    build        = vim.g.is_windows
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "HakonHarnes/img-clip.nvim",
      "stevearc/dressing.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts         = {
      provider                  = "clainev_free",
      auto_suggestions_provider = "clainev_free",
      providers                 = {
        clainev_free = {
          __inherited_from   = "openai",
          endpoint           = "https://nvim-ai-chat-production.up.railway.app/v1",
          model              = "llama-3.3-70b-versatile",
          api_key_name       = "CLAINEV_FREE_API_KEY",
          extra_request_body = {
            max_tokens = 1024,
          }
        },
        clainev_free_8b = {
          __inherited_from   = "openai",
          endpoint           = "https://nvim-ai-chat-production.up.railway.app/v1",
          model              = "llama-3.1-8b-instant",
          api_key_name       = "CLAINEV_FREE_API_KEY",
          extra_request_body = {
            max_tokens = 1024,
          }
        },
        clainev_free_qwen = {
          __inherited_from   = "openai",
          endpoint           = "https://nvim-ai-chat-production.up.railway.app/v1",
          model              = "qwen-2.5-32b",
          api_key_name       = "CLAINEV_FREE_API_KEY",
          extra_request_body = {
            max_tokens = 1024,
          }
        },
        clainev_free_deepseek = {
          __inherited_from   = "openai",
          endpoint           = "https://nvim-ai-chat-production.up.railway.app/v1",
          model              = "deepseek-r1-distill-qwen-32b",
          api_key_name       = "CLAINEV_FREE_API_KEY",
          extra_request_body = {
            max_tokens = 1024,
          }
        },
        groq = {
          __inherited_from = "openai",
          endpoint         = "https://api.groq.com/openai/v1",
          model            = "llama-3.3-70b-versatile",
          api_key_name     = "GROQ_API_KEY",
        },
        ollama = {
          __inherited_from = "openai",
          endpoint         = "http://127.0.0.1:11434/v1",
          model            = "llama3.2",
          api_key_name     = "OLLAMA_API_KEY",
        },
        claude = {
          model        = "claude-3-5-sonnet-20241022",
          api_key_name = "ANTHROPIC_API_KEY",
        },
        openai = {
          model        = "gpt-4o",
          api_key_name = "OPENAI_API_KEY",
        },
      },
      behaviour                 = {
        auto_suggestions      = false,
        auto_set_keymaps      = true,
        auto_add_current_file = false,
      },
      windows                   = {
        width          = 35,
        sidebar_header = { rounded = true },
      },
    },
    config       = function(_, opts)
      -- 2. Monkey-patch para plenary.path para convertir todas las barras / a \ en Windows.
      -- Esto evita fallos al crear directorios recursivamente (mkdir) debido a barras mezcladas.
      if vim.fn.has("win32") == 1 then
        local ok, Path = pcall(require, "plenary.path")
        if ok then
          local original_new = Path.new
          Path.new = function(self, ...)
            local obj = original_new(self, ...)
            if type(obj) == "table" and obj.filename then
              obj.filename = obj.filename:gsub("/", "\\")
            end
            return obj
          end
        end
      end

      require("avante").setup(opts)
    end,
  },
}
