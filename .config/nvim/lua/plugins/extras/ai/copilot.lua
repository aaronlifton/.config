local copilot_ghost_text = false
return {
  { import = "lazyvim.plugins.extras.coding.copilot" },
  { import = "lazyvim.plugins.extras.coding.copilot-chat" },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = copilot_ghost_text
        and {
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
              -- accept = "<M-C-CR>",
              -- accept_line = "<M-C-l>",
              -- accept_word = "<M-C-k>",
              -- next = "<M-C-]>",
              -- prev = "<M-C-[>",
              -- dismiss = "<M-C-c>",
            },
          },
        }
      or {
        cmp = {
          enabled = true,
          method = "getCompletionsCycling",
        },
        suggestion = {
          enabled = false,
        },
        -- It is recommended to disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp. To do so, simply place the following in your copilot.lua config:
        panel = { enabled = false },
        -- panel = { enabled = true, auto_refresh = true },
        -- stylua: ignore start
        keys = copilot_ghost_text and {
          { "<leader>cIt", function() require("copilot.suggestion").toggle_auto_trigger() end, desc = "Toggle auto trigger" },
        } or {},
        -- { "<leader>avp", function() require("copilot.panel").open({ "bottom", 0.25 }) end, desc = "Toggle Copilot Panel" },
        -- { "<leader>c]", function() require("copilot.panel").jump_next() end, desc = "Jump next (Copilot Panel)" },
        -- { "<leader>c[", function() require("copilot.panel").jump_prev() end, desc = "Jump prev (Copilot Panel)" },
        -- { "<leader>cg", function() require("copilot.panel").accept() end, desc = "Jump prev (Copilot Panel)" },
        -- stylua: ignore end
      },
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
