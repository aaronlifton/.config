-- https://github.com/default-anton/llm-sidekick.nvim/tree/main?tab=readme-ov-file
return {
  "default-anton/llm-sidekick.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("llm-sidekick").setup({
      -- Model aliases configuration
      aliases = {
        pro = "gemini-2.5-pro-exp",
        flash = "gemini-2.5-flash",
        sonnet = "claude-3-7-sonnet-latest",
        bedrock_sonnet = "anthropic.claude-3-7-sonnet",
        deepseek = "deepseek-chat",
        chatgpt = "gpt-4.1",
        mini = "gpt-4.1-mini",
        high_o3_mini = "o3-mini-high",
        low_o3_mini = "o3-mini-low",
      },
      yolo_mode = {
        file_operations = false, -- Automatically accept file operations
        terminal_commands = false, -- Automatically accept terminal commands
        auto_commit_changes = false, -- Enable auto-commit
      },
      auto_commit_model = "gemini-2.5-flash", -- Use a specific model for commit messages
      safe_terminal_commands = { "mkdir", "touch" }, -- List of terminal commands to automatically accept
      guidelines = "", -- Global guidelines that will be added to every chat
      default = "sonnet",
    })
  end,
}
