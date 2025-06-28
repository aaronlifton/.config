---@class util.snacks
---@field pickers util.snacks.pickers
local M = {
  pickers = require("util.snacks.pickers"),
}
function M.nested_input()
  Snacks.input({ prompt = "From: ", icon = "" }, function(from)
    if from == "" then return end
    Snacks.input({ prompt = "To: ", icon = "" }, function(to)
      if to == "" then return end
      vim.api.nvim_command("DiffviewOpen " .. from .. ".." .. to)
    end)
  end)
end

return M
