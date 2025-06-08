-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
local spec = {

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  { import = "custom.plugins.ai.avante" },
  { import = "custom.plugins.ai.mcphub" },
  -- { import = 'custom.plugins.ai.model' },
  -- { import = 'custom.plugins.cmp.autopairs' },
  { import = "custom.plugins.coding.annotation" },
  -- { import = 'custom.plugins.coding.cmp' },
  -- { import = 'custom.plugins.coding.luapad' },
  -- { import = 'custom.plugins.coding.mason' },
  { import = "custom.plugins.coding.nvim-snippets" },
  { import = "custom.plugins.treesitter.sibling-swap" },
  { import = "custom.plugins.treesitter.treesitter" },
  { import = "custom.plugins.treesitter.treesj" },
  { import = "custom.plugins.editor.docs.devdocs" },
  -- { import = 'custom.plugins.editor.fzf' },
  -- { import = 'custom.plugins.editor.git.blame' },
  -- { import = 'custom.plugins.editor.git.diffview' },
  -- { import = 'custom.plugins.editor.git.git-conflict' },
  { import = "custom.plugins.editor.git.neogit" },
  -- { import = 'custom.plugins.editor.leap' },
  -- { import = 'custom.plugins.editor.neo-tree' },
  { import = "custom.plugins.editor.nvim-colorizer" },
  { import = "custom.plugins.editor.search-replace" },
  -- { import = 'custom.plugins.editor.trouble' },
  { import = "custom.plugins.formatting.prettier" },
  { import = "custom.plugins.formatting.trim_newlines" },
  { import = "custom.plugins.lang.bash" },
  { import = "custom.plugins.lang.docker" },
  { import = "custom.plugins.lang.git" },
  { import = "custom.plugins.lang.go" },
  { import = "custom.plugins.lang.json" },
  { import = "custom.plugins.lang.kitty" },
  { import = "custom.plugins.lang.lua" },
  { import = "custom.plugins.lang.markdown" },
  { import = "custom.plugins.lang.python" },
  { import = "custom.plugins.lang.ruby" },
  { import = "custom.plugins.lang.sql" },
  { import = "custom.plugins.lang.tilt" },
  { import = "custom.plugins.lang.web.html-css" },
  { import = "custom.plugins.lang.web.tailwind" },
  { import = "custom.plugins.lang.web.typescript" },
  { import = "custom.plugins.lang.xml" },
  { import = "custom.plugins.lang.yaml" },
  { import = "custom.plugins.linting.eslint" },
  { import = "custom.plugins.linting.stylelint" },
  { import = "custom.plugins.lsp.lspconfig" },
  { import = "custom.plugins.marks.grapple" },
  -- { import = 'custom.plugins.mini.mini-ai' },
  -- { import = 'custom.plugins.mini.mini-diff' },
  -- { import = 'custom.plugins.mini.mini-files' },
  -- { import = 'custom.plugins.mini.mini-surround' },
  -- { import = 'custom.plugins.ui.bufferline' },
  { import = "custom.plugins.ui.dap-view" },
  -- { import = 'custom.plugins.ui.edgy' },
  { import = "custom.plugins.ui.helpview" },
  { import = "custom.plugins.ui.log-highlight" },
  -- { import = 'custom.plugins.ui.lualine' },
  -- { import = 'custom.plugins.ui.noice' },
  -- { import = 'custom.plugins.ui.smooth-scrolling' },
  { import = "custom.plugins.ui.snacks" },
  { import = "custom.plugins.editor.snacks_picker" },
  -- { import = "custom.plugins.editor.snacks_explorer" },
  { import = "custom.plugins.ui.which-key" },
  { import = "custom.plugins.util.better-escape" },
  -- { import = 'custom.plugins.util.persistence' },
  { import = "custom.plugins.util.smart-splits" },
  { import = "custom.plugins.coding.multicursor" },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}

require("util.lazy.config").init()
require("lazy").setup({

  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  "NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua

  require("kickstart/plugins/gitsigns"),

  require("kickstart/plugins/which-key"),

  -- require("kickstart/plugins/telescope"),

  require("custom.plugins.ui.snacks"),

  require("kickstart/plugins/lspconfig"),

  require("kickstart/plugins/conform"),

  require("kickstart/plugins/blink-cmp"),

  require("kickstart/plugins/tokyonight"),

  require("kickstart/plugins/todo-comments"),

  require("kickstart/plugins/mini"),

  require("kickstart/plugins/treesitter"),

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- Failed to run `config` for nvim-dap
  --
  -- ...vim/lazy/mason-nvim-dap.nvim/lua/mason-nvim-dap/init.lua:45: loop or previous error loading module 'mason-nvim-dap.mappings.configurations'
  --
  -- # stacktrace:
  --   - /mason-nvim-dap.nvim/lua/mason-nvim-dap/init.lua:45 _in_ **fn**
  --   - /mason.nvim/lua/mason-core/optional.lua:105 _in_ **if_present**
  --   - /mason-nvim-dap.nvim/lua/mason-nvim-dap/init.lua:41 _in_ **fn**
  --   - /mason.nvim/lua/mason-core/functional/list.lua:116 _in_ **each**
  --   - /mason-nvim-dap.nvim/lua/mason-nvim-dap/init.lua:61 _in_ **setup_handlers**
  --   - /mason-nvim-dap.nvim/lua/mason-nvim-dap/init.lua:87 _in_ **setup**
  --   - lua/kickstart/plugins/debug.lua:84 _in_ **config**
  --   - /mason-nvim-dap.nvim/lua/mason-nvim-dap/mappings/configurations.lua:127
  --   - /mason-nvim-dap.nvim/lua/mason-nvim-dap/init.lua:45 _in_ **fn**
  --   - /mason.nvim/lua/mason-core/optional.lua:105 _in_ **if_present**
  --   - /mason-nvim-dap.nvim/lua/mason-nvim-dap/init.lua:41 _in_ **fn**
  --   - /mason.nvim/lua/mason-core/functional/list.lua:116 _in_ **each**
  --   - /mason-nvim-dap.nvim/lua/mason-nvim-dap/init.lua:61 _in_ **setup_handlers**
  --   - /mason-nvim-dap.nvim/lua/mason-nvim-dap/init.lua:87 _in_ **setup**
  --   - lua/lazy-plugins.lua:93
  --   - init.lua:107
  -- require("kickstart.plugins.debug"),
  require("kickstart.plugins.indent_line"),
  require("kickstart.plugins.lint"),
  require("kickstart.plugins.autopairs"),
  require("kickstart.plugins.triptych"),
  -- require 'kickstart.plugins.leap',
  require("kickstart.plugins.flash"),
  -- require 'kickstart.plugins.neo-tree',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  { import = "custom.plugins.ai.avante" },
  { import = "custom.plugins.ai.mcphub" },
  -- { import = 'custom.plugins.ai.model' },
  -- { import = 'custom.plugins.cmp.autopairs' },
  { import = "custom.plugins.coding.annotation" },
  -- { import = 'custom.plugins.coding.cmp' },
  -- { import = 'custom.plugins.coding.luapad' },
  -- { import = 'custom.plugins.coding.mason' },
  { import = "custom.plugins.coding.nvim-snippets" },
  { import = "custom.plugins.treesitter.sibling-swap" },
  { import = "custom.plugins.treesitter.treesitter" },
  { import = "custom.plugins.treesitter.treesj" },
  { import = "custom.plugins.editor.docs.devdocs" },
  -- { import = 'custom.plugins.editor.fzf' },
  -- { import = 'custom.plugins.editor.git.blame' },
  -- { import = 'custom.plugins.editor.git.diffview' },
  -- { import = 'custom.plugins.editor.git.git-conflict' },
  { import = "custom.plugins.editor.git.neogit" },
  -- { import = 'custom.plugins.editor.leap' },
  -- { import = 'custom.plugins.editor.neo-tree' },
  { import = "custom.plugins.editor.nvim-colorizer" },
  { import = "custom.plugins.editor.search-replace" },
  -- { import = 'custom.plugins.editor.trouble' },
  { import = "custom.plugins.formatting.prettier" },
  { import = "custom.plugins.formatting.trim_newlines" },
  { import = "custom.plugins.lang.bash" },
  { import = "custom.plugins.lang.docker" },
  { import = "custom.plugins.lang.git" },
  { import = "custom.plugins.lang.go" },
  { import = "custom.plugins.lang.json" },
  { import = "custom.plugins.lang.kitty" },
  { import = "custom.plugins.lang.lua" },
  { import = "custom.plugins.lang.markdown" },
  { import = "custom.plugins.lang.python" },
  { import = "custom.plugins.lang.ruby" },
  { import = "custom.plugins.lang.sql" },
  { import = "custom.plugins.lang.tilt" },
  { import = "custom.plugins.lang.web.html-css" },
  { import = "custom.plugins.lang.web.tailwind" },
  { import = "custom.plugins.lang.web.typescript" },
  { import = "custom.plugins.lang.xml" },
  { import = "custom.plugins.lang.yaml" },
  { import = "custom.plugins.linting.eslint" },
  { import = "custom.plugins.linting.stylelint" },
  -- { import = "custom.plugins.lsp.lspconfig" },
  { import = "custom.plugins.marks.grapple" },
  -- { import = 'custom.plugins.mini.mini-ai' },
  -- { import = 'custom.plugins.mini.mini-diff' },
  -- { import = 'custom.plugins.mini.mini-files' },
  -- { import = 'custom.plugins.mini.mini-surround' },
  -- { import = 'custom.plugins.ui.bufferline' },
  -- { import = "custom.plugins.ui.dap-view" },
  -- { import = 'custom.plugins.ui.edgy' },
  { import = "custom.plugins.ui.helpview" },
  { import = "custom.plugins.ui.log-highlight" },
  -- { import = 'custom.plugins.ui.lualine' },
  -- { import = 'custom.plugins.ui.noice' },
  -- { import = 'custom.plugins.ui.smooth-scrolling' },
  -- { import = "custom.plugins.ui.snacks" },
  { import = "custom.plugins.editor.snacks_picker" },
  -- { import = "custom.plugins.editor.snacks_explorer" },
  { import = "custom.plugins.ui.which-key" },
  { import = "custom.plugins.util.better-escape" },
  -- { import = 'custom.plugins.util.persistence' },
  { import = "custom.plugins.util.smart-splits" },
  { import = "custom.plugins.coding.multicursor" },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
  -- spec = spec,
  defaults = {
    -- By default, only Util.lazy plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        -- NVChad
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "logipat",
        "netrw",
        "netrwPlugin",
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
    -- Fallback to git when local plugin doesn't exist
    fallback = true,
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
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
  icons = vim.g.have_nerd_font and {} or {
    cmd = "⌘",
    config = "🛠",
    event = "📅",
    ft = "📂",
    init = "⚙",
    keys = "🗝",
    plugin = "🔌",
    runtime = "💻",
    require = "🌙",
    source = "📄",
    start = "🚀",
    task = "📌",
    lazy = "💤 ",
  },
  -- icons = vim.g.icon_size == "small" and { kinds = require("util.icons").kinds } or {},
})

-- vim: ts=2 sts=2 sw=2 et
