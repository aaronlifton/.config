return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  -- lazy = false,
  version = false, -- set this if you want to always pull the latest change
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
    --   auto_suggestions = false, -- Experimental stage
    --   auto_set_highlight_group = true,
    --   auto_set_keymaps = true,
    --   auto_apply_diff_after_generation = false,
    --   support_paste_from_clipboard = false,
    -- },
    mappings = {
      ask = "<leader>aa", -- <leader>aa
      edit = "<leader>ate", -- <leader>ae
      refresh = "<leader>atr", -- <leader>ar
      chat = "<leader>atc", -- <leader>ac
      -- Defaults
      -- ask = "<leader>aa",
      -- edit = "<leader>ae",
      -- refresh = "<leader>ar",
      -- focus = "<leader>af",
      -- toggle = {
      --   default = "<leader>at",
      --   debug = "<leader>ad",
      --   hint = "<leader>ah",
      --   suggestion = "<leader>as",
      --   repomap = "<leader>aR",
      -- },
    },
    hints = {
      enabled = false,
    },
    windows = {
      ---@type "right" | "left" | "top" | "bottom"
      position = "right", -- the position of the sidebar
      wrap = true, -- similar to vim.o.wrap
      width = 40, -- default % based on available width
      -- sidebar_header = {
      --   enabled = true,
      --   align = "center", -- left, center, right for title
      --   rounded = true,
      -- },
      -- ask = {
      --   floating = false, -- Open the 'AvanteAsk' prompt in a floating window
      --   start_insert = true, -- Start insert mode when opening the ask window
      --   border = "rounded",
      --   ---@type "ours" | "theirs"
      --   focus_on_apply = "ours", -- which diff to focus after applying
      -- },
    },
    repo_map = {
      -- stylua: ignore start
      ignore_patterns = {
        -- Default
        "%.git", "%.worktree", "__pycache__", "node_modules",
        -- Rails
        "config", "db", "git_hooks", "k8s", "lib", "log", "public", "script", "spec", "swagger", "test", "tmp"
      },
      -- stylua: ignore end
    },
    file_selector = {
      provider = "fzf",
    },
    --- @class AvanteConflictUserConfig
    diff = {
      --   autojump = true,
      --   ---@type string | fun(): any
      list_opener = "Trouble quickfix",
      --   --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
      --   --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
      --   --- Disable by setting to -1.
      --   override_timeoutlen = 500,
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
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
  keys = function(_, keys)
    ---@type avante.Config
    local opts =
      require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["avante.nvim"], "opts", false)

    -- stylua: ignore start
    local mappings = {
      { "<M-->", function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
      { "<leader>ata", function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
      { opts.mappings.ask, function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
      { opts.mappings.refresh, function() require("avante.api").refresh() end, desc = "avante: refresh", mode = "v" },
      { opts.mappings.edit, function() require("avante.api").edit() end, desc = "avante: edit", mode = { "n", "v" } },
      { opts.mappings.chat, function() vim.cmd("AvanteChat") end, desc = "avante: chat", mode = { "n" } },
    }
    -- stylua: ignore end
    mappings = vim.tbl_filter(function(m)
      return m[1] and #m[1] > 0
    end, mappings)
    return vim.list_extend(mappings, keys)
  end,
}
