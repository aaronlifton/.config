local model = require("model")
local mode = require("model").mode
local openai = require("model.providers.openai")
local gemini = require("model.providers.gemini")
local starter_prompts = require("model.prompts.starters")
local gemini_builder = require("plugins.extras.ai.config.models.gemini.builder")

---@param system_cmd table|nil
---@return string
local get_git_diff = function(system_cmd)
  system_cmd = system_cmd or { "git", "diff", "--staged" }
  local git_diff = vim.fn.system(system_cmd)

  if not git_diff:match("^diff") then
    git_diff = vim.fn.system({ "git", "diff" })

    if not git_diff:match("^diff") then
      error("diff empty:\n" .. git_diff)
    end
  end

  return git_diff
end

---@type table<string, Prompt>
return vim.tbl_extend("force", starter_prompts, {
  NodeJsConvert = {
    provider = openai,
    mode = model.mode.INSERT_OR_REPLACE,
    builder = function(input, context)
      local code = input
      return {
        messages = {
          {
            role = "user",
            -- content = "Your mission is to convert given code to a nodejs-code. Don't describe or hinting the code. Only clean code. Here is the code to convert: ``` "
            content = "Convert the following code to NodeJS code. Only return code and don't describe it. Here is the code to convert: ``` "
              .. code
              .. " ```",
          },
        },
      }
    end,
  },
  ConventialCommit = {
    provider = openai,
    mode = require("model").mode.REPLACE,
    builder = function()
      local cwd = vim.fn.expand("%:h:h")
      local git_diff = get_git_diff({ "git", "-C", cwd, "diff", "--staged", "-U0" })

      return {
        messages = {
          {
            role = "user",
            content = "Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done. Try to stay below 80 characters total. Staged git diff: ```\n"
              .. git_diff
              .. '\n```. After an additional newline, add a short description in 1 to 4 sentences of WHY the changes are done after the commit message. Don\'t start it with "This commit", just describe the changes. Use the present tense. Lines must not be longer than 74 characters.',
          },
        },
      }
    end,
  },
  ask = {
    provider = openai,
    params = {
      temperature = 0.3,
      max_tokens = 1500,
    },
    builder = function(input)
      local messages = {
        {
          role = "user",
          content = input,
        },
      }

      openai.prompt.add_args_as_last_message(messages, {
        args = input,
      })

      return {
        messages = messages,
      }
      -- return openai.builder.user_prompt(function(user_input)
      --   if #user_input > 0 then
      --     table.insert(messages, {
      --       role = "user",
      --       content = user_input,
      --     })
      --   end
      --
      --   return {
      --     messages = messages,
      --   }
      -- end, input)
    end,
  },
  code = {
    provider = openai,
    builder = function(input)
      return {
        messages = {
          {
            role = "system",
            content = "You are a 10x super elite programmer. Continue only with code. Do not write tests, examples, or output of code unless explicitly asked for.",
          },
          {
            role = "user",
            content = input,
          },
        },
      }
    end,
  },
  gemini = {
    provider = gemini,
    builder = function(input)
      return {
        contents = {
          {
            parts = {
              {
                text = input,
              },
            },
          },
        },
      }
    end,
  },
  ["commit:openai"] = {
    provider = openai,
    system = "You are an expert programmer and git user.",
    mode = mode.INSERT,
    params = {
      model = "gpt-4-0125-preview", -- gpt-4o
    },
    builder = function()
      local git_diff = vim.fn.system({ "git", "diff", "--staged" })

      if not git_diff:match("^diff") then
        error("Git error:\n" .. git_diff)
      end

      return {
        messages = {
          {
            role = "user",
            content = "Write a terse commit message according to the Conventional Commits specification. Try to stay below 80 characters total. Dont surround the commit message with backticks. Staged git diff: ```\n"
              .. git_diff
              .. "\n```",
          },
        },
      }
    end,
  },
  ["codestral:fim"] = {
    provider = require("util.model.providers.codestral"),
    mode = mode.INSERT,
    params = {
      model = "codestral-latest",
      temperature = 0.1,
      n = 1,
      max_tokens = 100,
      endpoint = "fim",
    },
    builder = function(input)
      -- /Users/aaron/.local/share/nvim/lazy/cmp-ai/lua/cmp_ai/backends/codestral.lua
      local context = require("util.model.context")
      local ctx = context:get()
      return { prompt = ctx.lines_before }
    end,
  },
  commit2 = {
    provider = gemini,
    mode = mode.INSERT,
    builder = function()
      local git_diff = vim.fn.system({ "git", "diff", "--staged" })

      if not git_diff:match("^diff") then
        error("Git error:\n" .. git_diff)
      end
      return {
        contents = {
          {
            parts = {
              {
                text = "Write a terse commit message according to the conventional commits specification. "
                  .. "When analyzing the diff, ignore any changes made to code inside markdown files. try to stay below 80 characters total. "
                  .. "If a version is bumped, the commit category is 'chore'. "
                  .. "When using a filename as a commit category, take into account the parent folders. For example, ruby/lsp/rubyfmt would be the ruby-lsp-rubyfmt category. "
                  .. "The subcategory should alawys be in parens after the main category, like chore(subcategory). "
                  .. "Focus on changes in the src folder."
                  .. "When encountering svg files, only consider the filename. "
                  .. "For each line in the longer description, start it with a *."
                  .. "Staged git diff: ```\n"
                  .. git_diff
                  .. "\n```",
              },
            },
          },
        },
      }
    end,
    -- request_completion = gemini_builder.request_completion,
  },
  ["to spanish"] = {
    provider = openai,
    hl_group = "SpecialComment",
    builder = function(input)
      return {
        messages = {
          {
            role = "system",
            content = "Translate to Spanish",
          },
          {
            role = "user",
            content = input,
          },
        },
      }
    end,
    mode = mode.REPLACE,
  },
  ["to javascript"] = {
    provider = openai,
    builder = function(input, ctx)
      return {
        messages = {
          {
            role = "system",
            content = "Convert the code to javascript",
          },
          {
            role = "user",
            content = input,
          },
        },
      }
    end,
  },
  ["to rap"] = {
    provider = openai,
    hl_group = "Title",
    builder = function(input)
      return {
        messages = {
          {
            role = "system",
            content = "Explain the code in 90's era rap lyrics",
          },
          {
            role = "user",
            content = input,
          },
        },
      }
    end,
  },
})
