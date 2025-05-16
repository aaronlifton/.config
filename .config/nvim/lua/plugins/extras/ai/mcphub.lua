-- package.loaded['mcphub']
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
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
        },
      })

      -- Load custom MCP servers
      pcall(require, "custom.mcp_servers.nvim_helper")
    end,
  },
  {
    "yetone/avante.nvim",
    optional = true,
    opts = {
      -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        if not hub then
          vim.notify("MCP Hub instance not found", vim.log.levels.WARN, { title = "MCPHub" })
          return
        end
        return hub:get_active_servers_prompt()
      end,
      -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      -- custom_tools = function()
      --   return {
      --     require("mcphub.extensions.avante").mcp_tool(),
      --   }
      -- end,
      disabled_tools = {
        "list_files",
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash",
        -- Already disabled
        "run_python",
        "git_commit",
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    optional = true,
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
