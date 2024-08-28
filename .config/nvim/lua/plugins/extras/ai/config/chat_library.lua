local agents = require("plugins.extras.ai.config.agents")
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
  z = function(agent)
    local zephyr_fmt = require("model.format.zephyr")
    local ollama = require("model.providers.ollama")

    return {
      provider = ollama,
      params = {
        model = "zephyr",
      },
      system = agent.system,
      create = input_if_selection,
      run = zephyr_fmt.chat,
    }
  end,
  mc = function(agent)
    -- local magicoder = require("models.magicoder")
    local chatml_fmt = require("models.format.chatml")
    local ollama = require("model.providers.ollama")

    return {
      provider = ollama,
      params = {
        model = "magicoder",
      },
      system = agent.system,
      create = input_if_selection,
      run = chatml_fmt.chat,
    }
  end,
  ReviewDiff = vim.tbl_deep_extend("force", require("model.prompts.chats").gemini, {
    system = "You are an expert programmer that gives constructive feedback. Review the changes in the user's git diff. Don't describe what the user has done. Suggest some improvements if you find some.",
    create = function()
      local cwd = LazyVim.root.get()
      local git_diff = vim.fn.system({ "git", "-C", cwd, "diff", "--staged", "-U0" })

      if not git_diff:match("^diff") then error("Git error:\n" .. git_diff) end

      return git_diff
    end,
  }),
  VectorRuby = {
    builder = function(input, context)
      ---@type {id: string, content: string}[]
      local store_results = require("model.store").prompt.query_store(input, 2, 0.75)

      -- add store_results to your messages
    end,
  },
  PromptChecker = {
    provider = require("model.providers.ollama"),
    params = {
      model = "starling-lm",
    },
    system = agents.prompt_checker.system,
    create = function(input, context)
      return "Prompt:" .. (context.selection and input or "")
    end,
    run = require("model.format.starling").chat,
  },
  ProductManager = {
    provider = require("model.providers.ollama"),
    system = agents.product_manager.system .. agents.asks_questions,
    params = {
      model = "starling-lm",
    },
    create = function(input, context)
      return "Topic: " .. (context.selection and input or "")
    end,
    run = require("model.format.starling").chat,
  },
  ProductManagerStories = {
    provider = require("model.providers.ollama"),
    system = "Act as a Product Owner. You are to write stories based on the user requirements I give you.",
    params = {
      model = "starling-lm",
    },
    create = function(input, context)
      return context.selection and input or ""
    end,
    run = require("model.format.starling").chat,
  },
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
      -- negative_prompt = ""
      -- prompt = ""
      -- prompt_format_string -- below
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
  ["claude:opus"] = {
    provider = require("model.providers.anthropic"),
    create = input_if_selection,
    params = {
      model = "claude-3-opus-20240229",
    },
    run = function(messages, config)
      return vim.tbl_deep_extend("force", config.params, {
        messages = messages,
        system = config.system,
      })
    end,
  },
  -- TODO: WIP
  ["hf:codestral"] = {
    provider = require("model.providers.huggingface"),
    options = {
      model = "mistralai/Codestral-22B-v0.1",
    },
    builder = function(input)
      return { inputs = input }
    end,
  },
  -- TODO: WIP
  ["hf:qwen2"] = {
    provider = require("util.model.providers.huggingface"),
    system = "You are a helpful assistant.",
    options = {
      models = "Qwen/Qwen2-72B-Instruct",
    },
    create = function(input, ctx)
      return ctx.selection and input or ""
    end,
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
  -- TODO: WIP
  ["hf:mixtral"] = {
    --   Error  20:07:08 notify.error '{"error":"The model DiscoResearch/DiscoLM-mixtral-8x7b-v2 is too large to be loaded automatically (93GB > 10GB). Please use Spaces (https://huggingface.co/spaces) or Inference Endpoints (https://huggingface.co/inference-endpoints)."}'
    provider = require("util.model.providers.huggingface"),
    options = {
      -- model = "DiscoResearch/DiscoLM-mixtral-8x7b-v2",
      model = "mistralai/Codestral-22B-v0.1 ",
      temperature = 0.7,
      top_p = 0.7,
      top_k = 50,
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
        prompt = table.concat(vim.tbl_map(function(msg)
          return "<|im_start|>" .. msg.role .. "\n" .. msg.content .. "<|im_end|>\n"
        end, messages)) .. "<|im_start|>assistant",
      }
    end,
    ["codellama:qfix"] = vim.tbl_deep_extend("force", require("model.prompts.chats")["together:codellama"], {
      system = "You are an intelligent programming assistant",
      create = function()
        return require("model.util.qflist").get_text()
      end,
    }),
  },
  pplx = {
    provider = require("util.model.providers.pplx"),
    system = "You are an artificial intelligence assistant and you need to engage in a helpful, detailed, polite conversation with a user.",
    params = {
      model = "llama-3-sonar-large-32k-online",
      -- model = "llama-3.1-sonar-small-128k-online",
      -- model = "llama-3.1-sonar-huge-128k-online",
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
