---@class util.ai
---@field context util.ai.context
local M = {}

local ui = require("util.ai.ui")

function M.toggle(toggle, type, prompt)
  local open = (toggle ~= "" and toggle) or (toggle == "" and not ui.is_open())
  if open then
    local openai = require("util.ai.openai_api")
    ui.create_ui(openai, type)
    if prompt ~= nil then ui.send_prompt(prompt) end
    return true
  else
    ui.destroy_ui()
    return false
  end
end

return M
