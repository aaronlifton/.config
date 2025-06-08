local _vendors = {
  deepseek = {
    __inherited_from = "openai",
    api_key_name = "DEEPSEEK_API_KEY",
    endpoint = "https://api.deepseek.com",
    model = "deepseek-coder",
    -- endpoint = "https://api.deepseek.com/v1",
    -- model = "deepseek-chat",
    -- timeout = 30000, -- Timeout in milliseconds
    -- temperature = 0,
    -- max_tokens = 4096,
  },
}

-- local cwd = vim.fn.getcwd()
-- local normalized_parent = vim.fn.fnamemodify(parent_path, ":p")
-- local normalized_cwd = vim.fn.fnamemodify(cwd, ":p")
-- local is_config_subdirectory = vim.startswith(normalized_cwd, normalized_parent)
-- local use_cwd_as_project_root = false
-- if is_config_subdirectory and LazyVim.root.get() ~= normalized_cwd then use_cwd_as_project_root = true end

return {
  {
    "yetone/avante.nvim",
    -- No need since we lazy load via keys
    -- event = "VeryLazy",
    -- lazy = false,

    -- For developmennt
    -- branch = "feat/better-ruby-parsing",
    -- pin = true,
    -- build = "make BUILD_FROM_SOURCE=true",
    -- dev = true,

    -- For non-development
    version = false, -- set this to "*" if you want to always pull the latest change
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",

    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        -- requires osascript (OSX builtin) and pngpaste (brew install pngpaste)
        "HakonHarnes/img-clip.nvim",
        -- cond = false,
        -- event = "VeryLazy",
        ft = { "AvanteInput" },
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
        -- cmd = { "PasteImage" },
        -- keys = {
        --   { "<M-p>", "<cmd>PasteImage<cr>", desc = "Paste image", ft = { "markdown", "tex" }, mode = { "n", "v" } },
        -- },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = {
          file_types = { "Avante" },
        },
        ft = { "Avante" },
      },
    },
    --- @type avante.Config
    opts = {
      -- Defaults: ~/.local/share/nvim/lazy/avante.nvim/lua/avante/config.lua:189
      provider = "claude",
      -- mode = "agentic", -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
      -- auto_suggestions_provider = "claude",
      -- claude = {
      --   endpoint = "https://api.anthropic.com",
      --   model = "claude-3-7-sonnet-20250219",
      --   timeout = 30000, -- Timeout in milliseconds
      --   temperature = 0,
      --   max_tokens = 20480,
      -- },
      behaviour = {
        -- auto_focus_sidebar = true,
        -- auto_suggestions = false, -- Experimental stage
        -- auto_suggestions_respect_ignore = false,
        -- auto_set_highlight_group = true,
        -- auto_set_keymaps = true,
        -- auto_apply_diff_after_generation = false,
        -- jump_result_buffer_on_finish = false,
        -- support_paste_from_clipboard = false,
        -- minimize_diff = true,
        -- enable_token_counting = true,
        use_cwd_as_project_root = false,
        -- auto_focus_on_diff_view = false,
      },
      -- Default keybindings: ~/.local/share/nvim/lazy/avante.nvim/lua/avante/config.lua:329
      mappings = {
        ask = "<leader>aa", -- <leader>aa
        edit = "<leader>ae", -- <leader>ate
        refresh = "<leader>ar", -- <leader>ar
        chat = "<leader>aC", -- <leader>ac
        files = {
          add_current = "<leader>aA",
        },
        toggle = {
          -- default = "<leader>at",
          debug = "<leader>axd",
          hint = "<leader>axh",
          suggestion = "<leader>axs",
          -- TODO: move to <leader>auR (AI Util category)
          -- repomap = "<leader>aR",
        },
        sidebar = {
          -- retry_user_request = "r",
          -- edit_user_request = "e",
          close_from_input = { normal = "Q", insert = "<C-d>" },
        },
      },
      hints = {
        enabled = false,
      },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        input = {
          height = 12, -- Height of the input window in vertical layout
        },
      },
      repo_map = {
        -- stylua: ignore start
        ignore_patterns = {
          -- Default
          "%.git", "%.worktree", "__pycache__", "node_modules",
          -- Rails
          "Gemfile", "Gemfile%.lock", "config", "db", "git_hooks", "k8s", "log", "public", "script", "spec", "bin", "vendor", "swagger", "test", "tmp", "%.ruby%-lsp"
        },
        -- stylua: ignore end
      },
      file_selector = {
        provider = "fzf",
      },
      --- @class AvanteConflictUserConfig
      disabled_tools = { "run_python", "git_commit" }, -- Claude 3.7 overuses the python tool
      custom_tools = function()
        local mcphub_tool = {}
        local ok, mcphub_ext = pcall(require, "mcphub.extensions.avante")
        if ok then mcphub_tool = mcphub_ext.mcp_tool() end

        return {
          {
            name = "run_go_tests", -- Unique name for the tool
            description = "Run Go unit tests and return results", -- Description shown to AI
            param = { -- Input parameters (optional)
              type = "table",
              fields = {
                {
                  name = "target",
                  description = "Package or directory to test (e.g. './pkg/...' or './internal/pkg')",
                  type = "string",
                  optional = true,
                },
              },
              {
                name = "tag_name",
                description = "Optional build tag to use when running tests (e.g. 'unit')",
                type = "string",
                optional = true,
              },
            },
            returns = { -- Expected return values
              {
                name = "result",
                description = "Result of the fetch",
                type = "string",
              },
              {
                name = "error",
                description = "Error message if the fetch was not successful",
                type = "string",
                optional = true,
              },
            },
            func = function(params, on_log, on_complete) -- Custom function to execute
              local target = params.target or "./..."
              local cmd = "go test -v"
              if params.tag_name then cmd = cmd .. " -tags=" .. params.tag_name end
              return vim.fn.system(string.format("%s %s", cmd, target))
            end,
          },
          {
            name = "find_go_package_path",
            description = "Finds the filesystem path containing the 'package' definition for each provided Go import path.",
            param = {
              type = "table",
              fields = {
                {
                  name = "import_lines",
                  description = "A comma-separated string of Go import paths (e.g., 'fmt, os, example.com/mymodule/mypackage').",
                  type = "string",
                },
              },
            },
            returns = {
              {
                name = "result",
                description = "A newline-separated string where each line is 'import_path: file_path' or 'import_path: Not Found'.",
                type = "string",
              },
            },
            func = function(params, on_log, on_complete)
              local import_lines_str = params and params.import_lines
              if not import_lines_str or import_lines_str:gsub("%s", "") == "" then
                return "No import lines provided."
              end

              local import_paths = vim.split(import_lines_str, ",", { trimempty = true })
              local results = {}

              for _, import_path in ipairs(import_paths) do
                local trimmed_path = import_path:match("^%s*(.-)%s*$") -- Trim whitespace
                if trimmed_path == "" then
                  goto continue -- Skip empty paths after trimming
                end

                -- Extract package name (last component after '/')
                local package_name = trimmed_path:match("[^/]+$")
                if not package_name then
                  -- If no '/' is found, the whole path is the package name (e.g., "fmt")
                  package_name = trimmed_path
                end

                -- Construct rg command to find files with "package <package_name>" at the start of a line
                -- Using -- to separate command options from the pattern
                local search_pattern = string.format("^package\\s+%s$", package_name:gsub("'", "''")) -- Escape single quotes for the pattern string
                local cmd = string.format([[rg --files-with-matches -- '%s']], search_pattern)

                -- Execute rg command
                local rg_output = vim.fn.system(cmd)

                -- Process rg output: get the first non-empty line as the file path
                local files = vim.split(rg_output, "\n", { trimempty = true })
                local found_file = "Not Found"
                for _, file_line in ipairs(files) do
                  -- Take the first non-empty line that doesn't seem like a status indicator (like '.')
                  if file_line ~= "" and file_line ~= "." then
                    found_file = file_line
                    break
                  end
                end

                table.insert(results, trimmed_path .. ": " .. found_file)

                ::continue::
              end

              if #results == 0 and import_lines_str:gsub("%s", "") ~= "" then
                return "Could not process any valid import paths."
              elseif #results == 0 then
                return "No import lines provided." -- Should be caught by the initial check, but good fallback
              end

              return table.concat(results, "\n")
            end,
          },
          {
            name = "run_rspec_tests", -- Unique name for the tool
            description = "Run RSpec unit tests and return results", -- Description shown to AI
            param = { -- Input parameters (optional)
              type = "table",
              fields = {
                {
                  name = "paths",
                  description = "comma-seperated file paths, or file regex patterns to test. ",
                  type = "string",
                },
              },
            },
            returns = { -- Expected return values
              {
                name = "result",
                description = "Result of the test run",
                type = "string",
              },
              {
                name = "error",
                description = "Error message if the test run was not successful",
                type = "string",
                optional = true,
              },
            },
            func = function(params, on_log, on_complete) -- Custom function to execute
              local paths = params.paths
              local command = string.format("bundle exec rspec --format json %s", paths)
              on_log("Running command: " .. command)
              local rspec_output = vim.fn.system(command)
              local markdown_output = "```json\n" .. rspec_output .. "\n```"
              return markdown_output
            end,
          },
          mcphub_tool,
        }
      end,
      completion = {
        cmp = {
          input_container = {
            sources = {
              {
                name = "buffer",
                option = {
                  -- get_bufnrs = require("util.win").editor_bufs,
                  get_bufnrs = function()
                    local windows = vim.api.nvim_tabpage_list_wins(0)
                    return vim
                      .iter(windows)
                      :map(function(win)
                        return vim.api.nvim_win_get_buf(win)
                      end)
                      :filter(function(buf)
                        return vim.bo[buf].buflisted
                      end)
                      :totable()
                  end,
                },
              },
            },
          },
        },
      },
    },
    keys = function(_, keys)
      ---@type avante.Config
      local opts =
        require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["avante.nvim"], "opts", false)

      -- stylua: ignore start
      local mappings = {
        { "<M-->", function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
        { opts.mappings.ask, function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
        { opts.mappings.refresh, function() require("avante.api").refresh() end, desc = "avante: refresh", mode = "v" },
        { opts.mappings.edit, function() require("avante.api").edit() end, desc = "avante: edit", mode = { "n", "v" } },
        { opts.mappings.chat, "<Plug>(AvanteChat)", desc = "avante: chat", mode = { "n" } },
        { opts.mappings.toggle.suggestion, function() require("avante").toggle.suggestion() end, desc = "avante: suggest", mode = { "n" } },
        { opts.mappings.toggle.hint, function() require("avante").toggle.hint() end, desc = "avante: hint", mode = { "n" } },
        { opts.mappings.toggle.debug, function() require("avante").toggle.debug() end, desc = "avante: debug", mode = { "n" } },
      }
      -- stylua: ignore end

      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "saghen/blink.compat",
    },
    opts = {
      sources = {
        compat = {
          "avante_commands",
          "avante_mentions",
          "avante_files",
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>at", group = "+Avante", icon = "󱜚 ", mode = "v" },
      },
    },
  },
  -- {
  --   "folke/edgy.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.right = opts.right or {}
  --     table.insert(opts.right, {
  --       ft = "Avante",
  --       title = "Avante",
  --       size = { width = 70, height = 80 },
  --     })
  --     table.insert(opts.right, {
  --       ft = "AvanteSelectedFiles",
  --       title = "Avante",
  --       size = { width = 70, height = 30 },
  --     })
  --     table.insert(opts.right, {
  --       ft = "AvanteInput",
  --       title = "Avante",
  --       size = { width = 70, height = 40 },
  --     })
  --   end,
  -- },
}
