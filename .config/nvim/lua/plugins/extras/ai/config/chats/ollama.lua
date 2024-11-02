local agents = require("plugins.extras.ai.config.agents")

return {
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
}
