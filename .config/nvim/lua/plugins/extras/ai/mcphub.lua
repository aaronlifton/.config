-- package.loaded['mcphub']
return {
  {
    "ravitemer/mcphub.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "MCPHub",
    -- build = "npm install -g mcp-hub@latest",
    build = "bundled_build.lua",
    keys = {
      {
        "<leader>am",
        "<cmd>MCPHub<CR>",
        mode = { "n" },
        desc = "Open MCPHub",
      },
    },
    config = function()
      require("mcphub").setup({
        use_bundled_binary = true,
        port = 37373,
        -- config = vim.fn.stdpath("config") .. "/mcpservers.json",
        config = vim.fn.expand("~/.config/mcphub/servers.json"),
        -- Optional options
        on_ready = function(_)
          -- Called when hub is ready
        end,
        on_error = function(err)
          -- Called on errors
          -- vim.notify(err, vim.log.levels.ERROR)
        end,
        shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
        auto_approve = true, -- Auto approve mcp tool calls
        auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
        native_servers = {
          -- Definition-based servers (mcphub.nvim/doc/mcp/native/registration.md)
          system_info = {
            name = "system_info",
            displayName = "System Info",
            capabilities = {
              resources = {
                {
                  name = "cwd",
                  description = "Current working directory",
                  uri = "system://cwd",
                  handler = function(req, res)
                    if req.uri ~= "system://cwd" then res:error("Invalid URI: " .. req.uri) end

                    local cwd = vim.fn.getcwd()
                    return res:text(cwd)
                  end,
                },
              },
            },
          },
        },
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
        },
        global_env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = os.getenv("GITHUB_PERSONAL_ACCESS_TOKEN"),
        },
      })

      -- Load API-based MCP servers (mcphub.nvim/doc/mcp/native/registration.md)
      pcall(require, "custom.mcp_servers.nvim_helper")
      pcall(require, "custom.mcp_servers.git_helper")
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
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      -- disabled_tools = {
      --   "list_files",
      --   "search_files",
      --   "read_file",
      --   "create_file",
      --   "rename_file",
      --   "delete_file",
      --   "create_dir",
      --   "rename_dir",
      --   "delete_dir",
      --   "bash",
      --   -- Already disabled
      --   "run_python",
      --   "git_commit",
      -- },
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
