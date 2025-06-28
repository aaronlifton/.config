local prefix = "<leader>aG"
return {
  "azorng/goose.nvim",
  opts = {
    -- Defaults
    prefered_picker = nil, -- 'telescope', 'fzf', 'mini.pick', 'snacks', if nil, it will use the best available picker
    default_global_keymaps = true, -- If false, disables all default global keymaps
    keymap = {
      global = {
        toggle = prefix .. "g", -- Open goose. Close if opened
        open_input = prefix .. "i", -- Opens and focuses on input window on insert mode
        open_input_new_session = prefix .. "I", -- Opens and focuses on input window on insert mode. Creates a new session
        open_output = prefix .. "o", -- Opens and focuses on output window
        toggle_focus = prefix .. "t", -- Toggle focus between goose and last window
        close = prefix .. "q", -- Close UI windows
        toggle_fullscreen = prefix .. "f", -- Toggle between normal and fullscreen mode
        select_session = prefix .. "s", -- Select and load a goose session
        goose_mode_chat = prefix .. "mc", -- Set goose mode to `chat`. (Tool calling disabled. No editor context besides selections)
        goose_mode_auto = prefix .. "ma", -- Set goose mode to `auto`. (Default mode with full agent capabilities)
        configure_provider = prefix .. "p", -- Quick provider and model switch from predefined list
        diff_open = prefix .. "d", -- Opens a diff tab of a modified file since the last goose prompt
        diff_next = prefix .. "]", -- Navigate to next file diff
        diff_prev = prefix .. "[", -- Navigate to previous file diff
        diff_close = prefix .. "c", -- Close diff view tab and return to normal editing
        diff_revert_all = prefix .. "ra", -- Revert all file changes since the last goose prompt
        diff_revert_this = prefix .. "rt", -- Revert current file changes since the last goose prompt
      },
      window = {
        submit = "<cr>", -- Submit prompt (normal mode)
        submit_insert = "<cr>", -- Submit prompt (insert mode)
        close = "<esc>", -- Close UI windows
        stop = "<C-c>", -- Stop goose while it is running
        next_message = "]]", -- Navigate to next message in the conversation
        prev_message = "[[", -- Navigate to previous message in the conversation
        mention_file = "@", -- Pick a file and add to context. See File Mentions section
        toggle_pane = "<tab>", -- Toggle between input and output panes
        prev_prompt_history = "<up>", -- Navigate to previous prompt in history
        next_prompt_history = "<down>", -- Navigate to next prompt in history
      },
    },
    ui = {
      window_width = 0.35, -- Width as percentage of editor width
      input_height = 0.15, -- Input height as percentage of window height
      fullscreen = false, -- Start in fullscreen mode (default: false)
      layout = "right", -- Options: "center" or "right"
      floating_height = 0.8, -- Height as percentage of editor height for "center" layout
      display_model = true, -- Display model name on top winbar
      display_goose_mode = true, -- Display mode on top winbar: auto|chat
    },
    providers = {
      --[[
        Define available providers and their models for quick model switching
        anthropic|azure|bedrock|databricks|google|groq|ollama|openai|openrouter
        Example:
        openrouter = {
          "anthropic/claude-3.5-sonnet",
          "openai/gpt-4.1",
        },
        ollama = {
          "cogito:14b"
        }
        --]]
    },
  },
  config = function()
    require("goose").setup({})
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
      },
    },
  },
}
