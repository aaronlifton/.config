return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        port = 3000,
        config = vim.fn.stdpath("config") .. "/mcpservers.json",
      })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    opts = function(_, opts)
      opts.tools = opts.tools or {}
      opts.tools["mcp"] = {
        callback = require("mcphub.extensions.codecompanion"),
        description = "Call tools and resources from the MCP Servers",
        opts = {
          user_approval = true,
        },
      }
    end,
  },
}
