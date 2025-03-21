return {
  {
    "huggingface/hfcc.nvim",
    event = "InsertEnter",
    enabled = false,
    opts = {
      -- api_token is set via huggingface-cli
      -- tokens_to_clear = { "<|endoftext|>" },
      -- model = "bigcode/starcoder",
      model = "bigcode/starcoder2-15b", -- the model ID, behavior depends on backend
      backend = "huggingface", -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
      -- url = nil, -- the http url of the backend
      -- tokens_to_clear = { "<|endoftext|>" }, -- tokens to remove from the model's output
      -- -- parameters that are added to the request body, values are arbitrary, you can set any field:value pair here it will be passed as is to the backend
      -- request_body = {
      --   parameters = {
      --     max_new_tokens = 60,
      --     temperature = 0.2,
      --     top_p = 0.95,
      --   },
      -- },
      -- -- set this if the model supports fill in the middle
      -- fim = {
      --   enabled = true,
      --   prefix = "<fim_prefix>",
      --   middle = "<fim_middle>",
      --   suffix = "<fim_suffix>",
      -- },
      -- debounce_ms = 150,
      accept_keymap = "<S-D-CR>",
      dismiss_keymap = "<C-CR>",
      -- accept_keymap = "<Tab>",
      -- dismiss_keymap = "<S-Tab>",
      -- tls_skip_verify_insecure = false,
      -- -- llm-ls configuration, cf llm-ls section
      -- lsp = {
      --   bin_path = nil,
      --   host = nil,
      --   port = nil,
      --   version = "0.5.3",
      -- },
      -- tokenizer = nil, -- cf Tokenizer paragraph
      -- -- tokenizer = {
      -- --   repository = "bigcode/starcoder",
      -- -- }
      -- context_window = 1024, -- max number of tokens for the context window
      context_window = 2048, -- max number of tokens for the context window
      -- -- context_window = 8192,
      enable_suggestions_on_startup = false,
      -- enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
      -- disable_url_path_completion = false, -- cf Backend
    },
    keys = {
      -- { "<leader>ax2", "<cmd>CodeiumToggle<cr>", desc = "Toggle Codeium" },
      { "<leader>ax4", "<cmd>LLMToggleAutoSuggest<cr>", desc = "Toggle HFCC Autosuggest" },
      { "<leader>ax5", "<cmd>LLMSuggestion<cr>", desc = "Request HFCC Suggestion" },
    },
    config = function(_, opts)
      require("llm").setup(opts)
      vim.api.nvim_create_user_command("StarCoder", function()
        require("hfcc.completion").complete()
      end, {})
    end,
  },
  {
    "mthbernardes/codeexplain.nvim",
    cmd = "CodeExplain",
    build = function()
      vim.cmd([[silent UpdateRemotePlugins]])
    end,
  },
  {
    "Bryley/neoai.nvim",
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
      "NeoAIShortcut",
    },
    keys = {
      -- { "<leader>ck", "", desc = "+NeoAI" },
      -- { "<leader>aS", desc = "Summarize Text (NeoAI)" },
      -- { "<leader>aG", desc = "Generate Git Message (NeoAI)" },
      { "<M-=>", "<cmd>NeoAIToggle<cr>", desc = "Toggle NeoAI" },
      {
        "<leader>wfa",
        function()
          local wins = vim.api.nvim_list_wins()
          local neoai_buf = nil
          local current_buf = vim.api.nvim_get_current_buf()
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].ft == "neoai-input" then
              neoai_buf = buf
              if current_buf ~= neoai_buf then
                vim.api.nvim_set_current_win(win)
                return
              else
                vim.api.nvim_command('execute "norm w"')
                vim.api.nvim_command('execute "norm w"')
              end
            end
          end
        end,
        desc = "Focus NeoAI",
      },
    },
    opts = {},
    config = function(_, opts)
      require("neoai").setup(opts)

      vim.filetype.add({
        extension = {
          ["neoai-output"] = "markdown",
        },
      })
      vim.treesitter.language.register("markdown", "neoai-output")
    end,
  },
  {
    "piersolenski/wtf.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    keys = {
      { "<leader>aw", "", desc = "+󰚩 WTF" },
      {
        "<leader>awd",
        function()
          require("wtf").ai()
        end,
        desc = "Search Diagnostic with AI",
      },
      {
        "<leader>aws",
        function()
          require("wtf").search()
        end,
        desc = "Search Diagnostic with Google",
      },
    },
  },
  -- {
  --   "james1236/backseat.nvim",
  --   cmd = { "Backseat", "BackseatAsk", "BackseatClear", "BackseatClearLine" },
  --   config = true,
  -- },
}
