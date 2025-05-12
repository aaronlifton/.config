return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "nvim-telescope/telescope.nvim", -- Faster than fzf
      { "sindrets/diffview.nvim", optional = true },
    },
    cmd = { "Neogit" },
    opts = {
      integrations = {
        diffview = true,
        -- telescope = false,
        -- fzf_lua = true,
      },
      mappings = {
        status = {
          ["5"] = "PeekFile",
          ["<c-y>"] = "PeekFile",
        },
      },
      prompt_force_push = false,
      graph_style = "kitty",
    },
    keys = {
    -- stylua: ignore start
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
    { "<leader>gN", function() require("neogit").open({ kind = "split" }) end, desc = "Neogit (Split)" },
    { "<leader>g<cr>", function() require("neogit").open({ kind = "floating" }) end, desc = "Neogit (Popup)" },
    { "<leader>gP", function() require("neogit").action("stash", "push", { "-u" })() end, desc = "Stash file" },
    { "<leader>gwn", function() require("neogit").action("worktree", "create_worktree")() end, desc = "Create worktree" },
    { "<leader>gwc", function() require("neogit").action("worktree", "checkout_worktree")() end, desc = "Checkout worktree" },
      -- { "<leader>g<cr>", "<cmd>Neogit commit<cr>", desc = "Neogit - Commit" },
      -- stylua: ignore end
    },
    config = function(_, opts)
      require("neogit").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NeogitCommitView",
        callback = function(event)
          vim.keymap.set("n", "gf", function()
            local cfile = vim.fn.expand("<cfile>")
            local f = vim.fn.findfile(cfile)
            if f ~= "" then
              if not require("util.tab").goto_buf_tab(cfile) then vim.cmd("tabnew | e " .. f) end
            end
          end, { buffer = event.buf })
        end,
      })
      vim.ap.nvim_create_autocmd("FileType", {
        pattern = "NeogitCommitView", -- Buffer name: NeogitStashView
        callback = function(event)
          vim.keymap.set("n", "<C-y>", function()
            local StashListView = require("neogit.buffers.stash_list_view")
            local yank = StashListView.buffer.ui:get_commit_under_cursor()
            if not yank then return end

            vim.system({ "git", "diff", yank, yank .. "^", "--name-only" }, {}, function(result)
              -- stylua: ignore
              vim.api.nvim_echo({ { vim.inspect({code = result.code, signal = result.signal, stdout = result.stdout, stderr = result.stderr}), "Normal" } }, true, {})

              local content = result.stdout
              -- stylua: ignore
              vim.api.nvim_echo({ { vim.inspect({ { "Stashed files:\n", "Title" }, { content, "Normal" } }), "Normal" } }, true, {})
            end)
          end, { buffer = event.buf })
        end,
      })

      -- Already handled by <C-n> and <C-p>
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "NeogitStatus",
      --   callback = function(event)
      --     vim.keymap.set("n", "{", "zk", { buffer = event.buf, remap = true })
      --     vim.keymap.set("n", "}", "zj", { buffer = event.buf, remap = true })
      --   end,
      -- })

      -- Load git-conflict if it hasn't been loaded yet
      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitRebase",
        --- @param event {commit: string, status: string}
        callback = function(event)
          -- { commit: string, status: "ok" | "conflict" }
          if event.status == "conflict" then require("lazy").load({ plugins = { "git-conflict.nvim" } }) end
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { "<leader>gw", group = "Worktree", icon = { icon = "󰔱 ", color = "green" } },
      },
    },
  },
}
