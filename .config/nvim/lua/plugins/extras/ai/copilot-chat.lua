local M = {}
local user = "Aaron"
local copilot_chat_prefix = "<leader>aA"

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
  { import = "lazyvim.plugins.extras.ai.copilot-chat" },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    optional = true,
    cmd = "CopilotChat",
    dependencies = {
      {
        "folke/which-key.nvim",
        opts = {
          spec = {
            mode = { "n", "v" },
            {
              copilot_chat_prefix,
              group = "CopilotChat",
              icon = { icon = " ", color = "orange" },
              mode = { "n", "v" },
            },
          },
        },
      },
    },
    opts = function()
      return {
        model = "gpt-5.2-codex",
        question_header = " " .. " " .. " ",
        answer_header = " " .. LazyVim.config.icons.kinds.Copilot .. " ",
        error_header = " " .. LazyVim.config.icons.diagnostics.Warn .. " ",
        prompts = {
          Plan = {
            prompt = "Create or update the development plan for the selected code. Focus on architecture, implementation steps, and potential challenges.",
            system_prompt = COPILOT_PLAN,
            context = "file:.copilot/plan.md",
            progress = function()
              return false
            end,
            callback = function(response, source)
              chat.chat:append("Plan updated successfully!", source.winnr)
              local plan_file = source.cwd() .. "/.copilot/plan.md"
              local dir = vim.fn.fnamemodify(plan_file, ":h")
              vim.fn.mkdir(dir, "p")
              local file = io.open(plan_file, "w")
              if file then
                file:write(response)
                file:close()
              end
            end,
          },
        },
        -- contexts = {
        --   vectorspace = {
        --     description = "Semantic search through workspace using vector embeddings. Find relevant code with natural language queries.",
        --
        --     schema = {
        --       type = "object",
        --       required = { "query" },
        --       properties = {
        --         query = {
        --           type = "string",
        --           description = "Natural language query to find relevant code.",
        --         },
        --         max = {
        --           type = "integer",
        --           description = "Maximum number of results to return.",
        --           default = 10,
        --         },
        --       },
        --     },
        --
        --     resolve = function(input, source, prompt)
        --       local cutils = require("CopilotChat.utils")
        --       local embeddings = require("CopilotChat.utils.curl").post("http://localhost:8000/query", {
        --         json_request = true,
        --         json_response = true,
        --         body = {
        --           dir = source.cwd(),
        --           text = input.query or prompt,
        --           max = input.max,
        --         },
        --       }).body
        --
        --       cutils.schedule_main()
        --       return vim
        --         .iter(embeddings)
        --         :map(function(embedding)
        --           embedding.filetype = cutils.filetype(embedding.filename)
        --           return embedding
        --         end)
        --         :filter(function(embedding)
        --           return embedding.filetype
        --         end)
        --         :totable()
        --     end,
        --   },
        -- },
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
        copilot_chat_prefix .. "t",
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
    init = function()
      vim.g.copilot_no_tab_map = true
      --   vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
    end,
  },
}
