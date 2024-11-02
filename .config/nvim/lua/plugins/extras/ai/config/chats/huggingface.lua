return {
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
}
