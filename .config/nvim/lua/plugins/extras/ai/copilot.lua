local M = {}
local panel_enabled = false
local copilot_chat_prefix = "<leader>aC"
local keys = {}
-- stylua: ignore start
-- if vim.g.ai_cmp then
--   keys[#keys+1] = { "<leader>cIt", function() require("copilot.suggestion").toggle_auto_trigger() end, desc = "Toggle auto trigger" }
--   if panel_enabled then
--     keys[#keys+1] ={ "<leader>avp", function() require("copilot.panel").open({ "bottom", 0.25 }) end, desc = "Toggle Copilot Panel" }
--     keys[#keys+1] ={ "<leader>c]", function() require("copilot.panel").jump_next() end, desc = "Jump next (Copilot Panel)" }
--     keys[#keys+1] ={ "<leader>c[", function() require("copilot.panel").jump_prev() end, desc = "Jump prev (Copilot Panel)" }
--     keys[#keys+1] ={ "<leader>cg", function() require("copilot.panel").accept() end, desc = "Jump prev (Copilot Panel)" }
--   end
-- end
-- stylua: ignore end

---@param kind string
function M.pick(kind)
  return function()
    local actions = require("CopilotChat.actions")
    local items = actions[kind .. "_actions"]()
    if not items then
      LazyVim.warn("No " .. kind .. " found on the current line")
      return
    end
    local ok = pcall(require, "fzf-lua")
    require("CopilotChat.integrations." .. (ok and "fzflua" or "telescope")).pick(items)
  end
end

return {
  { import = "lazyvim.plugins.extras.ai.copilot" },
  -- { import = "lazyvim.plugins.extras.ai.copilot-chat" },
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    -- event = "InsertEnter",
    opts = function(_, opts)
      -- if vim.g.ai_cmp then
      --   opts.suggestion = {
      --     enabled = true,
      --     auto_trigger = true,
      --     keymap = {
      --       accept = "<M-CR>",
      --       accept_line = "<M-l>",
      --       accept_word = "<M-k>",
      --       next = "<M-]>",
      --       prev = "<M-[>",
      --       dismiss = "<M-c>",
      --       -- accept = "<M-C-CR>",
      --       -- accept_line = "<M-C-l>",
      --       -- accept_word = "<M-C-k>",
      --       -- next = "<M-C-]>",
      --       -- prev = "<M-C-[>",
      --       -- dismiss = "<M-C-c>",
      --     },
      --   }
      -- else
      --   opts.suggestion = { enabled = false }
      --   -- It is recommended to disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp. To do so, simply place the following in your copilot.lua config:
      --   opts.panel = { enabled = false }
      --   if panel_enabled then opts.panel = { enabled = true, auto_refresh = true } end
      --   -- opts.panel = { enabled = true, auto_refresh = true }
      --   -- opts.cmp = {
      --   --   enabled = true,
      --   --   method = "getCompletionsCycling",
      --   -- },
      -- end

      -- node needs to be symlinked to /usr/local/bin
      -- opts.copilot_node_command

      opts.filetypes = vim.tbl_extend("force", opts.filetypes, {
        mchat = false,
      })

      return opts
    end,
    keys = keys,
    -- config = function(_, opts)
    --   if vim.g.ai_cmp then
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
          if vim.g.ai_cmp then
            require("copilot").setup({
              suggestion = {
                enabled = false,
                auto_trigger = false,
              },
            })
            vim.g.ai_cmp = false
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
            vim.g.ai_cmp = true
          end
          vim.cmd("Lazy reload copilot.lua")
        end, { desc = "Toggle Copilot Suggestion" })
      end)
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    optional = true,
    branch = "canary",
    cmd = "CopilotChat",
    build = "make tiktoken", -- TODO: is this needed?
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      -- local ag = vim.api.nvim_create_augroup("CopilotChat", { clear = true })
      -- vim.api.nvim_create_autocmd("BufEnter", {
      --   pattern = "copilot-chat",
      --   group = ag,
      --   callback = function(ev)
      --     -- vim.api.nvim_buf_set_keymap(ev.buf, "n", key[1], key[2], key[3])
      --   end,
      -- })
      return {
        model = "claude-3.5-sonnet",
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = {
      { "<C-x>", "<cmd>CopilotChatStop<cr>", ft = "copilot-chat", desc = "Stop current chat" },
      { "<localleader><esc>", "<cmd>CopilotChatStop<cr>", ft = "copilot-chat", desc = "Stop current chat" },
      { "<localleader>r", "<cmd>CopilotChatReset<cr>", ft = "copilot-chat", desc = "Reset chat" },
      { "<localleader>s", "<cmd>CopilotChatSave<cr>", ft = "copilot-chat", desc = "Save chat" },
      { "<localleader>l", "<cmd>CopilotChatLoad<cr>", ft = "copilot-chat", desc = "Load chat" },
      { "<localleader>?", "<cmd>CopilotChatDebugInfo<cr>", ft = "copilot-chat", desc = "Show debug info" },
      { "<localleader>m", "<cmd>CopilotChatModels<cr>", ft = "copilot-chat", desc = "Show available models" },
      { "<localleader>a", "<cmd>CopilotChatAgents<cr>", ft = "copilot-chat", desc = "Show available agents" },
      {
        "<M-0>",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      -- Override lazyvim keymaps
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        copilot_chat_prefix .. "a",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        copilot_chat_prefix .. "x",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        copilot_chat_prefix .. "q",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then require("CopilotChat").ask(input) end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      -- Show help actions with telescope
      { copilot_chat_prefix .. "d", M.pick("help"), desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
      -- Show prompts actions with telescope
      { copilot_chat_prefix .. "p", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = { "n", "v" },
        { copilot_chat_prefix, group = "CopilotChat", icon = { icon = " ", color = "orange" }, mode = { "n", "v" } },
      },
    },
  },
}
