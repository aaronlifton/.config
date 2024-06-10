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

      if not git_diff:match("^diff") then
        error("Git error:\n" .. git_diff)
      end

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
  ["hf:mixtral"] = {
    provider = require("overseer.providers.huggingface"),
    options = {
      model = "DiscoResearch/DiscoLM-mixtral-8x7b-v2",
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

      if config.system then
        first.content = config.system .. "\n" .. first.content
      end

      return {
        prompt = table.concat(vim.tbl_map(function(msg)
          return "<|im_start|>" .. msg.role .. "\n" .. msg.content .. "<|im_end|>\n"
        end, messages)) .. "<|im_start|>assistant",
      }
    end,
  },
})
