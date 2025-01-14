local util = require("model.util")
local sse = require("model.util.sse")

local input_as_message = require("model.providers.openai").prompt.input_as_message

---@type Provider
local M = {
  request_completion = function(handler, params)
    vim.api.nvim_echo({ { "Params", "Title" }, { vim.inspect(params), "String" } }, true, {})
    -- Default endpoint is chat
    local endpoint = "chat"
    if params.endpoint == "fim" then
      endpoint = "fim"
      params.endpoint = nil
    end
    local api_key, base_url
    if params.model == "codestral-mamba-latest" then
      api_key = util.env("MISTRAL_API_KEY")
      base_url = "https://api.mistral.ai/v1/"
    else
      base_url = "https://codestral.mistral.ai/v1/"
      api_key = util.env("CODESTRAL_API_KEY")
    end

    return sse.curl_client({
      url = base_url .. endpoint .. "/completions",
      headers = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json",
        ["Authorization"] = "Bearer " .. api_key,
      },
      body = vim.tbl_deep_extend("force", {}, params, { stream = true }),
    }, {
      on_message = function(msg, raw)
        local data = util.json.decode(msg.data)

        if data == nil then return end

        if data.object == "chat.completion.chunk" then handler.on_partial(data.choices[1].delta.content) end
      end,
      on_error = handler.on_error,
      on_other = handler.on_error,
      on_exit = handler.on_finish,
    })
  end,
}

return M
-- ❯ curl --location "https://api.mistral.ai/v1/chat/completions" \
--            --header 'Content-Type: application/json' \
--            --header 'Accept: application/json' \
--            --header "Authorization: Bearer $MISTRAL_API_KEY" \
--            --data '{
--       "model": "codestral-mamba-latest",
--       "messages": [{"role": "user", "content": "Write a function for fibonacci"}]
-- }'
