---@class util.yazi.resolvers.github
local M = {}

local function url_encode_path(path)
  return (path:gsub("[^%w%-._~/]", function(char)
    return string.format("%%%02X", string.byte(char))
  end))
end

function M.github_url_for(path)
  local abs_path = vim.fn.fnamemodify(path, ":p")
  local file_dir = vim.fn.fnamemodify(abs_path, ":h")
  local git_root = vim.fn.systemlist({ "git", "-C", file_dir, "rev-parse", "--show-toplevel" })[1]
  if vim.v.shell_error ~= 0 or not git_root or git_root == "" then return nil end
  git_root = vim.trim(git_root)
  if not Util.path.is_within_dir(abs_path, git_root) then return nil end

  local remote = vim.fn.systemlist({ "git", "-C", file_dir, "remote", "get-url", "origin" })[1]
  if vim.v.shell_error ~= 0 or not remote or remote == "" then return nil end
  remote = vim.trim(remote)

  local host, repo_path
  if remote:match("^git@") then
    host, repo_path = remote:match("^git@([^:]+):(.+)$")
  elseif remote:match("^https?://") then
    host, repo_path = remote:match("^https?://([^/]+)/(.+)$")
  end
  if not host or not repo_path then return nil end
  repo_path = repo_path:gsub("%.git$", "")
  local remote_base = ("https://%s/%s"):format(host, repo_path)

  local branch = vim.fn.systemlist({ "git", "-C", file_dir, "symbolic-ref", "--short", "HEAD" })[1]
  if vim.v.shell_error ~= 0 or not branch or branch == "" then
    branch = vim.fn.systemlist({ "git", "-C", file_dir, "rev-parse", "HEAD" })[1]
    if vim.v.shell_error ~= 0 or not branch or branch == "" then return nil end
  end
  branch = vim.trim(branch)

  local relative = abs_path:sub(#git_root + 2)
  return string.format("%s/blob/%s/%s", remote_base, branch, url_encode_path(relative))
end

M.resolve = M.github_url_for

return M
