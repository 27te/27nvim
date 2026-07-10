-- ════════════════════════════════════════════════════════════════════
--  BOOTSTRAP LAZY.NVIM
-- ════════════════════════════════════════════════════════════════════
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- ════════════════════════════════════════════════════════════════════
--  LOAD PLUGINS
-- ════════════════════════════════════════════════════════════════════
require("lazy").setup({
  { import = "clainev.plugins.ui" },
  { import = "clainev.plugins.editor" },
  { import = "clainev.plugins.lsp" },
  { import = "clainev.plugins.completion" },
  { import = "clainev.plugins.dap" },
  { import = "clainev.plugins.test" },
  { import = "clainev.plugins.git" },
  { import = "clainev.plugins.tools" },
  { import = "clainev.plugins.ai" },
  { import = "clainev.plugins.flutter" },
}, {
  rocks       = { enabled = false },  -- disable luarocks (Windows compat)
  ui          = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
        "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
      },
    },
  },
})
