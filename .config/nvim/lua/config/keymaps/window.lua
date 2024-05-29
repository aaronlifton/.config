local map = vim.keymap.set

---@class LastWindow
local LastWindow = {}
---@param tabpage number
---@param winid number
---@param bufnr number
---@return LastWindow
function LastWindow:new(tabpage, winid, bufnr)
  local obj = {
    tabpage = tabpage,
    winid = winid,
    bufnr = bufnr,
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

map("n", "<leader>wb", function()
  local curr_info = function()
    local tabpage = vim.api.nvim_get_current_tabpage()
    local winid = vim.api.nvim_get_current_win()
    local bufnr = vim.fn.bufnr()
    return LastWindow:new(tabpage, winid, bufnr)
  end
  if vim.g.last_win ~= nil then
    vim.api.nvim_echo({
      { vim.inspect(vim.g.last_win), "Title" },
    }, false, {})
    last_info = vim.g.last_win[#vim.g.last_win]
    local tabpage = last_info.tabpage
    local winid = last_info.winid
    local bufnr = last_info.bufnr
    vim.api.nvim_set_current_tabpage(tabpage)
    vim.api.nvim_set_current_win(winid)
    vim.api.nvim_set_current_buf(bufnr)
    table.remove(vim.g.last_win, #vim.g.last_win)
    vim.api.nvim_echo({
      { "Saved window\n", "Title" },
      { "Navigate back using ", "Normal" },
      { "<leader>wh", "Keyword" },
    }, false, {})
  end
end, { desc = "Last Window" })

-- local augroup = vim.api.nvim_create_augroup("LastWindow", { clear = true })
-- vim.api.nvim_create_autocmd("WinEnter", {
--   group = augroup,
--   callback = function()
--     vim.g.last_win = vim.g.last_win or {}
--     table.insert(
--       vim.g.last_win,
--       LastWindow:new(vim.api.nvim_get_current_tabpage(), vim.api.nvim_get_current_win(), vim.fn.bufnr())
--     )
--   end,
-- })

map("n", "<leader>wh", function()
  vim.api.nvim_command("HighestWindow")
end)
