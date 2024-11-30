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
  -- VectorRuby = {
  --   builder = function(input, context)
  --     ---@type {id: string, content: string}[]
  --     local store_results = require("model.store").prompt.query_store(input, 2, 0.75)
  --
  --     -- add store_results to your messages
  --   end,
  -- },
  ["gemini:flash"] = vim.tbl_deep_extend("force", require("model.prompts.chats").gemini, {
    provider = require("util.model.providers.gemini-flash"),
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
  -- https://docs.anthropic.com/en/docs/about-claude/models#prompt-and-output-performance
  ["claude:opus"] = {
    provider = require("model.providers.anthropic"),
    create = input_if_selection,
    params = {
      model = "claude-3-opus-20240229",
      max_tokens = 4096,
    },
    run = function(messages, config)
      return vim.tbl_deep_extend("force", config.params, {
        messages = messages,
        system = config.system,
      })
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
})
