local util = require("model.util")
local sse = require("model.util.sse")

local M = {}
---
-- Params({
--   model = "DiscoResearch/DiscoLM-mixtral-8x7b-v2",
--   prompt = "<|im_start|>user\nTEsting.<|im_end|>\n<|im_start|>assistant",
--   repetition_penalty = 1,
--   stop = { "<|im_end|>", "<|im_start|>" },
--   temperature = 0.7,
--   top_k = 50,
--   top_p = 0.7,
-- })
function echo(title, body)
  vim.api.nvim_echo({ { title, "Title" }, { vim.inspect(body), "String" } }, true, {})
end
---@param handlers StreamHandlers
---@param params? any Additional params for request. Note the parameters detailed at https://huggingface.co/docs/api-inference/detailed_parameters need to go in the `params.parameters` field.
---@param options? { model?: string }
function M.request_completion(handlers, params, options)
  local model = (options or {}).model or "bigscience/bloom"

  echo("Params", params)
  echo("Options", options)
  -- TODO handle non-streaming calls
  return sse.curl_client({
    url = "https://api-inference.huggingface.co/models/" .. model,
    method = "POST",
    body = vim.tbl_extend("force", { stream = true }, params),
    headers = {
      Authorization = "Bearer " .. util.env("HUGGINGFACE_API_KEY"),
      ["Content-Type"] = "application/json",
    },
  }, {
    on_message = function(msg)
      local item = util.json.decode(msg.data)

      if item == nil then
        handlers.on_error(msg.data, "json parse error")
        return
      end

      if item.token == nil then
        if item[1] ~= nil and item[1].generated_text ~= nil then
          -- non-streaming
          handlers.on_finish(item[1].generated_text, "stop")
          return
        end

        handlers.on_error(item, "missing token")
        return
      end

      local partial = item.token.text

      handlers.on_partial(partial)

      -- We get the completed text including input unless parameters.return_full_text is set to false
      if item.generated_text ~= nil and #item.generated_text > 0 then
        handlers.on_finish(item.generated_text, "stop")
      end
    end,
    on_other = handlers.on_error,
  })
end

M.default_prompt = {
  provider = M,
  options = {
    model = "bigscience/bloom",
  },
  params = {
    parameters = {
      return_full_text = false,
    },
  },
  builder = function(input)
    return { inputs = input }
  end,
}

return M
