---@class util.git
local M = {}

M.git_repo = function()
  local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
  return git_dir
end

M.is_git_repo = function()
  local git_dir = M.git_repo()
  return git_dir ~= ""
end

return M
