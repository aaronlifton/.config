---@class util.writing
local M = {}

function M.count_words(opts)
  opts = opts or {}
  local count = 0

  ---@param lines string[]
  ---@return number
  local count_words = function(lines)
    for _, line in ipairs(lines) do
      for _ in line:gmatch("%w+") do
        count = count + 1
      end
    end
    return count
  end

  if opts.range == 2 then
    local start_line = opts.line1
    local end_line = opts.line2
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    count = count_words(lines)
  else
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    count = count_words(lines)
  end
  vim.api.nvim_echo({ { "Word count\n", "Title" }, { tostring(count), "Normal" } }, true, {})
end
vim.api.nvim_create_user_command("WordCount", function()
  M.count_words()
end, { range = true })

return M
