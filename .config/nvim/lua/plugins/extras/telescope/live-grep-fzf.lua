if not LazyVim.has_extra("editor.fzf") then
  return {}
end
return {
  -- { import = "lazyvim.plugins.extras.editor.fzf" },
  {
    -- LazyVim disabled telescope, so re-enable it for:
    -- <leader>p
    -- <leader>sy
    "nvim-telescope/telescope.nvim",
    enabled = false,
  },
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
  -- { import = "plugins.extras.lsp.glance" },
}
