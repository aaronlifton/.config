return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        -- Disable Util.lazy keymaps
        -- { "<BS>", false },
        -- { "<c-space>", false },
        { "<M-Down>", desc = "Decrement Selection", mode = "x" },
        { "<M-Up>", desc = "Increment Selection", mode = { "x", "n" } },
      },
    },
  },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    event = { "LazyFile", "VeryLazy" },
    --- event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
      {
        ";",
        function()
          local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
          ts_repeat_move.repeat_last_move_next()
        end,
      },
      {
        ",",
        function()
          local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
          ts_repeat_move.repeat_last_move_previous()
        end,
      },
    },
    opts_extend = { "ensure_installed" },
    opts = {
      -- stylua: ignore start
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'javascript', 'jsdoc', 'json', 'jsonc', 'lua', 'luadoc', 'luap', 'markdown', 'markdown_inline', 'printf', 'python', 'query', 'regex', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'xml', 'yaml' },
      -- stylua: ignore end
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby", "go" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          -- Lazy keymaps
          -- init_selection = "<C-space>",
          -- node_incremental = "<C-space>",
          -- scope_incremental = false,
          -- node_decremental = "<bs>",
          -- Helix keymaps
          -- (<A-o> <A-up>) Expand selection to parent syntax node
          -- (<A-down> <A-i>) Shrink selection to previously expanded syntax node
          init_selection = "<M-o>",
          node_incremental = "<M-o>",
          scope_incremental = false,
          node_decremental = "<M-i>",
        },
      },
      textobjects = {
        lsp_interop = {
          enable = true,
          border = "rounded", -- "none"
          floating_preview_opts = { maximum_height = 12 },
          peek_definition_code = {
            -- Overrides <C-w>p - previous window
            ["<C-w>p"] = "@function.outer",
            ["g<C-d>"] = "@function.outer",
            ["g<C-c>"] = "@class.outer",
            ["g<C-k>"] = "@function.outer",
            ["g<C-f>"] = "@function.outer",
            -- ["df"] = "@function.outer",
            -- ["dF"] = "@class.outer",
          },
        },
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
      matchup = { enable = true },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    enabled = true,
    config = function()
      -- If treesitter is already loaded, we need to run config again for textobjects
      if Util.lazy.is_loaded("nvim-treesitter") then
        local opts = Util.lazy.opts("nvim-treesitter")
        require("nvim-treesitter.configs").setup({ textobjects = opts.textobjects })
      end

      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
}
-- vim: ts=2 sts=2 sw=2 et
