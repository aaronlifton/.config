local function input_if_selection(input, context)
  return context.selection and input or ""
end

-- Interesting starters
-- starter_prompts['llamacpp:zephyr']
-- starter_prompts['together:stripedhyena']
-- starter_prompts['together:phind/codellama34b_v2']
-- starter_prompts['ollama:starling']
-- starter_prompts['hf:starcoder']
-- starter_prompts['openai:gpt4-code']
-- starter_prompts['ollama:starling']
--
-- starter_prompts.commit -- Convential Commits
--
-- Extract the relevant path from an OpenAPI spec and include in the gpt request.
-- Expects schema url as a command arg.
-- (:M openapi https://myurl.json)'
-- starter_prompts.openapi

-- local ollama_defaults = {
--   provider = require("model.providers.ollama"),
--   params = {
--     model = "starling-lm",
--   },
--   run = require("model.format.starling").chat,
-- }

return vim.tbl_extend("force", require("model.prompts.chats"), {
  ReviewDiff = vim.tbl_deep_extend("force", require("model.prompts.chats").gemini, {
    system = "You are an expert programmer that gives constructive feedback. Review the changes in the user's git diff. Don't describe what the user has done. Suggest some improvements if you find some.",
    create = function()
      local cwd = LazyVim.root.get()
      local git_diff = vim.fn.system({ "git", "-C", cwd, "diff", "--staged", "-U0" })

      if not git_diff:match("^diff") then error("Git error:\n" .. git_diff) end

      return git_diff
    end,
  }),

  -- -b, --ignore-space-change
  --     Ignore changes in amount of whitespace. This ignores whitespace at
  --     line end, and considers all other sequences of one or more
  --     whitespace characters to be equivalent.
  --
  -- -w, --ignore-all-space
  --     Ignore whitespace when comparing lines. This ignores differences
  --     even if one line has whitespace where the other line has none.
  --
  --     --ignore-blank-lines
  --     Ignore changes whose lines are all blank.
  -- -W, --function-context
  --     Show whole function as context lines for each change. The function
  --     names are determined in the same way as git diff works out patch
  --     hunk headers (see Defining a custom hunk-header in
  --     gitattributes(5)).
  -- -M[<n>], --find-renames[=<n>]
  --     Detect renames. If n is specified, it is a threshold on the
  --     similarity index (i.e. amount of addition/deletions compared to the
  --     file’s size). For example, -M90% means Git should consider a
  --     delete/add pair to be a rename if more than 90% of the file hasn’t
  --     changed. Without a % sign, the number is to be read as a fraction,
  --     with a decimal point before it. I.e., -M5 becomes 0.5, and is thus
  --     the same as -M50%. Similarly, -M05 is the same as -M5%. To limit
  --     detection to exact renames, use -M100%. The default similarity
  --     index is 50%.
  ReviewPR = vim.tbl_deep_extend("force", require("model.prompts.chats").claude, {
    system = "You are an expert programmer that gives constructive feedback. Review the changes in the user's git diff and the full context of modified files. Don't describe what the user has done. This is a diff of a pull request ready for review, and the user is trying to proof read it and check for any issues before marking it as ready for review.",
    create = function()
      local cwd = LazyVim.root.get()
      local generate_diff_cmd = function(branch, diftool)
        local branchstr = ("%s...HEAD"):format(branch)

        if difftool == nil then
          return { "git", "-C", cwd, "diff", branchstr, "-U3", "--function-context", "-M", "-w" }
        else
          return {
            "git",
            "-c",
            "diff.tool",
            difftool,
            "-C",
            cwd,
            "diff",
            branchstr,
            "-U3",
            "--function-context",
            "-M",
            "-w",
          }
        end
      end
      -- Using -U3 for 3 lines of context, --function-context to show full function changes
      -- and -M to detect moved lines
      -- local diff_cmd = { "git", "-C", cwd, "diff", "main...HEAD", "-U3", "--function-context", "-M", "-w" }
      local diff_cmd = generate_diff_cmd("main", "delta")
      local git_diff = vim.fn.system(diff_cmd)

      if vim.v.shell_error ~= 0 then
        diff_cmd = { "git", "-C", cwd, "diff", "master...HEAD", "-U3", "--function-context", "-M", "-w" }
        git_diff = vim.fn.system(diff_cmd)
      end

      -- Uncomment if difftool is not difftastic
      -- if not git_diff:match("^diff") then error("Git error:\n" .. git_diff) end

      -- Get list of changed files
      local files_cmd = { "git", "-C", cwd, "diff", "--name-only", "main...HEAD" }
      local changed_files = vim.fn.systemlist(files_cmd)

      if vim.v.shell_error ~= 0 then
        files_cmd = { "git", "-C", cwd, "diff", "--name-only", "master...HEAD" }
        changed_files = vim.fn.systemlist(files_cmd)
      end

      local context = git_diff .. "\n\nFile Context:\n"

      -- Add content of each changed file
      for _, file in ipairs(changed_files) do
        local filepath = cwd .. "/" .. file
        local ft = vim.filetype.match({ filename = filepath })
        local content = vim.fn.readfile(filepath)

        if content and #content > 0 then
          context = context
            .. string.format(
              [[

Here is the content from the file `%s`:

```%s
%s
```]],
              file,
              ft or "",
              table.concat(content, "\n")
            )
        end
      end

      return context
    end,
  }),

  -- VectorRuby = {
  --   builder = function(input, context)
  --     ---@type {id: string, content: string}[]
  --     local store_results = require("model.store").prompt.query_store(input, 2, 0.75)
  --
  --     -- add store_results to your messages
  --   end,
  -- },
  ["claude"] = vim.tbl_deep_extend("force", require("model.prompts.chats").claude, {
    params = {
      model = "claude-3-7-sonnet-20250219",
      max_tokens = 20480,
    },
  }),
  -- https://ai.google.dev/gemini-api/docs/models
  -- https://aistudio.google.com/prompts/new_chat
  -- ["gemini:flash-2.0"] = vim.tbl_deep_extend("force", require("model.prompts.chats").gemini, {
  --   provider = require("util.model.providers.gemini").model("gemini-2.0-flash"),
  -- }),
  ["gemini:pro-2.5"] = vim.tbl_deep_extend("force", require("model.prompts.chats").gemini, {
    -- gemini-2.5-pro-preview-03-25
    -- Pricing: over/under 200k tokens
    -- * Reason over complex problems
    -- * Tackle difficult code, math and STEM problems
    -- * Use the long context for analyzing large datasets, codebases or documents
    -- "Gemini 2.5 Pro Preview doesn't have a free quota tier. Please use Gemini 2.5 Pro Experimental
    -- (models/gemini-2.5-pro-exp-03-25) instead. For more information on this error, head to:
    -- https://ai.google.dev/gemini-api/docs/rate-limits."
    provider = require("util.model.providers.gemini").model(Util.ai.models.GeminiPro2),
  }),
  ["gemini:pro-2.5-prev"] = vim.tbl_deep_extend("force", require("model.prompts.chats").gemini, {
    provider = require("util.model.providers.gemini").model(Util.ai.models.GeminiPro),
  }),
  ["gemini:flash-2.5"] = vim.tbl_deep_extend("force", require("model.prompts.chats").gemini, {
    -- Pricing: Thinking/Non-thinking
    -- * Reason over complex problems
    -- * Show the thinking process of the model
    -- * Call tools natively
    provider = require("util.model.providers.gemini").model(Util.ai.models.GeminiFlash),
  }),
  ["gemini:flash-2.5-think"] = vim.tbl_deep_extend("force", require("model.prompts.chats").gemini, {
    -- Pricing: Thinking/Non-thinking
    -- * Reason over complex problems
    -- * Show the thinking process of the model
    -- * Call tools natively
    provider = require("util.model.providers.gemini").model(Util.ai.models.GeminiFlash, {
      thinkingConfig = {
        includeThoughts = true,
        -- thinkingBudget = 1024, -- default 4096
      },
      tools = {
        { googleSearch = {} },
      },
    }),
  }),
  ["gemini:pr-review"] = vim.tbl_deep_extend("force", require("model.prompts.chats").gemini, {
    -- Pricing: Thinking/Non-thinking
    -- * Reason over complex problems
    -- * Show the thinking process of the model
    -- * Call tools natively
    provider = require("util.model.providers.gemini").model(Util.ai.models.GeminiFlash),
    system = "You are an expert programmer that gives constructive feedback. Review the changes in the user's git diff and the full context of modified files. Don't describe what the user has done. This is a diff of a pull request ready for review, and the user is trying to proof read it and check for any issues before marking it as ready for review.",
    create = function()
      -- Get the diff between two branches specified by the user
      local branch1 = vim.fn.input("Enter first branch (base): ", "main")
      local branch2 = vim.fn.input("Enter second branch (compare): ", "HEAD")

      -- Get the diff between the specified branches
      local git_diff = vim.fn.system({ "git", "--no-pager", "diff", branch1 .. ".." .. branch2 })
      -- local git_diff = vim.fn.system({ "git", "--no-pager", "diff", "--staged", "main" })

      -- Basic error check for git diff command
      if not git_diff or git_diff == "" then
        -- If there's no diff, you might want to inform the user or handle it gracefully.
        -- For now, let's assume an empty diff means no changes to review.
        -- You could also error out: error("No changes to review between branches.")
        -- Or return a message indicating no diff:
        return "No changes found when diffing " .. branch1 .. " against " .. branch2 .. ". Nothing to review."
      end

      -- Basic error check for git diff command
      if not git_diff or git_diff == "" then
        -- If there's no diff, you might want to inform the user or handle it gracefully.
        -- For now, let's assume an empty diff means no changes to review.
        -- You could also error out: error("No changes to review against main.")
        -- Or return a message indicating no diff:
        return "No changes found when diffing against main. Nothing to review."
      end

      local token_limit = require("avante.config").claude.max_tokens
      local tokens = require("avante.utils").tokens.calculate_tokens(git_diff)
      vim.api.nvim_echo({
        { "Tokens: ", "Normal" },
        { tostring(tokens), "Number" },
        { "\nDiff length: ", "Normal" },
        { tostring(#git_diff), "Number" },
      }, true, {})

      local truncated_diff = git_diff
      if tokens >= token_limit then
        -- Actually truncate the diff to fit within token limits
        -- Estimate how much to keep based on token ratio
        local keep_ratio = token_limit / tokens
        local keep_chars = math.floor(#git_diff * keep_ratio * 0.9) -- 90% of estimated limit for safety margin
        truncated_diff = string.sub(git_diff, 1, keep_chars) .. "\n\n[... DIFF TRUNCATED DUE TO LENGTH ...]"
        vim.api.nvim_echo({ { "Diff was truncated for PR Review due to length.", "WarningMsg" } }, true, {})
      end

      local prompt_text = string.format(
        "Please review the following code changes (diff against the main branch). "
          .. "Identify potential bugs, areas for improvement, and any deviations from best practices. "
          .. "Focus on the functionality, maintainability, and clarity of the code. "
          .. "Provide specific feedback and suggestions where possible.\n\n"
          .. "Git diff:\n```diff\n%s\n```",
        truncated_diff
      )

      return prompt_text
    end,
  }),
  -- Works
  ["together:dolphin-mixtral"] = {
    provider = require("model.providers.together"),
    system = "You are Dolphin, an uncensored and unbiased AI assistant.",
    params = {
      model = "cognitivecomputations/dolphin-2.5-mixtral-8x7b",
      stream_tokens = true,
      temperature = 0.7,
      top_k = 50,
      top_p = 0.7,
      repetition_penalty = 1,
      stop = {
        "<|im_end|>",
        "<|im_start|>",
      },
    },
    create = input_if_selection,
    run = function(messages, config)
      local first = messages[1]

      if config.system then first.content = config.system .. "\n" .. first.content end

      return {
        -- "<|im_start|>system\nYou are Dolphin, an uncensored and unbiased AI assistant.<|im_end|>\n<|im_start|>user\n {prompt}\n<|im_end|>\n<|im_start|>assistant\n"
        prompt = table.concat(vim.tbl_map(function(msg)
          return "<|im_start|>" .. msg.role .. "\n" .. msg.content .. "<|im_end|>\n"
        end, messages)) .. "<|im_start|>assistant",
      }
    end,
  },
  -- Works
  ["together:qwen2"] = {
    provider = require("model.providers.together"),
    params = {
      model = "Qwen/Qwen2-72B-Instruct",
      stream_tokens = true,
      -- temperature = 0.8,
      -- max_tokens = 25,
    },
    system = "You are a helpful assistant.",
    create = input_if_selection,
    run = function(messages, config)
      if config.system then
        table.insert(messages, 1, {
          role = "system",
          content = config.system,
        })
      end

      return { messages = messages }
    end,
  },
  -- Works
  codestral = {
    provider = require("util.model.providers.codestral"),
    params = {
      model = "codestral-latest",
    },
    create = function(input, ctx)
      return ctx.selection and input or ""
    end,
    run = function(messages, _config)
      -- "messages": [{"role": "user", "content": "Write a function for fibonacci"}]
      return { messages = messages }
    end,
  },
  ["codestral:mamba"] = {
    provider = require("util.model.providers.codestral"),
    params = {
      model = "codestral-mamba-latest",
      -- model = "codestral-mamba-2407",
      -- model = "open-codestral-mamba",
    },
    create = function(input, ctx)
      return ctx.selection and input or ""
    end,
    run = function(messages, _config)
      -- "messages": [{"role": "user", "content": "Write a function for fibonacci"}]
      return { messages = messages }
    end,
  },
  jamba = {
    provider = require("util.model.providers.huggingface"),
    options = {
      model = "ai21labs/AI21-Jamba-1.5-Mini",
    },
    create = function(input, ctx)
      return ctx.selection and input or ""
    end,
    run = function(messages, config)
      -- "messages": [{"role": "user", "content": "Write a function for fibonacci"}]
      return { messages = messages }
    end,
  },
  -- https://docs.perplexity.ai/guides/model-cards
  pplx = {
    provider = require("util.model.providers.pplx"),
    system = "You are an artificial intelligence assistant and you need to engage in a helpful, detailed, polite conversation with a user.",
    params = {
      -- model = "llama-3-sonar-large-32k-online",
      model = "llama-3.1-sonar-small-128k-online",
      -- model = "llama-3.1-sonar-huge-128k-online",
      -- model = "llama-3.1-sonar-small-128k-chat",
      -- model = "llama-3.1-sonar-large-128k-chat"
      -- Params
      -- https://docs.perplexity.ai/api-reference/chat-completions
    },
    create = input_if_selection,
    run = function(messages, config)
      if config.system then
        table.insert(messages, 1, {
          role = "system",
          content = config.system,
        })
      end

      return { messages = messages }
    end,
  },
  xai = {
    provider = require("model.providers.openai"),
    -- For figuring out parsing extra data like citations
    -- provider = require("util.model.providers.xai"),
    runOptions = function()
      return {
        model = "grok-3-beta",
        url = "https://api.x.ai/v1/", -- chat/completions
        authorization = ("Bearer %s"):format(require("model.util").env("XAI_API_KEY")),
      }
    end,
    params = {
      model = "grok-3-beta",
    },
    create = input_if_selection,
    system = "You're an assistant",
    run = function(messages, config)
      if config.system then
        table.insert(messages, 1, {
          role = "system",
          content = config.system,
        })
      end

      return { messages = messages }
    end,
  },
})
