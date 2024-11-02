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
    mappings = {
      ask = "<leader>ata",
      edit = "<leader>ate",
      refresh = "<leader>atr",
      chat = "<leader>atc",
    },
    hints = {
      enabled = false,
    },
    windows = {
      ---@type "right" | "left" | "top" | "bottom"
      position = "right", -- the position of the sidebar
      wrap = true, -- similar to vim.o.wrap
      width = 45, -- default % based on available width
      sidebar_header = {
        align = "center", -- left, center, right for title
        rounded = true,
      },
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

    local mappings = {
      {
        "<M-->",
        function()
          require("avante.api").ask()
        end,
        desc = "avante: ask",
        mode = { "n", "v" },
      },
      {
        opts.mappings.ask,
        function()
          require("avante.api").ask()
        end,
        desc = "avante: ask",
        mode = { "n", "v" },
      },
      {
        opts.mappings.refresh,
        function()
          require("avante.api").refresh()
        end,
        desc = "avante: refresh",
        mode = "v",
      },
      {
        opts.mappings.edit,
        function()
          require("avante.api").edit()
        end,
        desc = "avante: edit",
        mode = { "n", "v" },
      },
      {
        opts.mappings.chat,
        function()
          vim.cmd("AvanteChat")
        end,
        desc = "avante: chat",
        mode = { "n" },
      },
    }
    mappings = vim.tbl_filter(function(m)
      return m[1] and #m[1] > 0
    end, mappings)
    return vim.list_extend(mappings, keys)
  end,
}
