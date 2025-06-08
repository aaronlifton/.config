local M = { state = {
  provider_states = {},
} }
local prefix = "<leader>aP"
local modify_prefix = "<leader>am"
local provider_prefix = "<leader>ap"

--- Opens a new chat window, remembering the last chat for the provider
---@param provider string
---@param model string
---@param target string?
---@param prompt string?
local function open_parrot_chat(provider, model, target, prompt)
  local filename = vim.fn.bufname(vim.api.nvim_get_current_buf())
  if filename:match("parrot/chats") then return vim.api.nvim_win_close(0, true) end

  target = target or "vsplit"
  local config = require("parrot.config")
  local chat_handler = config.chat_handler
  local kind = (target and target == "popup" and "popup") or "chat"
  local toggle_kind = chat_handler:toggle_resolve(kind)
  local params = { args = target }

  -- Initialize provider state if it doesn't exist
  M.state.provider_states[provider] = M.state.provider_states[provider]
    or {
      toggle_state = nil,
      last_chat = nil,
    }

  local provider_state = M.state.provider_states[provider]
  local toggle_state = chat_handler._toggle[toggle_kind]

  -- vim.api.nvim_echo({ { vim.inspect(M.state.provider_states), "Normal" } }, true, {})
  -- If we have a toggle state and last chat for this provider
  if provider_state.last_chat then
    -- vim.api.nvim_echo({ { ("Seting last to chat to %s"):format(provider_state.last_chat), "Normal" } }, true, {})
    chat_handler.state:set_last_chat(provider_state.last_chat)
    chat_handler:chat_toggle(params)
    chat_handler._toggle[toggle_kind] = toggle_state
    return
  else
    -- vim.api.nvim_echo({ { "Not found", "Title" }, { vim.inspect(M.state.provider_states), "Normal" } }, true, {})
    chat_handler._toggle[toggle_kind] = nil
  end

  chat_handler:set_provider(provider, true)
  chat_handler:switch_model(true, model, { name = provider })

  local current_buf = chat_handler:chat_new(params, prompt)
  local chat_file = vim.api.nvim_buf_get_name(current_buf)

  -- Update provider state after opening new chat
  provider_state.toggle_state = chat_handler._toggle[toggle_kind]
  -- The plugin will call set_last_chat internally, which we'll capture in the next chat
  provider_state.last_chat = chat_file
end

--- Edit a selection of code in place
---@param target string
---@param prompt string
local function parrot_edit(target, prompt)
  local template = ([[
          %s
          ```{{filetype}}
          {{selection}}
          ```

          Respond just with the snippet of code that should be inserted.
          ]]):format(prompt)
  local prt = require("parrot.config")
  local model_obj = prt.get_model("command")
  local selection = require("util.selection").get_selection()
  local params = { range = 2, line1 = selection.start_line, line2 = selection.end_line }
  prt.Prompt(params, prt.ui.Target[target], model_obj, nil, template)
end

return {
  {
    "frankroeder/parrot.nvim",
    dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
    cmd = { "PrtChatNew" },
    opts = {
      chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
      chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
      chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
      chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },
      command_auto_select_response = true,
      -- enable_spinner = false, -- incompatible with snacks notifier
      hooks = {
        CompleteFullContext = function(prt, params)
          local template = [[
          I have the following code from {{filename}}:

          ```{{filetype}}
          {filecontent}}
          ```

          Please look at the following section specifically:
          ```{{filetype}}
          {{selection}}
          ```

          Please finish the code above carefully and logically.
          Respond just with the snippet of code that should be inserted.
          ]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
        CompleteAsk = function(prt, params)
          local template = [[
                  I have the following code from {{filename}}:

                  ```{{filetype}}
                  {filecontent}}
                  ```

                  Implement the following ask:
                  ```{{selection}}```

                Please finish the code above carefully and logically.
                Respond just with the snippet of code that should be inserted.
                Do NOT return anything but a single markdown code block.
                ]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
        AddComments = function(prt, params)
          local template = [[
          Add comments to the following code:
          ```{{filetype}}
          {{selection}}
          ```

          Respond just with the snippet of code that should be inserted.
          ]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.replace, model_obj, nil, template)
        end,
      },
    },
    keys = {
      { prefix .. "n", "<cmd>PrtChatNew<cr>", desc = "New Chat" },
      { prefix .. "P", "<cmd>PrtChatNew popup<cr>", desc = "New Chat (Popup)" },
      { prefix .. "V", "<cmd>PrtChatNew vsplit<cr>", desc = "New Chat (vsplit)" },
      { prefix .. "T", "<cmd>PrtChatNew tabnew<cr>", desc = "New Chat (New Tab)" },
      { prefix .. "N", "<cmd>PrtTabnew<cr>", desc = "New Chat (Tab)" },
      { prefix .. "e", "<cmd>PrtEnew<cr>", desc = "New Chat (Tab)" },
      { prefix .. "v", "<cmd>PrtVnew<cr>", desc = "New Chat (vsplit)" },
      { prefix .. "m", "<cmd>PrtModel<cr>", desc = "Choose model" },
      { prefix .. "a", "<cmd>PrtAsk<cr>", desc = "Ask" },
      { prefix .. "p", "<cmd>PrtProvider<cr>", desc = "Choose provider", mode = { "n", "v" } },
      { prefix .. ">", "<cmd>PrtAppend<cr>", desc = "Append", mode = "v" },
      { prefix .. "<", "<cmd>PrtPrepend<cr>", desc = "Prepend", mode = "v" },
      { prefix .. "r", "<cmd>PrtRewrite<cr>", desc = "Rewrite", mode = "v" },
      { prefix .. "i", "<cmd>PrtImplement<cr>", desc = "Implement", mode = "v" },
      { prefix .. "R", "<cmd>PrtRetry<cr>", desc = "Retry" },
      { prefix .. "<Tab>", "<cmd>PrtChatToggle<cr>", desc = "Toggle chat" },
      { prefix .. "<Esc>", "<cmd>PrtChatStop<cr>", desc = "Stop" },
      {
        "<M-=>",
        function()
          open_parrot_chat("openai", "gpt-4o")
        end,
        desc = "Toggle (OpenAI)",
      },
      {
        provider_prefix .. "o",
        function()
          open_parrot_chat("openai", "gpt-4o", "popup")
        end,
        desc = "OpenAI",
      },
      -- {
      --   provider_prefix .. "x",
      --   function()
      --     open_parrot_chat("xai", "grok-3-beta")
      --   end,
      --   desc = "xAI",
      -- },
      -- {
      --   "<M-9>",
      --   function()
      --     open_parrot_chat("gemini", "gemini-1.5-flash")
      --   end,
      --   desc = "Toggle (Gemini)",
      -- },
      -- {
      --   "<M-8>",
      --   function()
      --     open_parrot_chat("mistral", "codestral-mamba-latest")
      --   end,
      --   desc = "Toggle (Codestral)",
      -- },
      {
        modify_prefix .. "o",
        function()
          parrot_edit("rewrite", "Write the following code in a more succinct, idiomatic way:")
        end,
        desc = "Optimize code",
        mode = "v",
      },
    },
    config = function(_, opts)
      require("parrot").setup(vim.tbl_extend("force", opts, {
        -- Providers must be explicitly added to make them available.
        providers = {
          anthropic = {
            api_key = os.getenv("ANTHROPIC_API_KEY"),
          },
          gemini = {
            api_key = os.getenv("GOOGLE_API_KEY"), -- GEMINI_API_KEY
          },
          groq = {
            api_key = os.getenv("GROQ_API_KEY"),
          },
          mistral = {
            api_key = os.getenv("MISTRAL_API_KEY"),
          },
          pplx = {
            api_key = os.getenv("PERPLEXITY_API_KEY"),
          },
          xai = {
            api_key = os.getenv("XAI_API_KEY"),
          },
          -- provide an empty list to make provider available (no API key required)
          ollama = {},
          openai = {
            api_key = os.getenv("OPENAI_API_KEY"),
          },
        },
      }))

      -- OVERRIDDEN: Returns the list of available models
      ---@return string[]
      local Mistral = require("parrot.provider.mistral")
      function Mistral:get_available_models()
        return {
          "codestral-latest",
          "mistral-tiny",
          "mistral-small-latest",
          "mistral-medium-latest",
          "mistral-large-latest",
          "open-mistral-7b",
          "open-mixtral-8x7b",
          "open-mixtral-8x22b",
          "codestral-mamba-latest",
        }
      end
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>aP", group = "+Parrot", icon = "󱜚 ", mode = { "n", "v" } },
      },
    },
  },
}
