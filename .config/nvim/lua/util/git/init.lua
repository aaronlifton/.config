---@class util.git
---@field github util.git.github
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

local yadm_cache = {} ---@type table<string, boolean>
local function is_yadm_root(dir)
  if not dir then return false end

  if yadm_cache[dir] == nil then
    local files = vim.fn.system({ "yadm", "ls-files", dir })
    yadm_cache[dir] = files ~= ""
  end
  return yadm_cache[dir]
end

--- Adapted from lazy/snacks.nvim/lua/snacks/git.lua to support YADM
--- Show git log for the current line.
---@param opts? snacks.terminal.Opts | {count?: number}
function M.blame_line(opts)
  opts = vim.tbl_deep_extend("force", {
    count = 5,
    interactive = false,
    win = { style = "blame_line" },
  }, opts or {})
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local file = vim.api.nvim_buf_get_name(0)
  local root = Snacks.git.get_root()
  local git = "git"
  if is_yadm_root(root) then git = "yadm" end
  local cmd = { git, "-C", root, "log", "-n", opts.count, "-u", "-L", line .. ",+1:" .. file }
  return Snacks.terminal(cmd, opts)
end

-- Gets the github URL via remote.
-- https://github.com/spider-rs/spider/blob/main/spider_cli/src/main.rs#L13
function M.get_github_url_via_remote()
  local git = "git"
  local root = Snacks.git.get_root()
  if is_yadm_root(root) then git = "yadm" end
  local remote = vim.fn.system({ git, "-C", root, "config", "--get", "remote.origin.url" }):gsub("\n", "")
  if remote == "" then return nil, "No remote found" end

  -- Convert SSH URL to HTTPS URL
  local https_url
  if remote:match("^git@") then
    -- SSH format: git@github.com:user/repo.git
    https_url = remote:gsub("git@([^:]+):", "https://%1/"):gsub("%.git$", "")
  elseif remote:match("^https://") then
    -- Already HTTPS format
    https_url = remote:gsub("%.git$", "")
  else
    return nil, "Unsupported remote URL format"
  end

  return https_url
end

function M.get_github_codeview_url_for_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local file = vim.api.nvim_buf_get_name(0)
  local root = Snacks.git.get_root()
  local git = "git"
  if is_yadm_root(root) then git = "yadm" end
  local branch = vim.fn.system({ git, "-C", root, "rev-parse", "--abbrev-ref", "HEAD" }):gsub("\n", "")
  if branch == "" then return nil, "Could not determine current branch" end

  local relative_path = file:sub(#root + 2) -- +2 to account for the trailing slash

  local remote_url, err = M.get_github_url_via_remote()
  if not remote_url then return nil, err end

  -- Construct the GitHub URL
  local github_url = string.format("%s/blob/%s/%s#L%d", remote_url, branch, relative_path, line)
  return github_url
end

function M.get_github_codeview_url_for_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local file = vim.api.nvim_buf_get_name(0)
  local root = Snacks.git.get_root()
  local git = "git"
  if is_yadm_root(root) then git = "yadm" end
  local branch = vim.fn.system({ git, "-C", root, "rev-parse", "--abbrev-ref", "HEAD" }):gsub("\n", "")
  if branch == "" then return nil, "Could not determine current branch" end

  local relative_path = file:sub(#root + 2) -- +2 to account for the trailing slash

  local remote_url, err = M.get_github_url_via_remote()
  if not remote_url then return nil, err end

  -- Construct the GitHub URL
  local github_url = string.format("%s/blob/%s/%s#L%d", remote_url, branch, relative_path, line)
  return github_url
end

return M
