return {
  {
    "dpayne/CodeGPT.nvim",
    cmd = "Chat",
    build = "pip install tiktoken",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>CCae",
        "<cmd>Chat explain<cr>",
        desc = "Explain code",
        mode = { "v" },
      },
      {
        "<leader>CCf",
        "<cmd>Chat debug<cr>",
        desc = "Find problems in code",
        mode = { "v" },
      },
      {
        "<leader>CCd",
        "<cmd>Chat doc<cr>",
        desc = "Write documentation",
        mode = { "v" },
      },
      {
        "<leader>CCt",
        "<cmd>Chat tests<cr>",
        desc = "Write unit tests",
        mode = { "v" },
      },
      {
        "<leader>CCr",
        "<cmd>Chat code_edit<cr>",
        desc = "Code edit",
        mode = { "v" },
      },
    },
    config = function()
      require("codegpt.config")
      local ror_prompt =
        "You are a Ruby on Rails programmer who writes clean, organized, DRY code in idiomatic Ruby. You are writing code for a project using the latest version of Rails."
      vim.g["codegpt_openai_api_key"] = os.getenv("OPENAI_API_KEY")
      vim.g["codegpt_popup_type"] = "vertical"
      vim.g["codegpt_vertical_popup_size"] = "40%"
      vim.g["codegpt_clear_visual_selection"] = true

      vim.g["codegpt_ui_commands"] = {
        -- some default commands, you can remap the keys
        quit = "q", -- key to quit the popup
        use_as_output = "<c-o>", -- key to use the popup content as output and replace the original lines
        use_as_input = "<c-i>", -- key to use the popup content as input for a new API request
      }

      vim.cmd("echo 'CodeGPT.nvim loaded'")
      vim.g["codegpt_commands"] = {
        ["tests"] = {
          language_instructions = {
            ruby = ror_prompt .. " Use the RSpec framework.",
            -- typescript = "Use Jest framework.",
            -- javascript = "Use Jest framework.",
            typescript = "Use the Vitest framework.",
            javascript = "Use the Vitest framework.",
          },
        },
        ["doc"] = {
          language_instructions = {
            ruby = "Use RDoc format.",
            typescript = "Use JSDoc format.",
            javascript = "Use JSDoc format.",
          },
          -- Overrides the max tokens to be 1024
          max_tokens = 1024,
        },
        ["code_edit"] = {
          -- Overrides the system message template
          language_instructions = {
            ruby = ror_prompt,
            typescript = "Use the latest version of Typescript and React. Avoid the use of global state, and the any type.",
            javascript = "Use the latest features of Javascript and the latest version of React. Avoid the use of global state, and the any type.",
          },

          -- Overrides the user message template
          user_message_template = "{{language_instructions}}\nI have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nEdit the above code. {{command_args}}",
          callback_type = "code_popup",
        },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    after = "CodeGPT.nvim",
    opts = function(_, opts)
      local codegpt = require("codegpt")
      table.insert(opts.sections.lualine_x, 2, {
        codegpt.get_status,
        "encoding",
        "fileformat",
        on_click = function(num_clicks, mouse_button, mods)
          local data = { num_clicks = num_clicks, mouse_button = mouse_button, mods = mods }
          vim.api.nvim_echo({ { "mods: " .. vim.inspect(data) } }, true, {})

          if num_clicks == 1 and mouse_button == 1 and #mods == 0 then
            vim.api.nvim_echo({ { "CodeGPT: " .. codegpt.get_status() } }, true, {})
          end
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>CC"] = { name = "CodeGPT" },
      },
    },
  },
}
