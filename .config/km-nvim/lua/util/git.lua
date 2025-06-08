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

return M
