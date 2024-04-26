return {
  "nvim-telescope/telescope-live-grep-args.nvim",
  event = "VeryLazy",
  config = function()
    require("telescope").load_extension("lazy")
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")
    -- local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
    telescope.setup({
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = { -- extend mappings
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-I>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            -- ["<C-m>"] = lga_actions.quote_prompt({ postfix = " --glob **/*.{md,mdx} " }),
          },
        },
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      },
    })
  end,
  commands = {
    LiveGrepArgs = function()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end,
  },
  -- stylua: ignore
  keys = function()
    local lga_actions = require("telescope-live-grep-args.actions")
    return {
      { "<leader>su", function() require("telescope-live-grep-args.shortcuts").grep_word_under_cursor() end, desc = "Grep (current word)" },
      { "<leader>sg", function() require("telescope").extensions.live_grep_args.live_grep_args() end,        desc = "Grep (root dir)" },
      {
        "<leader>/",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            postfix = " --glob '!./node_modules/*'"
          })
        end,
        desc = "Grep (root dir)"
      },
      }
  end
,
}
