return {
  "dlants/magenta.nvim",
  lazy = false, -- you could also bind to <leader>mt
  build = "npm install --frozen-lockfile",
  opts = {},
  config = function(_, opts)
    require("magenta").setup({
      profiles = {
        {
          name = "claude-4",
          provider = "anthropic",
          model = "claude-4-sonnet-latest",
          fastModel = "claude-3-5-haiku-latest", -- optional, defaults provided
          apiKeyEnvVar = "ANTHROPIC_API_KEY",
          thinking = {
            enabled = true,
            budgetTokens = 1024, -- optional, defaults to 1024, must be >= 1024
          },
        },
        {
          name = "o4-mini",
          provider = "openai",
          model = "o4-mini",
          apiKeyEnvVar = "OPENAI_API_KEY",
          reasoning = {
            effort = "low", -- optional: "low", "medium", "high"
            summary = "auto", -- optional: "auto", "concise", "detailed"
          },
        },
        {
          name = "copilot-claude",
          provider = "copilot",
          model = "claude-3.7-sonnet",
          fastModel = "claude-3-5-haiku-latest", -- optional, defaults provided
          -- No apiKeyEnvVar needed - uses existing Copilot authentication
        },
      },
      -- open chat sidebar on left or right side
      sidebarPosition = "left",
      -- can be changed to "telescope" or "snacks"
      picker = "fzf-lua",
      -- enable default keymaps shown below
      defaultKeymaps = true,
      -- maximum number of sub-agents that can run concurrently (default: 3)
      maxConcurrentSubagents = 3,
      -- glob patterns for files that should be auto-approved for getFile tool
      -- (bypasses user approval for hidden/gitignored files matching these patterns)
      getFileAutoAllowGlobs = { "node_modules/*" }, -- default includes node_modules
      -- keymaps for the sidebar input buffer
      sidebarKeymaps = {
        normal = {
          ["<CR>"] = ":Magenta send<CR>",
        },
      },
      -- keymaps for the inline edit input buffer
      -- if keymap is set to function, it accepts a target_bufnr param
      inlineKeymaps = {
        normal = {
          ["<CR>"] = function(target_bufnr)
            vim.cmd("Magenta submit-inline-edit " .. target_bufnr)
          end,
        },
      },
      -- configure edit prediction options
      editPrediction = {
        -- Use a dedicated profile for predictions (optional)
        -- If not specified, uses the current active profile's model
        profile = {
          provider = "anthropic",
          model = "claude-3-5-haiku-latest",
          apiKeyEnvVar = "ANTHROPIC_API_KEY",
        },
        -- Maximum number of changes to track for context (default: 10)
        changeTrackerMaxChanges = 20,
        -- Token budget for including recent changes (default: 1000)
        recentChangeTokenBudget = 1500,
        -- Customize the system prompt (optional)
        -- systemPrompt = "Your custom prediction system prompt here...",
        -- Add instructions to the default system prompt (optional)
        systemPromptAppend = "Focus on completing function calls and variable declarations.",
      },
      -- configure MCP servers for external tool integrations
      mcpServers = {
        fetch = {
          command = "uvx",
          args = { "mcp-server-fetch" },
        },
        playwright = {
          command = "npx",
          args = {
            "@playwright/mcp@latest",
          },
        },
        -- HTTP-based MCP server example
        httpServer = {
          url = "http://localhost:8000/mcp",
          requestInit = {
            headers = {
              Authorization = "Bearer your-token-here",
            },
          },
        },
      },
    })
  end,
}
