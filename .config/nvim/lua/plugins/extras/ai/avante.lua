local _vendors = {
  deepseek = {
    __inherited_from = "openai",
    api_key_name = "DEEPSEEK_API_KEY",
    endpoint = "https://api.deepseek.com",
    model = "deepseek-coder",
    -- endpoint = "https://api.deepseek.com/v1",
    -- model = "deepseek-chat",
    -- timeout = 30000, -- Timeout in milliseconds
    -- temperature = 0,
    -- max_tokens = 4096,
  },
}

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    -- lazy = false,

    -- For developmennt
    -- branch = "feat/better-ruby-parsing",
    -- pin = true,
    -- build = "make BUILD_FROM_SOURCE=true",

    -- For non-development
    version = false, -- set this to "*" if you want to always pull the latest change
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",

    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = {
          file_types = { "Avante" },
        },
        ft = { "Avante" },
      },
    },
    --- @type avante.Config
    opts = {
      -- Defaults
      -- provider = "claude",
      -- auto_suggestions_provider = "claude",
      -- claude = {
      --   endpoint = "https://api.anthropic.com",
      --   model = "claude-3-5-sonnet-20241022",
      --   temperature = 0,
      --   max_tokens = 4096,
      -- },
      -- behaviour = {
      --   auto_focus_sidebar = true,
      --   auto_suggestions = false, -- Experimental stage
      --   auto_suggestions_respect_ignore = false,
      --   auto_set_highlight_group = true,
      --   auto_set_keymaps = true,
      --   auto_apply_diff_after_generation = false,
      --   jump_result_buffer_on_finish = false,
      -- jump_to_result_buffer_on_finish = true,
      --   support_paste_from_clipboard = false,
      --   minimize_diff = true,
      -- },
      -- Defaults: ~/.local/share/nvim/lazy/avante.nvim/lua/avante/config.lua
      mappings = {
        ask = "<leader>aa", -- <leader>aa
        edit = "<leader>ae", -- <leader>ate
        refresh = "<leader>atr", -- <leader>ar
        chat = "<leader>atc", -- <leader>ac
        files = {
          add_current = "<leader>aA",
        },
      },
      hints = {
        enabled = false,
      },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        -- width = 40, -- default 30% of available width
      },
      repo_map = {
        -- stylua: ignore start
        ignore_patterns = {
          -- Default
          "%.git", "%.worktree", "__pycache__", "node_modules",
          -- Rails
          "Gemfile", "Gemfile%.lock", "config", "db", "git_hooks", "k8s", "log", "public", "script", "spec", "bin", "vendor", "swagger", "test", "tmp", "%.ruby%-lsp"
        },
        -- stylua: ignore end
      },
      file_selector = {
        provider = "fzf",
      },
      --- @class AvanteConflictUserConfig
      diff = {
        ---@type string | fun(): any
        list_opener = "Trouble quickfix",
        --   --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
        --   --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
        --   --- Disable by setting to -1.
        --   override_timeoutlen = 500,
      },
      completion = {
        cmp = {
          input_container = {
            sources = {
              {
                name = "buffer",
                option = {
                  -- get_bufnrs = require("util.win").editor_bufs,
                  get_bufnrs = function()
                    local windows = vim.api.nvim_tabpage_list_wins(0)
                    return vim
                      .iter(windows)
                      :map(function(win)
                        return vim.api.nvim_win_get_buf(win)
                      end)
                      :filter(function(buf)
                        return vim.bo[buf].buflisted
                      end)
                      :totable()
                  end,
                },
              },
            },
          },
        },
      },
    },
    keys = function(_, keys)
      ---@type avante.Config
      local opts =
        require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["avante.nvim"], "opts", false)

      -- stylua: ignore start
      local mappings = {
        { "<M-->", function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
        -- { "<leader>ata", function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
        { opts.mappings.ask, function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
        { opts.mappings.refresh, function() require("avante.api").refresh() end, desc = "avante: refresh", mode = "v" },
        { opts.mappings.edit, function() require("avante.api").edit() end, desc = "avante: edit", mode = { "n", "v" } },
        { opts.mappings.chat, function() vim.cmd("AvanteChat") end, desc = "avante: chat", mode = { "n" } },
        { "<leader>ats", function() require("avante.api").get_suggestion():suggest() end, desc = "avante: suggest", mode = { "n" } },
      }
      -- stylua: ignore end

      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "saghen/blink.compat",
    },
    opts = {
      sources = {
        compat = {
          "avante_commands",
          "avante_mentions",
          "avante_files",
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>at", group = "+Avante", icon = "󱜚 ", mode = "v" },
      },
    },
  },
}
