local M = {}

M.request_completion = function(handlers, params, options)
  local util = require("model.util")
  local juice = require("model.util.juice")
  local curl = require("model.util.curl")

  local key = util.env_memo("GOOGLE_API_KEY")

  local remove_marquee = juice.handler_marquee_or_notify("Gemini Pro ", handlers.segment)

  local function handle_finish(raw_data)
    local response = util.json.decode(raw_data)

    if response == nil then
      error("Failed to decode json response:\n" .. raw_data)
    end

    if response.error ~= nil or not response.candidates then
      handlers.on_error(response)
      remove_marquee()
    else
      local first_candidate = response.candidates[1]

      if first_candidate == nil then
        error("No candidate returned:\n" .. raw_data)
      end

      local result = first_candidate.content.parts[1].text

      handlers.on_finish(result, "stop")
      remove_marquee()
    end
  end
  local function handle_error()
    handlers.on_error()
  end

  return curl.request({
    headers = {
      ["Content-Type"] = "application/json",
    },
    method = "POST",
    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" .. key,
    body = params,
  }, handle_finish, handle_error)
end

return M
