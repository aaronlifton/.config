local actions_config_path = vim.fn.stdpath("config") .. "/lua/config/gpt/actions"
local gen_prefix = "<leader>ag"
local mod_prefix = "<leader>am"
local analyze_prefix = "<leader>an"

return {
  { "nvim-telescope/telescope.nvim", enabled = true },
  {
    "jackMort/ChatGPT.nvim",
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cond = function()
      local api_key = os.getenv("OPENAI_API_KEY")
      return api_key and api_key ~= "" and true or false
    end,
    opts = {
      actions_paths = {
        actions_config_path .. "/general.json",
        actions_config_path .. "/rails.json",
      },
      -- api_key_cmd = 'op item get "Neovim ChatGPT" --fields credential',
      -- edit_with_instructions = {
      --   diff = false,
      --   keymaps = {
      --     close = "<C-c>",
      --     accept = "<C-y>",
      --     toggle_diff = "<C-d>",
      --     toggle_settings = "<C-o>",
      --     cycle_windows = "<Tab>",
      --     use_output_as_input = "<C-i>",
      --   },
      -- },
      -- chat = {
      --   welcome_message = "",
      --   keymaps = {
      --     close = { "<C-c>" },
      --     yank_last = "<C-y>",
      --     yank_last_code = "<C-k>",
      --     scroll_up = "<C-u>",
      --     scroll_down = "<C-d>",
      --     new_session = "<C-n>",
      --     cycle_windows = "<Tab>",
      --     cycle_modes = "<C-f>",
      --     next_message = "<C-j>",
      --     prev_message = "<C-k>",
      -- --  select_session = "<Space>",
      --     select_session = { "<Space>", "o", "<cr>" },
      --     rename_session = "r",
      --     delete_session = "d",
      -- --  draft_message = "<C-r>",
      --     draft_message = "<C-d>",
      --     edit_message = "e",
      --     delete_message = "d",
      --     toggle_settings = "<C-o>",
      --     toggle_sessions = "<C-p>",
      --     toggle_help = "<C-h>",
      --     toggle_message_role = "<C-r>",
      --     toggle_system_role_open = "<C-s>",
      --     stop_generating = "<C-x>",
      --   },
      -- },
      openai_params = {
        -- model = "gpt-3.5-turbo-16k",
        model = "gpt-4o",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 1024,
        temperature = 0.3,
        top_p = 0.3,
        n = 1,
        -- temperature = 0,
        -- top_p = 1,
        -- From docs
        -- model = "gpt-4-1106-preview",
        -- frequency_penalty = 0,
        -- presence_penalty = 0,
        -- max_tokens = 4095,
        -- temperature = 0.2,
        -- top_p = 0.1,
        -- n = 1,
      },
      openai_edit_params = {
        -- model = "gpt-3.5-turbo-16k",
        -- model = "gpt-4",
        model = "gpt-4o",
        frequency_penalty = 0,
        presence_penalty = 0,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
      show_quickfixes_cmd = "Trouble quickfix",
      popup_layout = {
        default = "center",
        center = {
          width = "60%",
          height = "80%",
        },
        right = {
          width = "30%",
          width_settings_open = "50%",
        },
      },
    },
    cmd = {
      "ChatGPT",
      "ChatGPTActAs",
      "ChatGPTCompleteCode",
      "ChatGPTEditWithInstructions",
      "ChatGPTRun",
    },
    -- stylua: ignore
    keys = {
      -- { "<leader>chT", "<cmd>ChatGPTRun add_tests<CR>", desc = "Generate Tests", mode = { "n", "v" } },
      -- { "<leader>chc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
      -- { "<leader>chd", "<cmd>ChatGPTRun docstring<CR>", desc = "Generate Docstring", mode = { "n", "v" } },
      -- { "<leader>che", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction", mode = { "n", "v" } },
      -- { "<leader>chf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
      -- { "<leader>chg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = { "n", "v" } },
      -- { "<leader>chk", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords", mode = { "n", "v" } },
      -- { "<leader>cho", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
      -- -- { "<leader>chr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit", mode = { "n", "v" } },
      -- { "<leader>chs", "<cmd>ChatGPTRun summarize<CR>", desc = "Generate summary", mode = { "n", "v" } },
      -- { "<leader>cht", "<cmd>ChatGPTRun GenType<cr>", desc = "Generate type documentation", mode = {"n", "v"} },
      -- -- { "<leader>cht", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = { "n", "v" } },
      -- { "<leader>chx", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
      -- { "<leader>chl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis", mode = { "n", "v" },  },
      -- { "<leader>chra", "<cmd>ChatGPTRun WriteRailsCode<cr>", desc = "Write Rails code", mode = { "n", "v" } },
      -- { "<leader>chrt", "<cmd>ChatGPTRun WriteRSpecTests<cr>", desc = "Write Rails code", mode = {"n", "v"} },
      --
      -- Experimental <leader>a +ai mapping
      -- { "<leader>ac", "", "󰚩 ChatGPT"},
      -- { "<leader>af", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
      -- { "<leader>ax", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
      -- { "<leader>al", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis", mode = { "n", "v" },  },
      -- { prefix .. "", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = { "n", "v" } },
      -- { "<leader>ak", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords", mode = { "n", "v" } },
      -- { "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
      -- { "<leader>ar", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit", mode = { "n", "v" } },
      -- { "<leader>aT", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = { "n", "v" } },
      --
      { "<leader>ac", "<cmd>ChatGPT<CR>", desc = "Toggle Chat (ChatGPT)" },
      { "<leader>ae", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit (ChatGPT)", mode = { "n", "v" } },
      { gen_prefix .. "t", "<cmd>ChatGPTRun add_tests<CR>", desc = "Generate tests (GPT)", mode = { "n", "v" } },
      { gen_prefix .. "d", "<cmd>ChatGPTRun docstring<CR>", desc = "Generate docstring (GPT)", mode = { "n", "v" } },
      { gen_prefix .. "s", "<cmd>ChatGPTRun summarize<CR>", desc = "Generate summary (GPT)", mode = { "n", "v" } },
      { gen_prefix .. "y", "<cmd>ChatGPTRun GenType<cr>", desc = "Generate type documentation (GPT)", mode = {"n", "v"} },
      { gen_prefix .. "ra", "<cmd>ChatGPTRun WriteRailsMethod<cr>", desc = "Generate method", mode = { "n", "v" } },
      { gen_prefix .. "rt", "<cmd>ChatGPTRun WriteRSpecTests<cr>", desc = "Generate RSpec tests", mode = {"n", "v"} },
      -- Modify
      { mod_prefix .. "o", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
      { mod_prefix .. "f", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
      -- Analyze 
      { analyze_prefix .. "k", "<cmd>ChatGPTRun keywords<CR>", desc = "Extract Keywords", mode = { "n", "v" } },
      { analyze_prefix .. "e", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
      { analyze_prefix .. "r", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Analyze Code Readability", mode = { "n", "v" },  },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { gen_prefix .. "", group = "Generate" },
        { gen_prefix .. "r", group = "Rails" },
        { mod_prefix .. "", group = "Modify" },
        { analyze_prefix .. "", group = "Analyze" },
      },
    },
  },
}
