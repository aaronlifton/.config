local M = {}

local cmp = require("cmp")
local timer = vim.uv.new_timer()

M.DEBOUNCE_DELAY = 500

function M.debounce()
  if not timer then return end

  timer:stop()
  timer:start(
    M.DEBOUNCE_DELAY,
    0,
    vim.schedule_wrap(function()
      -- cmp.complete({ reason = cmp.ContextReason.Auto })
      cmp.complete()
    end)
  )
end

return M
