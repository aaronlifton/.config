-- [nfnl] Compiled from fennel/init.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local core = autoload("nfnl.core")
local nfnl = require("nfnl.api")
local function _2_()
  local ac = vim.api.nvim_create_autocmd
  local function _3_(event)
    local buf = event.buf
    local win = vim.api.nvim_get_current_win()
    local ns = vim.api.nvim_get_hl_ns({winid = win})
    return vim.api.nvim_set_hl(0, "MatchParen", {standout = true, bold = true})
  end
  return ac("BufEnter", {pattern = "*.fnl", callback = _3_})
end
return {init = _2_}
