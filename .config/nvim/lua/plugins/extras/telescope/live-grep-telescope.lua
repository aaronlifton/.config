if not vim.g.lazyvim_picker == "telescope" then
  return {}
end
return {
  "nvim-telescope/telescope-live-grep-args.nvim",
  event = "VeryLazy",
  config = function()
    require("telescope").load_extension("lazy")
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")
    local custom_pickers = require("util.telescope_pickers")
    -- local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
    telescope.setup({
      extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-q>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-t>"] = lga_actions.quote_prompt({ postfix = " --iglob=!*{test,spec}*" }),
              ["<C-l>"] = lga_actions.quote_prompt({
                postfix = table.concat({
                  " --iglob=!*{test,spec}*",
                  "--iglob=*.lua",
                }, " "),
              }),
              ["<C-j>"] = lga_actions.quote_prompt({
                postfix = table.concat({
                  " --iglob=!*{test,spec}*",
                  "--iglob=*.{js,ts,tsx}",
                }, " "),
              }),
              ["<C-S-m>"] = lga_actions.quote_prompt({ postfix = " --glob **/*.{md,mdx} " }),
              ["<C-space>"] = lga_actions.to_fuzzy_refine,
              ["<C-f>"] = custom_pickers.actions.set_extension,
              ["<D-F>"] = custom_pickers.actions.set_folders,
            },
          },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        },
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
    return {
      {
        "<leader>su",
        function()
          require("telescope-live-grep-args.shortcuts").grep_word_under_cursor({
            cwd = require("util.telescope_finders").get_root(),
          })
        end,
        desc = "Grep (current word)",
        mode = "n",
      },
      {
        "<leader>su",
        function()
          require("telescope-live-grep-args.shortcuts").grep_visual_selection({
            cwd = require("util.telescope_finders").get_root(),
          })
        end,
        desc = "Grep (selection)",
        mode = "v",
      },
      {
        "<leader>sg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Grep (root dir)",
      },
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
