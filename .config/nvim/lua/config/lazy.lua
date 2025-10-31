local opts = {
  spec = { import = "plugins" },
  defaults = {
    lazy = true,
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "default" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    paths = {}, -- add any custom paths here that you want to includes in the rtp
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin", -- originally commented out
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        --
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
  dev = {
    path = "~/Code/nvim-plugins",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {},
    -- Fallback to git when local plugin doesn't exist fallback = true,
    fallback = false,
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

      -- ["<localleader>i"] = {
      --   function(plugin)
      --     require("lazy.core.util").notify(vim.inspect(plugin), {
      --       title = "Inspect " .. plugin.name,
      --       lang = "lua",
      --     })
      --   end,
      --   desc = "Inspect Plugin",
      -- },

      -- ["<localleader>t"] = {
      --   function(plugin)
      --     require("lazy.util").float_term(nil, {
      --       cwd = plugin.dir,
      --     })
      --   end,
      --   desc = "Open terminal in plugin dir",
      -- },
    },
  },
  icons = vim.g.icon_size == "small" and { kinds = require("util.icons").kinds } or {},
  profiling = {
    -- Enables extra stats on the debug tab related to the loader cache.
    -- Additionally gathers stats about all package.loaders
    loader = false,
    -- Track each new require in the Lazy profiling tab
    require = false,
  },
}

local fn = vim.fn
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(opts)
-- dofile(vim.g.base46_cache .. "defaults")
-- dofile(vim.g.base46_cache .. "statusline")
--
-- if package.loaded["nvconfig"] then
--   local integrations = require("nvconfig").base46.integrations
--   for _, name in ipairs(integrations) do
--     dofile(vim.g.base46_cache .. name)
--   end
-- end
