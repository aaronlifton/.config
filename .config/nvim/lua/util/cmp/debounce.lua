if not package.loaded["cmp"] then return {} end

local M = {
  bounce_delay = 350, -- ms
}

local cmp = require("cmp")

-- this will show cmp popup after bounce_delay of inactivity when typing. Works even on empty line, or after space...
function M.cmp_complete_force()
  if vim.fn.mode() == "i" then -- and not cmp.visible() and
    local current_win_id = vim.fn.win_getid() -- if windows if floating then ignore
    if vim.api.nvim_win_get_config(current_win_id).zindex then return end
    -- Auto takes keyword_length into account, (wont ignore existing letters - unlike manual) but wont show anything if no letter in line...
    -- Manual will show popup even if no letter, but then ignores these latters it seems...
    -- check if current line has any letters : if not use Manual
    local current_line = vim.api.nvim_get_current_line()
    local has_letters = string.find(current_line, "%a") -- "%a" matches any alphabet character (equivalent to [a-zA-Z])
    -- make sure current buffer is not input box, command, or terminal
    -- cmp.complete({ reason = cmp.ContextReason.Manual }) -- without reason, it will ignore letters before cursor...
    cmp.complete({ reason = cmp.ContextReason.Manual }) --  ok after all?
    -- if has_letters then
    --   cmp.complete({ reason = cmp.ContextReason.Auto }) -- takes letters into account, but wont show popup if no letters in line
    -- else
    --   cmp.complete({ reason = cmp.ContextReason.Manual }) -- without reason, it will ignore letters before cursor...
    -- end
    -- cmp.complete()  -- gives 'old' suggestion (like it does not see characters types after first bounce... even thought using bounce_trailing)
  end
end

function M.setup()
  local cmp_complete_bounce, timer =
    require("util.throttle_debounce").debounce_trailing(M.cmp_complete_force, M.bounce_delay, false) -- first = false (use last arg)

  local au_cmp_hold_show = vim.api.nvim_create_augroup("CmpShowOnHold", { clear = true })

  vim.api.nvim_create_autocmd({ "TextChangedI", "InsertEnter", "TextChangedP" }, { -- bounce as much as possible
    pattern = { "*.go", "*.lua" },
    callback = function()
      cmp_complete_bounce()
    end,
    group = au_cmp_hold_show,
  })
  -- same for insert leave - except it will timer.close()
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*.go", "*.lua" },
    callback = function()
      if not timer then return end

      timer:stop() -- do not fire timer callback on insert
    end,
    group = au_cmp_hold_show,
  })
end

return M
