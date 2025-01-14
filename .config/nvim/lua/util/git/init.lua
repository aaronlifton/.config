---@class util.git
local M = {}

function M.mru_branches(count)
  count = count or 5
  return vim.fn.systemlist(
    'git for-each-ref --sort=-committerdate refs/heads/ --format="%(refname:short)" --count=' .. count
  )
end

---@param system_cmd table|nil
---@return string
function M.get_git_diff(system_cmd)
  system_cmd = system_cmd or { "git", "diff", "--staged" }
  local git_diff = vim.fn.system(system_cmd)

  if not git_diff:match("^diff") then
    git_diff = vim.fn.system({ "git", "diff" })

    if not git_diff:match("^diff") then error("diff empty:\n" .. git_diff) end
  end

  return git_diff
end

return M
