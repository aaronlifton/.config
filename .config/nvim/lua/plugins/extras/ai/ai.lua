local ui_util = require("util.ui")
return {
  {
    "tzachar/cmp-ai",
    enabled = false,
    dependencies = "nvim-lua/plenary.nvim",
    config = function(_, opts)
      local cmp_ai = require("cmp_ai.config")

      -- CODESTRAL_API_KEY=Q5G7tjYkGKdCXnHX7oohUwOIB4vom863
      -- https://github.com/tzachar/cmp-ai
      -- https://codestral.mistral.ai/v1/fim/completions
      -- https://codestral.mistral.ai/v1/chat/completions
      cmp_ai:setup({
        max_lines = 1000,
        provider = "Codestral",
        -- provider_options = {
        --   model = "codestral-latest",
        -- },
        notify = true,
        notify_callback = function(msg)
          vim.notify(msg)
        end,
        run_on_every_keystroke = true,
        ignored_file_types = {
          -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        },
      })
    end,
  },

  {
    "huggingface/hfcc.nvim",
    event = "InsertEnter",
    enabled = true,
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
      -- { "<leader>cI2", "<cmd>CodeiumToggle<cr>", desc = "Toggle Codeium" },
      { "<leader>cI4", "<cmd>LLMToggleAutoSuggest<cr>", desc = "Toggle HFCC Autosuggest" },
      { "<leader>cI5", "<cmd>LLMSuggestion<cr>", desc = "Request HFCC Suggestion" },
    },
    config = function(_, opts)
      require("llm").setup(opts)
      vim.api.nvim_create_user_command("StarCoder", function()
        require("hfcc.completion").complete()
      end, {})
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>cI4"] = { name = "Toggle HFCC Autosuggest" },
        ["<leader>cI5"] = { name = "Request HFCC Suggestion" },
      },
    },
  },
  {
    "mthbernardes/codeexplain.nvim",
    enabled = true,
    cmd = "CodeExplain",
    build = function()
      vim.cmd([[silent UpdateRemotePlugins]])
    end,
  },
  {
    "Bryley/neoai.nvim",
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
          -- require("neoai").open()
          local wins = vim.api.nvim_list_wins()
          local neoai_win = nil
          local neoai_buf = nil

          local bufs = vim.api.nvim_list_bufs()
          for _, buf in ipairs(bufs) do
            if vim.bo[buf].ft == "neoai-input" then
              ui_util.goto_leftmost_win()
              return
            end
          end

          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)

            if vim.bo[buf].ft == "neoai-input" then
              neoai_win = win
              neoai_buf = buf
              break
            end
          end
          vim.api.nvim_echo({ { "NeoAI: " .. vim.fn["neoai#GetStatusString"]() } }, true, {})

          if neoai_win and neoai_buf then
            -- move focus to the buffer
            vim.api.nvim_set_current_win(neoai_win)
          else
            require("neoai").open()
          end
        end,
        desc = "Focus NeoAI",
      },
    },
    opts = {},
    config = function(_, opts)
      require("neoai").setup(vim.tbl_extend("force", opts, {}))
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
