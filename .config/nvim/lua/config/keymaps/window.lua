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
    local last_info = vim.g.last_win[#vim.g.last_win]
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
  require("util.ui").switch_to_highest_window()
end)

-- maximize the height of the current window  using builtin lua neovim api
map("n", "<leader>wg", function()
  local win = vim.api.nvim_get_current_win()
  local max_win_height = vim.api.nvim_get_option_value("lines", { win = win }) - 5
  vim.api.nvim_command(":set ma")
  for _ = 1, (max_win_height / 2) do
    vim.api.nvim_command(':exe "norm \\<c-w>+"')
  end
  vim.api.nvim_command(":sleep 50m<cr>")
  vim.api.nvim_command(':exe "norm \\<c-w>+"')
  vim.api.nvim_command(":set noma")
  vim.api.nvim_command(':exe "norm \\<c-w>+"')
end, { desc = "Maximize Height" })
