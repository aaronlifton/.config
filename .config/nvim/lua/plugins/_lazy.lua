local function add_to_runtimepath(config_path)
  if config_path and config_path ~= "" then vim.o.runtimepath = vim.o.runtimepath .. "," .. config_path end
end

local status, config_path = pcall(vim.api.nvim_get_var, "config_path")
if status then add_to_runtimepath(config_path) end

-- NOTE: LazyVim now initializes `default_extras` inside
-- `LazyVim.config.get_defaults()`, so we should not patch the upstream local
-- here anymore. Keep using the public extras/import APIs instead.

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-moon",
    },
    import = "lazyvim.plugins",
  },
  { import = "lazyvim.plugins.extras.coding.blink" },
  { import = "lazyvim.plugins.extras.coding.mini-surround" },
  { import = "lazyvim.plugins.extras.coding.yanky" },
  { import = "lazyvim.plugins.extras.editor.mini-diff" },
  { import = "lazyvim.plugins.extras.editor.mini-move" },
  { import = "lazyvim.plugins.extras.editor.dial" },
  { import = "lazyvim.plugins.extras.editor.inc-rename" },
  { import = "lazyvim.plugins.extras.lang.typescript.biome" },
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.test.core" },
  { import = "lazyvim.plugins.extras.ui.edgy" },
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  { import = "lazyvim.plugins.extras.util.dot" },
  { import = "lazyvim.plugins.extras.util.startuptime" },
  { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
  -- Langs
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
}
