---@class util.yazi.resolvers.github
local M = {}

function M.github_url_for(path)
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 or not git_root or git_root == "" then return nil end
  git_root = vim.trim(git_root)
  if not Util.path.is_within_dir(path, git_root) then return nil end

  local remote = vim.fn.systemlist("git remote get-url origin")[1]
  if vim.v.shell_error ~= 0 or not remote or remote == "" then return nil end
  remote = vim.trim(remote)
  if remote:match("^git@github.com:") then
    remote = remote:gsub("^git@github.com:", "https://github.com/")
  elseif remote:match("^https://github.com/") then
    -- already https-based
  else
    return nil
  end
  remote = remote:gsub("%.git$", "")

  local branch = vim.fn.systemlist("git symbolic-ref --short HEAD")[1]
  if vim.v.shell_error ~= 0 or not branch or branch == "" then
    branch = vim.fn.systemlist("git rev-parse HEAD")[1]
    if vim.v.shell_error ~= 0 or not branch or branch == "" then return nil end
  end
  branch = vim.trim(branch)

  local relative = path:sub(#git_root + 2)
  return string.format("%s/blob/%s/%s", remote, branch, relative)
end

M.resolve = M.github_url_for

return M
