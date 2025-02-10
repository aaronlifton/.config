local prefix = "<leader>A"
local generate_prefix = "<leader>ag"
local analyze_prefix = "<leader>an"
local modify_prefix = "<leader>am"
local user = vim.env.USER or "User"
-- local adapter = "anthropic"
-- local adapter = "openai"
-- local adapter = "gemini"
local adapter = "deepseek_r1"

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionChatAdapter",
  callback = function(args)
    if args.data.adapter == nil or vim.tbl_isempty(args.data) then return end
    vim.g.llm_name = args.data.adapter.name
  end,
})

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    dependencies = {
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = {
          file_types = { "codecompanion" },
        },
        ft = { "codecompanion" },
      },
      {
        "echasnovski/mini.diff",
        optional = true,
      },
      -- {
      --   "saghen/blink.cmp",
      --   optional = true,
      --   opts = function(_, opts)
      --     if LazyVim.is_loaded("codecompanion.nvim") then vim.list_extend(opts.sources.default, { "codecompanion" }) end
      --   end,
      -- },
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])

      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionInline*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionInlineFinished" then
            -- Format the buffer after the inline request has completed
            require("conform").format({ bufnr = request.buf })
          end
        end,
      })
    end,
    opts = {
      adapters = {
        deepseek_coder = function()
          -- ollama
          return require("codecompanion.adapters").extend("deepseek", {
            name = "deepseek_coder",
            schema = {
              model = {
                default = "deepseek-coder-v2:latest",
              },
            },
          })
        end,
        deepseek_r1 = function()
          return require("codecompanion.adapters").extend("deepseek", {
            name = "deepseek_r1",
            schema = {
              model = {
                default = "deepseek-r1:14b",
              },
            },
          })
        end,
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              max_tokens = {
                default = 8192,
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          -- adapter = "deepseek_r1",
          adapter = adapter,
          roles = {
            llm = "  CodeCompanion",
            user = " " .. user:sub(1, 1):upper() .. user:sub(2),
          },
          keymaps = {
            close = { modes = { n = "q", i = "<C-c>" } },
            stop = { modes = { n = "<C-c>" } },
          },
        },
        inline = { adapter = adapter },
        agent = { adapter = adapter },
      },
      display = {
        chat = {
          show_settings = true,
          render_headers = false,
        },
        diff = {
          provider = "mini_diff",
        },
      },
      -- prompt_library = require("plugins.extras.ai.config.codecompanion.prompt_library"),
      prompt_library = {
        ["Code Expert"] = {
          strategy = "chat",
          description = "Get some special advice from an LLM",
          opts = {
            mapping = "<LocalLeader>ce",
            modes = { "v" },
            short_name = "expert",
            auto_submit = true,
            stop_context_insertion = true,
            user_prompt = true,
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return "I want you to act as a senior "
                  .. context.filetype
                  .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
              end,
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Conventional Commit"] = {
          strategy = "inline",
          description = "Generate a conventional commit from staged files",
          opts = {
            placement = "replace",
            auto_submit = true,
            short_name = "conventional-commit",
          },
          prompts = {
            {
              role = "system",
              content = "You are an expert at following the Conventional Commit specification.",
            },
            {
              role = "user",
              content = function(context)
                local cwd = vim.fn.expand("%:h:h")
                local git_diff = require("util.git").get_git_diff({ "git", "-C", cwd, "diff", "--staged", "-U0" })

                return "Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done. Try to stay below 80 characters total. Don't specify the commit subcategory (`fix(deps):`), just the category (`fix:`). Staged git diff: ```\n"
                  .. git_diff
                  .. '\n```. After an additional newline, add a short description in 1 to 4 sentences of WHY the changes are done after the commit message. Don\'t start it with "This commit", just describe the changes. Use the present tense. Lines must not be longer than 74 characters.\n\n'
              end,
              opts = {
                contains_code = true,
              },
            },
          },
          -- keymaps = {
          --   send = {
          --     modes = {
          --       n = { "<CR>", "<C-s>" },
          --       i = "<C-s>",
          --     },
          --     index = 1,
          --     callback = "keymaps.send",
          --     description = "Send",
          --   },
          -- },
        },
        ["Code Explain"] = {
          strategy = "chat",
          description = "Get an explanation of code",
          opts = {
            is_slash_cmd = false,
            modes = { "v" },
            short_name = "code-explain",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = [[When asked to explain code, follow these steps:

1. Identify the programming language and/or framework.
2. Describe the purpose of the code and if appropriate, reference concepts from the programming language, framework, or APIs used (such as the neovim lua API).
3. When answering, take into account the context/files provided. The selected code may use methods from these other files or libraries.
3. Simply explain what the code does.]],
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                -- local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                local code = require("util.ai.markdown").markdown_code_fence(context)

                return string.format(
                  [[Please explain this code from buffer %d:
%s]],
                  context.bufnr,
                  code
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    },
    keys = {
      -- stylua: ignore start
      { prefix .. "a", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action Palette" },
      { prefix .. "c", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New Chat" },
      { prefix .. "A", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add Code" },
      { prefix .. "i", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline Prompt" },
      { prefix .. "C", "<cmd>CodeCompanion Toggle<cr>", mode = "n", desc = "Toggle Chat" },
      { generate_prefix .. "C", "<cmd>CodeCompanion conventional-commit<cr>", mode = "n", desc = "Conventional Commit" },
      { analyze_prefix .. "e", function() require("codecompanion").prompt("explain") end, mode = "v", desc = "Explain code"},
      { analyze_prefix .. "E", function() require("codecompanion").prompt("code-explain") end, mode = "v", desc = "Explain code 2"},
      { analyze_prefix .. "d", function() require("codecompanion").prompt("lsp") end, mode = { "n", "v" }, desc = "Diagnostics"},
      -- stylua: ignore end
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "CodeCompanion", icon = "󱚦 ", mode = { "n", "v" } },
        { generate_prefix, group = "+generate" },
        { analyze_prefix, group = "+analyze", mode = "n" },
        { analyze_prefix, group = "+analyze", mode = "v" },
        { modify_prefix, group = "+modify", mode = "v" },
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "codecompanion",
        title = "CodeCompanion",
        size = { width = 70 },
      })
    end,
  },
}
