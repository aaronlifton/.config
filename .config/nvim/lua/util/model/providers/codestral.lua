local util = require("model.util")
local sse = require("model.util.sse")
local echo = require("util.debug").echo

local input_as_message = require("model.providers.openai").prompt.input_as_message

---@type Provider
local M = {
  request_completion = function(handler, params)
    echo("Params", params)
    -- Default endpoint is chat
    local endpoint = "chat"
    if params.endpoint == "fim" then
      endpoint = "fim"
      params.endpoint = nil
    end

    return sse.curl_client({
      url = "https://codestral.mistral.ai/v1/" .. endpoint .. "/completions",
      headers = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json",
        ["Authorization"] = "Bearer " .. util.env("CODESTRAL_API_KEY"),
      },
      body = vim.tbl_deep_extend("force", {}, params, { stream = true }),
    }, {
      on_message = function(msg, raw)
        local data = util.json.decode(msg.data)

        if data == nil then
          return
        end

        if data.object == "chat.completion.chunk" then
          handler.on_partial(data.choices[1].delta.content)
        end
      end,
      on_error = handler.on_error,
      on_other = handler.on_error,
      on_exit = handler.on_finish,
    })
  end,
}

return M
