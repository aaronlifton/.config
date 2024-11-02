local get_selection = require("util.selection").get_selection
local prefix = "<leader>aP"

local function open_parrot_chat(provider, model, buftype)
  buftype = buftype or "vsplit"
  local config = require("parrot.config")
  local chat_handler = config.chat_handler
  chat_handler:set_provider(provider, true)
  chat_handler:switch_model(true, model, { name = provider })
  chat_handler:chat_new(buftype)
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
      { prefix .. "p", "<cmd>PrtProvider<cr>", desc = "Choose provider" },
      { prefix .. ">", "<cmd>PrtAppend<cr>", desc = "Append" },
      { prefix .. "<", "<cmd>PrtPrepend<cr>", desc = "Prepend" },
      { prefix .. "r", "<cmd>PrtRewrite<cr>", desc = "Rewrite" },
      { prefix .. "R", "<cmd>PrtRetry<cr>", desc = "Retry" },
      { prefix .. "<Tab>", "<cmd>PrtChatToggle<cr>", desc = "Toggle chat" },
      { prefix .. "<Esc>", "<cmd>PrtChatStop<cr>", desc = "Stop" },
      { prefix .. "i", "<cmd>PrtImplement<cr>", desc = "Implement selection", mode = "v" },
      {
        "<M-=>",
        function()
          open_parrot_chat("openai", "gpt-4o")
        end,
        desc = "Toggle (OpenAI)",
      },
      {
        "<M-9>",
        function()
          open_parrot_chat("gemini", "gemini-1.5-flash")
        end,
        desc = "Toggle (Gemini)",
      },
      {
        "<M-8>",
        function()
          open_parrot_chat("mistral", "codestral-mamba-latest")
        end,
        desc = "Toggle (Codestral)",
      },
      {
        "<leader>agrt",
        function()
          -- local prompt =
          --   'For the folllowing instructions, do not use "get :create" etc and instead use full routes like "api_v1_birds_path". Implement RSpec tests for the following code.\n\nCode:\n```{{filetype}}\n{{input}}\n```\n\nTests:\n```{{filetype}}'
          --
          -- local config = require("parrot.config")
          -- local ui = require("parrot.ui")
          -- local utils = require("parrot.utils")
          -- local chat_handler = config.chat_handler
          -- -- chat_handler.Append(nil, { "Add a comment" })
          -- -- local cmd_prefix = require("parrot.utils").template_render_from_list(
          -- --   config.options.command_prompt_prefix_template,
          -- --   { ["{{llm}}"] = chat_handler:get_model("command").name }
          -- -- )
          -- local buf = vim.api.nvim_get_current_buf()
          -- local win = vim.api.nvim_get_current_win()
          -- local target = ui.Target.append
          -- local template = chat_handler.options.template_append
          -- local pft = require("plenary.filetype")
          -- local filetype = pft.detect(vim.api.nvim_buf_get_name(buf), {})
          -- local filename = vim.api.nvim_buf_get_name(buf)
          -- local user_prompt = "Add comments to the code"
          -- local filecontent = table.concat(user_prompt, "\n")
          -- local multifilecontent = utils.get_all_buffer_content()
          -- local user_prompt =
          --   utils.template_render(template, command, selection, filetype, filename, filecontent, multifilecontent)
          -- chat_handler:prompt({}, target, chat_handler:get_model("command"), nil, utils.trim(template), true)

          local template = [[
          Add comments to the following code:
          ```{{filetype}}
          {{selection}}
          ```

          Respond just with the snippet of code that should be inserted.
          ]]
          local prt = require("parrot.config")
          local model_obj = prt.get_model("command")
          local selection = get_selection()
          local params = { range = 2, line1 = selection.start_line, line2 = selection.end_line }
          prt.Prompt(params, prt.ui.Target.rewrite, model_obj, nil, template)
        end,
        desc = "Generate RSpec tests",
        mode = "v",
      },
    },
    config = function()
      require("parrot").setup({
        -- Providers must be explicitly added to make them available.
        providers = {
          anthropic = {
            api_key = os.getenv("ANTHROPIC_API_KEY"),
          },
          gemini = {
            api_key = os.getenv("GEMINI_API_KEY"),
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
          -- provide an empty list to make provider available (no API key required)
          ollama = {},
          openai = {
            api_key = os.getenv("OPENAI_API_KEY"),
          },
        },
      })
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
        { "<leader>aP", group = "Parrot", icon = "󱜚 " },
      },
    },
  },
}
