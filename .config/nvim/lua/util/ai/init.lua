---@class util.ai
---@field context util.ai.context
---@field avante util.ai.avante
local M = {}

M.models = {
  GeminiFlash = "gemini-2.5-flash-preview-04-17",
  GeminiPro = "gemini-2.5-pro-exp-03-25",
  GeminiPro2 = "gemini-2.5-pro-preview-05-06",
}

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

function M.mgrep()
  local query = vim.fn.input("Query: ")
  local args = { "mgrep", "--web", "--answer", ('"%s"'):format(query) }
  -- Snacks.terminal({ "mgrep", "--web", "--answer", ('"%s"'):format(query) }, { auto_close = false })
  vim.cmd((":vs | term %s"):format(vim.fn.join(args, " ")))
  local buf = vim.api.nvim_get_current_buf()
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
end

return M
