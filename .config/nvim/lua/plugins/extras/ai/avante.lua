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
    -- No need since we lazy load via keys
    -- event = "VeryLazy",
    -- lazy = false,

    -- For developmennt
    -- branch = "feat/better-ruby-parsing",
    -- pin = true,
    -- build = "make BUILD_FROM_SOURCE=true",
    -- dev = true,

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
        -- requires osascript (OSX builtin) and pngpaste (brew install pngpaste)
        "HakonHarnes/img-clip.nvim",
        -- cond = false,
        -- event = "VeryLazy",
        ft = { "AvanteInput" },
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
        -- cmd = { "PasteImage" },
        -- keys = {
        --   { "<M-p>", "<cmd>PasteImage<cr>", desc = "Paste image", ft = { "markdown", "tex" }, mode = { "n", "v" } },
        -- },
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
      -- Defaults: ~/.local/share/nvim/lazy/avante.nvim/lua/avante/config.lua:189
      -- provider = "claude",
      -- auto_suggestions_provider = "claude",
      -- claude = {
      --   endpoint = "https://api.anthropic.com",
      --   -- model = "claude-3-5-sonnet-20241022",
      --   model = "claude-3-7-sonnet-20250219"
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
      --   -- jump_to_result_buffer_on_finish = true,
      --   support_paste_from_clipboard = false,
      --   minimize_diff = true,
      -- },
      -- Default keybindings: ~/.local/share/nvim/lazy/avante.nvim/lua/avante/config.lua:329
      mappings = {
        ask = "<leader>aa", -- <leader>aa
        edit = "<leader>ae", -- <leader>ate
        refresh = "<leader>ar", -- <leader>ar
        chat = "<leader>aC", -- <leader>ac
        files = {
          add_current = "<leader>aA",
        },
        toggle = {
          -- default = "<leader>at",
          debug = "<leader>axd",
          hint = "<leader>axh",
          suggestion = "<leader>axs",
          -- TODO: move to <leader>auR (AI Util category)
          -- repomap = "<leader>aR",
        },
        sidebar = {
          -- retry_user_request = "r",
          -- edit_user_request = "e",
          close_from_input = { normal = "<C-q>" },
        },
      },
      hints = {
        enabled = false,
      },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
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
      disabled_tools = { "python", "git_commit" }, -- Claude 3.7 overuses the python tool
      custom_tools = {
        {
          name = "run_go_tests", -- Unique name for the tool
          description = "Run Go unit tests and return results", -- Description shown to AI
          command = "go test -v ./...", -- Shell command to execute
          param = { -- Input parameters (optional)
            type = "table",
            fields = {
              {
                name = "target",
                description = "Package or directory to test (e.g. './pkg/...' or './internal/pkg')",
                type = "string",
                optional = true,
              },
            },
          },
          returns = { -- Expected return values
            {
              name = "result",
              description = "Result of the fetch",
              type = "string",
            },
            {
              name = "error",
              description = "Error message if the fetch was not successful",
              type = "string",
              optional = true,
            },
          },
          func = function(params, on_log, on_complete) -- Custom function to execute
            local target = params.target or "./..."
            return vim.fn.system(string.format("go test -v %s", target))
          end,
        },
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
        { opts.mappings.ask, function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
        { opts.mappings.refresh, function() require("avante.api").refresh() end, desc = "avante: refresh", mode = "v" },
        { opts.mappings.edit, function() require("avante.api").edit() end, desc = "avante: edit", mode = { "n", "v" } },
        { opts.mappings.chat, "<Plug>(AvanteChat)", desc = "avante: chat", mode = { "n" } },
        { opts.mappings.toggle.suggestion, function() require("avante").toggle.suggestion() end, desc = "avante: suggest", mode = { "n" } },
        { opts.mappings.toggle.hint, function() require("avante").toggle.hint() end, desc = "avante: hint", mode = { "n" } },
        { opts.mappings.toggle.debug, function() require("avante").toggle.debug() end, desc = "avante: debug", mode = { "n" } },
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
  -- {
  --   "folke/edgy.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.right = opts.right or {}
  --     table.insert(opts.right, {
  --       ft = "Avante",
  --       title = "Avante",
  --       size = { width = 70, height = 80 },
  --     })
  --     table.insert(opts.right, {
  --       ft = "AvanteSelectedFiles",
  --       title = "Avante",
  --       size = { width = 70, height = 30 },
  --     })
  --     table.insert(opts.right, {
  --       ft = "AvanteInput",
  --       title = "Avante",
  --       size = { width = 70, height = 40 },
  --     })
  --   end,
  -- },
}
