local panel_enabled = false
local keys = {}
-- stylua: ignore start
if vim.g.copilot_ghost_text then
  keys[#keys+1] = { "<leader>cIt", function() require("copilot.suggestion").toggle_auto_trigger() end, desc = "Toggle auto trigger" }
  if panel_enabled then
    keys[#keys+1] ={ "<leader>avp", function() require("copilot.panel").open({ "bottom", 0.25 }) end, desc = "Toggle Copilot Panel" }
    keys[#keys+1] ={ "<leader>c]", function() require("copilot.panel").jump_next() end, desc = "Jump next (Copilot Panel)" }
    keys[#keys+1] ={ "<leader>c[", function() require("copilot.panel").jump_prev() end, desc = "Jump prev (Copilot Panel)" }
    keys[#keys+1] ={ "<leader>cg", function() require("copilot.panel").accept() end, desc = "Jump prev (Copilot Panel)" }
  end
end
-- stylua: ignore end

return {
  { import = "lazyvim.plugins.extras.coding.copilot" },
  { import = "lazyvim.plugins.extras.coding.copilot-chat" },
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    -- event = "InsertEnter",
    opts = function(_, opts)
      if vim.g.copilot_ghost_text then
        opts.suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-CR>",
            accept_line = "<M-l>",
            accept_word = "<M-k>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<M-c>",
            -- accept = "<M-C-CR>",
            -- accept_line = "<M-C-l>",
            -- accept_word = "<M-C-k>",
            -- next = "<M-C-]>",
            -- prev = "<M-C-[>",
            -- dismiss = "<M-C-c>",
          },
        }
      else
        opts.suggestion = { enabled = false }
        -- It is recommended to disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp. To do so, simply place the following in your copilot.lua config:
        opts.panel = { enabled = false }
        if panel_enabled then
          opts.panel = { enabled = true, auto_refresh = true }
        end
        -- opts.panel = { enabled = true, auto_refresh = true }
        -- opts.cmp = {
        --   enabled = true,
        --   method = "getCompletionsCycling",
        -- },
      end
      -- node needs to be symlinked to /usr/local/bin
      -- opts.copilot_node_command

      return opts
    end,
    keys = keys,
    -- config = function(_, opts)
    --   if vim.g.copilot_ghost_text then
    --     local cmp = require("cmp")
    --     cmp.event:on("menu_opened", function()
    --       vim.b.copilot_suggestion_hidden = true
    --     end)
    --
    --     cmp.event:on("menu_closed", function()
    --       vim.b.copilot_suggestion_hidden = false
    --     end)
    --   end
    -- end,
    init = function()
      LazyVim.on_very_lazy(function()
        vim.keymap.set("n", "<leader>cIc", function()
          if vim.g.copilot_ghost_text then
            require("copilot").setup({
              suggestion = {
                enabled = false,
                auto_trigger = false,
              },
            })
            vim.g.copilot_ghost_text = false
          else
            require("copilot").setup({
              suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                  accept = "<M-CR>",
                  accept_line = "<M-l>",
                  accept_word = "<M-k>",
                  next = "<M-]>",
                  prev = "<M-[>",
                  dismiss = "<M-c>",
                },
              },
            })
            vim.g.copilot_ghost_text = true
          end
          vim.api.nvim_command("Lazy reload copilot.lua")
        end, { desc = "Toggle Copilot Suggestion" })
      end)
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    optional = true,
    keys = {
      {
        "<M-0>",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
    },
  },
}
