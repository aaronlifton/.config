return {
  "nvim-telescope/telescope-live-grep-args.nvim",
  config = function()
    local lga_actions = require("telescope-live-grep-args.actions")
    local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
    require("telescope").setup({
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = {         -- extend mappings
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            ["<C-m>"] = lga_actions.quote_prompt({ postfix = " --glob **/*.{md,mdx} " }),
          },
        }
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      }
    })
    require("telescope").load_extension("lazy")
  end,
  -- stylua: ignore
  keys = {
    { "<leader>gc", function() require("telescope-live-grep-args.shortcuts").grep_word_under_cursor() end, desc = "Grep (current word)" },
    { "<leader>sg", function() require("telescope").extensions.live_grep_args.live_grep_args() end,        desc = "Grep (root dir)" },
    -- { "<leader>/", function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Grep (root dir)" },
    -- { "<C-k>",      lga_actions.quote_prompt(),                                                     desc = "quote prompt" },
    -- { "<C-i>",      lga_actions.quote_prompt({ postfix = " --iglob " }),                            desc = "iglob" }
  },
}
