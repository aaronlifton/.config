local actions_config_path = vim.fn.stdpath("config") .. "/lua/config/gpt/actions"

return {
  {
    "jackMort/ChatGPT.nvim",
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
      api_key_cmd = 'op item get "Neovim ChatGPT" --fields credential',
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
        model = "gpt-3.5-turbo-16k",
        -- model = "gpt-4",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 300,
        temperature = 0.3,
        top_p = 0.3,
        n = 1,
        -- temperature = 0,
        -- top_p = 1,
      },
      openai_edit_params = {
        model = "gpt-3.5-turbo-16k",
        -- model = "gpt-4",
        frequency_penalty = 0,
        presence_penalty = 0,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
      show_quickfixes_cmd = "Trouble quickfix",
      -- actions_paths = { "~/.config/nvim/custom_actions.json" },
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
      { "<leader>Cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
      { "<leader>Ce", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction", mode = { "n", "v" } },
      { "<leader>Cg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = { "n", "v" } },
      { "<leader>Ct", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = { "n", "v" } },
      { "<leader>Ck", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords", mode = { "n", "v" } },
      { "<leader>Cd", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring", mode = { "n", "v" } },
      { "<leader>CT", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests", mode = { "n", "v" } },
      { "<leader>Co", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
      { "<leader>Cs", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize", mode = { "n", "v" } },
      { "<leader>Cf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
      { "<leader>Cx", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>Cr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit", mode = { "n", "v" } },
      { "<leader>Cl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis", mode = { "n", "v" },  },
      {
        '<leader>rE',
        '<cmd>Chat explain_code_4<cr>',
        desc = 'Explain code',
        mode = { 'v' },
      },
      {
        '<leader>rd',
        '<cmd>Chat rails_add_rdoc<cr>',
        desc = 'Write documentation (RDoc)',
        mode = { 'v' },
      },
      {
        '<leader>rt',
        '<cmd>Chat rails_add_rspec_tests<cr>',
        desc = 'Write unit tests (RSpec)',
        mode = { 'v' },
      },
      {
        '<leader>re',
        '<cmd>Chat rails_edit_code<cr>',
        desc = 'Refactor code (Rails)',
        mode = { 'v' },
      },
      {
        '<leader>re',
        '<cmd>Chat rails_edit_code2<cr>',
        desc = 'Refactor code2 (Rails)',
        mode = { 'v' },
      },
      {
        '<leader>rc',
        '<cmd>Chat rails_complete_code<cr>',
        desc = 'Complete code (Rails)',
        mode = { 'v' },
      }
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>C"] = { name = "󰚩 chatGPT" },
        ["<leader>r"] = { name = "󰚩 RailsGPT", mode = "v" },
      },
    },
  },
}
