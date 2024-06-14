if not vim.g.lazyvim_picker == "fzf" then
  return {}
end
return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = true,
  },
  {
    "ibhagwan/fzf-lua",
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
          vim.api.nvim_echo({ { "Grep (root dir)" } }, true, {})
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
          require("fzf-lua").live_grep_glob({
            rg_glob = true,
            -- rg_glob_fn = function(query)
            --   local regex, flags = query:match("^(.-)%s%-%-(.*)$")
            --   -- If no separator is detected will return the original query
            --   return (regex or query), flags
            -- end,
            actions = {
              -- LazyVim mapping:
              -- ctrl-q: select-all+accept
              -- ctrl-u: half-page-up
              -- ctrl-d: half-page-down
              -- ctrl-x: jump
              -- <c-f>: preview-page-down
              -- <c-b>: preview-page-up
              -- ctrl-t: trouble
              -- ctrl-r: toggle-root-dir
              -- alt-c: toggle-root-dir
              ["ctrl-y"] = toggle_flag("--iglob=*.lua --iglob=!*{test,spec}*"),
              ["ctrl-j"] = toggle_flag("--iglob=*.{js,ts,tsx} --iglob=!*{test,spec}*"),
              ["alt-r"] = require("fzf-lua.config").defaults.actions.files["ctrl-r"],
              ["ctrl-r"] = toggle_flag("--iglob=*.rb --iglob=!*{test,spec}*"),
              ["alt-t"] = toggle_flag("--iglob=*{spec,test}*.{lua,js,ts,tsx,rb}"),
              ["alt-s"] = toggle_flag("--iglob=spec/**/*.rb"),
              ["alt-v"] = actions.toggle_hidden,
            },
          })
        end,
        desc = "Grep (root dir)",
      },
      {
        "<leader>/",
        function()
          require("fzf-lua").live_grep({ glob = "!./node_modules/*" })
        end,
        desc = "Grep (root dir)",
      },
      {
        "<leader>fM",
        function()
          require("fzf-lua").live_grep({ glob = "./node_modules/*" })
        end,
        desc = "Grep (node_modules)",
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
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "gd", false }
      keys[#keys + 1] = { "gr", false }
      keys[#keys + 1] = { "gy", false }
      keys[#keys + 1] = { "gI", false }
    end,
  },
}
