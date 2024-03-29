local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
-- vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

vim.g.fennel_enabled = false
if vim.g.fennel_enabled then
  -- Bootstap hotpot into lazy plugin dir if it does not exist yet.
  local hotpotpath = vim.fn.stdpath("data") .. "/lazy/hotpot.nvim"
  if not vim.loop.fs_stat(hotpotpath) then
    vim.notify("Bootstrapping hotpot.nvim...", vim.log.levels.INFO)
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      -- You may with to pin a known version tag with `--branch=vX.Y.Z`
      "--branch=v0.9.6",
      "https://github.com/rktjmp/hotpot.nvim.git",
      hotpotpath,
    })
  end

  -- As per lazy's install instructions, but insert hotpots path at the front
  -- vim.opt.rtp:prepend({hotpotpath, lazypath})
  vim.opt.rtp:prepend({ hotpotpath, vim.env.LAZY or lazypath })
  -- require("hotpot") -- optionally you may call require("hotpot").setup(...) here

  -- -- include hotpot as a plugin so lazy will update it
  -- local plugins = {"rktjmp/hotpot.nvim"}
  -- require("lazy").setup(plugins)
else
  vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
end

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    -- use mini.starter instead of alpha
    -- { import = "lazyvim.plugins.extras.ui.mini-starter" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
    -- { import = "lazyvim.plugins.extras.editor.mini-files" },
    -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.coding.codeium" },
    { import = "lazyvim.plugins.extras.vscode" },
    { import = "lazyvim.plugins.extras.lazyrc" },
    -- import/override with your plugins
    { import = "plugins" },
    -- { import = "mini" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- install = { colorscheme = { "tokyonight", "habamax" } },
  -- install = { colorscheme = { "catppuccin", "mocha" } },
  -- install = { colorscheme = { "everforest" } },
  install = { colorscheme = { "material", "darker" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    cache = {
      enabled = true,
      -- path = vim.fn.stdpath("cache") .. "/lazy",
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "netrwPlugin",
        "zipPlugin",
      },
    },
  },
  dev = {
    path = "~/Code/nvim-plugins",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = { "aaronlifton" },
    -- Fallback to git when local plugin doesn't exist
    fallback = true,
  },
})
