local use_fzf = true
local last_input = nil
if use_fzf then
  return {
    { import = "lazyvim.plugins.extras.editor.fzf" },
    {
      "ibhagwan/fzf-lua",
      cond = function()
        return LazyVim.has("fzf-lua")
      end,
      keys = {
        { "<leader>su", "<cmd>lua require('fzf-lua').grep_cword()<CR>", desc = "Grep (current word)", mode = "n" },
        { "<leader>su", "<cmd>lua require('fzf-lua').grep_visual()<CR>", desc = "Grep (selection)", mode = "v" },
        -- {
        --   "<leader>sx",
        --   function()
        --     require("fzf-lua").live_grep({
        --       no_esc = true,
        --       rg_glob = true,
        --       rg_opts = "--iglob=*.lua --iglob=!*{test,spec}*",
        --     })
        --   end,
        --   desc = "Grep (escaped, root dir)",
        --   mode = "n",
        -- },
        {
          "<leader>sg",
          function()
            local actions = require("fzf-lua.actions")
            ---@param flag string
            local toggle_flag = function(flag)
              return function(_, opts)
                actions.toggle_flag(
                  _,
                  vim.tbl_extend("force", opts, {
                    toggle_flag = flag,
                  })
                )
              end
            end
            require("fzf-lua").live_grep({
              actions = {
                ["ctrl-y"] = toggle_flag("--iglob=*.lua --iglob=!*{test,spec}*"),
                ["ctrl-j"] = toggle_flag("--iglob=*.{js,ts,tsx} --iglob=!*{test,spec}*"),
                ["alt-t"] = toggle_flag("--iglob=*{spec,test}*"),
                -- ["ctrl-z"] = function(_, opts)
                --   local current_buf = vim.api.nvim_get_current_buf()
                --   local win = vim.api.nvim_get_current_win()
                --   -- vim.api.nvim_echo({ { "Current buffer: " .. vim.inspect(current_buf), "Normal" } }, true, {})
                --   require("leap").leap({
                --     target_windows = { win },
                --   })
                -- end,
              },
            })
          end,
          desc = "Grep (root dir)",
        },
        {
          "<leader>/",
          "<cmd>lua require('fzf-lua').live_grep({ glob = '!./node_modules/*' })<CR>",
          desc = "Grep (root dir)",
        },
        {
          "<C-x><C-f>",
          function()
            require("fzf-lua").complete_path()
          end,
          mode = { "n", "v", "i" },
          silent = true,
          desc = "Fuzzy complete path",
        },
      },
    },
  }
else
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
end
