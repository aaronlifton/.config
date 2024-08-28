local prefix = "<leader>aP"

return {
  {
    "frankroeder/parrot.nvim",
    dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
    cmd = { "PrtChatNew" },
    opts = {},
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
