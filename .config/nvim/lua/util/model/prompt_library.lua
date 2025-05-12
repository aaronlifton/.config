local model = require("model")
local mode = require("model").mode
local extract = require("model.prompts.extract")
local openai = require("model.providers.openai")
local gemini = require("model.providers.gemini")
local gemini_custom = require("util.model.providers.gemini")
local anthropic = require("model.providers.anthropic")
local starter_prompts = require("model.prompts.starters")

---@type table<string, Prompt>
return vim.tbl_extend("force", starter_prompts, {
  ["anthropic:claude-code"] = {
    provider = anthropic,
    mode = mode.INSERT_OR_REPLACE,
    options = {
      headers = {
        ["anthropic-beta"] = nil,
      },
      trim_code = true,
    },
    params = {
      max_tokens = 20480,
      model = "claude-3-7-sonnet-20250219",
      system = "You are an expert programmer. Provide code which should go etween the before and after blocks of code. Respond only with a markdown code block. Use comments within the code if explanations are necessary.",
    },
    builder = function(input, context)
      local format = require("model.format.claude")

      return vim.tbl_extend(
        "force",
        context.selection and format.build_replace(input, context) or format.build_insert(context),
        {
          -- TODO this makes it impossible to get markdown in the response content
          -- eventually we may want to allow markdown in the code-fenced response
          stop_sequences = { "```" },
        }
      )
    end,
  },
  NodeJsConvert = {
    provider = openai,
    mode = model.mode.INSERT_OR_REPLACE,
    builder = function(input, context)
      local code = input
      return {
        messages = {
          {
            role = "user",
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
      local git_diff = require("util.git").get_git_diff({ "git", "-C", cwd, "diff", "--staged", "-U0" })

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
  ["openai:code"] = {
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
      -- /Users/$USER/.local/share/nvim/lazy/cmp-ai/lua/cmp_ai/backends/codestral.lua
      local ctx = Util.ai.context:get()
      return { prompt = ctx.lines_before }
    end,
  },
  ["DiffExplain:main"] = {
    provider = gemini,
    mode = mode.BUFFER,
    builder = function()
      local git_diff = vim.fn.system({ "git", "--no-pager", "diff", "--staged", "main" })
      vim.api.nvim_echo({ { "Length of diff:\n", "Title" }, { tostring(#git_diff), "Number" } }, true, {})
      -- local word_count = 0
      -- for _ in git_diff:gmatch("%S+") do
      --     word_count = word_count + 1
      -- end

      local words = {}
      for word in git_diff:gmatch("%S+") do
        table.insert(words, word)
        if #words >= 7000 then break end
      end
      git_diff = table.concat(words, " ")

      if not git_diff:match("^diff") then error("Git error:\n" .. git_diff) end
      return {
        contents = {
          {
            parts = {
              {
                text = "Describe the changes made in the following diff. Try to focus on the app's functionality."
                  .. "Git diff: ```\n"
                  .. git_diff
                  .. "\n```",
              },
            },
          },
        },
      }
    end,
  },
  ["PrReview"] = {
    provider = gemini_custom.model("gemini-2.5-flash-preview-04-17"),
    mode = mode.BUFFER,
    builder = function()
      -- Get the diff against the main branch.
      -- You might want to adjust this if your main branch has a different name (e.g., "master").
      -- Using --staged will only show staged changes. If you want all uncommitted changes against main:
      -- local git_diff = vim.fn.system({ "git", "--no-pager", "diff", "main" })
      -- If you want staged changes against main (like a pre-commit PR review):
      local git_diff = vim.fn.system({ "git", "--no-pager", "diff", "--staged", "main" })

      vim.api.nvim_echo({ { "Length of diff for PR Review:\n", "Title" }, { tostring(#git_diff), "Number" } }, true, {})

      -- Basic error check for git diff command
      if not git_diff or git_diff == "" then
        -- If there's no diff, you might want to inform the user or handle it gracefully.
        -- For now, let's assume an empty diff means no changes to review.
        -- You could also error out: error("No changes to review against main.")
        -- Or return a message indicating no diff:
        return {
          contents = {
            {
              parts = {
                {
                  text = "No changes found when diffing against main. Nothing to review.",
                },
              },
            },
          },
        }
      end

      -- Handle potential errors if git diff returns an error message (e.g., not a git repo)
      -- A more robust check might be needed depending on how `vim.fn.system` handles errors.
      -- For simplicity, we'll proceed, but in a real scenario, you might check `v:shell_error`.

      -- Truncate long diffs to avoid exceeding token limits (e.g., ~7000 words as a heuristic)
      local words = {}
      local token_limit = require("avante.config").claude.max_tokens
      for word in git_diff:gmatch("%S+") do
        table.insert(words, word)
        if #words >= token_limit then break end
      end
      local truncated_diff = table.concat(words, " ")

      if #words >= token_limit then
        vim.api.nvim_echo({ { "Diff was truncated for PR Review due to length.", "WarningMsg" } }, true, {})
      end

      local prompt_text = "Please review the following code changes (diff against the main branch). "
        .. "Identify potential bugs, areas for improvement, and any deviations from best practices. "
        .. "Focus on the functionality, maintainability, and clarity of the code. "
        .. "Provide specific feedback and suggestions where possible.\n\n"
        .. "Git diff: ```diff\n" -- Using diff language hint for better formatting by the model
        .. truncated_diff
        .. "\n```"

      return {
        contents = {
          {
            parts = {
              {
                text = prompt_text,
              },
            },
          },
        },
      }
    end,
  },

  ["commit:gemini"] = {
    provider = gemini,
    mode = mode.INSERT,
    -- request_completion = gemini_builder.request_completion,
    builder = function()
      local git_diff = vim.fn.system({ "git", "diff", "--staged" })

      if not git_diff:match("^diff") then error("Git error:\n" .. git_diff) end
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
                  .. "Make the commit mention concise and conventional, but add short descriptions of the changes as bullet points."
                  .. "Staged git diff: ```\n"
                  .. git_diff
                  .. "\n```",
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
      model = "gpt-4o",
    },
    builder = function()
      local git_diff = vim.fn.system({ "git", "diff", "--staged" })

      if not git_diff:match("^diff") then error("Git error:\n" .. git_diff) end

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
  ["commit-conventional:openai"] = {
    provider = openai,
    mode = mode.INSERT,
    builder = function()
      local git_diff = vim.fn.system({ "git", "diff", "--staged" })

      if not git_diff:match("^diff") then error("Git error:\n" .. git_diff) end

      return {
        messages = {
          {
            role = "user",
            content = "Write a terse commit message according to the Conventional Commits specification. Try to stay below 80 characters total. "
              .. "Return only text with no surrounding backticks. "
              .. "Staged git diff: ```\n"
              .. git_diff
              .. "\n```",
          },
        },
      }
    end,
  },
  ["convertToRtl:selection"] = {
    provider = anthropic,
    mode = mode.REPLACE,
    params = {
      max_tokens = 8192,
      model = "claude-3-5-sonnet-latest",
      system = "You are an expert programmer. Provide code which should go between the before and after blocks of code. Respond only with a markdown code block. Use comments within the code if explanations are necessary.",
    },
    transform = extract.markdown_code,
    builder = function(input, context)
      local format = require("model.format.claude")
      context.args = "Convert this enzyme test to RTL. Don't create new expectations, just convert the existing ones."
      return format.build_replace(input, context)
    end,
  },
})
