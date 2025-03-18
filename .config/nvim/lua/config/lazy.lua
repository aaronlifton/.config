-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

for _, arg in ipairs(vim.v.argv) do
  if arg == "--fast" then
    vim.g.fastmode = true
    break
  end
end
local spec = {}
if vim.g.fastmode then
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins.extras.util.fast" },
  }
else
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.vscode" },
    { import = "plugins" },
  }
end

require("lazy").setup({
  spec = spec,
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "tokyonight", "habamax" } },
  -- install = { colorscheme = {  "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        --
        -- NVChad
        -- "2html_plugin",
        -- "getscript",
        -- "getscriptPlugin",
        -- "logipat",
        -- "netrw",
        -- "netrwPlugin",
        -- "netrwSettings",
        -- "netrwFileHandlers",
        -- "matchit",
        -- "tar",
        -- "rrhelper",
        -- "spellfile_plugin",
        -- "vimball",
        -- "vimballPlugin",
        -- "zip",
        -- "rplugin",
        -- "syntax",
        -- "synmenu",
        -- "optwin",
        -- "compiler",
        -- "bugreport",
        -- "ftplugin",
      },
    },
  },
  dev = {
    path = "~/Code/nvim-plugins",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {},
    -- Fallback to git when local plugin doesn't exist
    fallback = true,
  },
  ui = {
    custom_keys = {
      ["<localleader>l"] = {
        function(plugin)
          require("lazy.util").float_term({ "lazygit", "log" }, {
            cwd = plugin.dir,
            env = {
              -- nvr does not work with lazygit inside of Lazy
              GIT_EDITOR = "nvim",
            },
          })
        end,
        desc = "Open lazygit log",
      },
    },
  },
  icons = vim.g.icon_size == "small" and { kinds = require("util.icons").kinds } or {},
})
