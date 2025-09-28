local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local spec = {}
spec = {
  -- { "LazyVim/LazyVim", import = "lazyvim.plugins", branch = "fix/mason-v2" },
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins",
    opts = {
      colorscheme = "tokyonight-moon",
    },
  },
  { import = "lazyvim.plugins.extras.vscode" },
  { import = "plugins" },
}

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
        "netrwPlugin",
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

-- dofile(vim.g.base46_cache .. "defaults")
-- dofile(vim.g.base46_cache .. "statusline")
--
-- if package.loaded["nvconfig"] then
--   local integrations = require("nvconfig").base46.integrations
--   for _, name in ipairs(integrations) do
--     dofile(vim.g.base46_cache .. name)
--   end
-- end
--
