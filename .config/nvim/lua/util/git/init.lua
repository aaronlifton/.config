---@class util.git
---@field github util.git.github
---@field conflict util.git.conflict
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
    local start_idx = files:find("ERROR", nil, true)
    yadm_cache[dir] = not start_idx
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

---@param file1? string
---@param file2? string
function M.difft(file1, file2)
  if vim.fn.executable("difft") ~= 1 then
    vim.notify("`difft` is not installed or not on PATH", vim.log.levels.ERROR)
    return
  end

  file1 = file1 or vim.trim(vim.fn.getreg("1"))
  file2 = file2 or vim.trim(vim.fn.getreg("2"))
  if file1 == "" or file2 == "" then
    vim.notify("Registers 1 and 2 must contain file paths", vim.log.levels.WARN)
    return
  end

  file1 = vim.fn.expand(file1)
  file2 = vim.fn.expand(file2)
  if vim.fn.filereadable(file1) ~= 1 then
    vim.notify("File from register 1 is not readable: " .. file1, vim.log.levels.ERROR)
    return
  end
  if vim.fn.filereadable(file2) ~= 1 then
    vim.notify("File from register 2 is not readable: " .. file2, vim.log.levels.ERROR)
    return
  end

  vim.cmd("tabnew")
  local cmd = "difft --color=always " .. vim.fn.shellescape(file1) .. " " .. vim.fn.shellescape(file2)
  local job_id = vim.fn.jobstart(vim.o.shell, { term = true })
  if job_id <= 0 then
    vim.notify("Failed to open terminal for difft", vim.log.levels.ERROR)
    return
  end
  local file1_name = vim.fn.fnamemodify(file1, ":h")
  local file2_name = vim.fn.fnamemodify(file2, ":h")
  vim.api.nvim_buf_set_name(0, ("difft://Diff-%s-vs-%s"):format(file1_name, file2_name))
  vim.api.nvim_chan_send(job_id, cmd .. "\n")
  vim.api.nvim_chan_send(job_id, "\n")
  vim.cmd("stopinsert")
  -- Scroll below shell intro text
  vim.api.nvim_input("6<C-e>")
end

-- pcall(vim.api.nvim_del_user_command, "Difft")
vim.api.nvim_create_user_command("Difft", function(opts)
  local args = vim.fn.split(opts.args, "")
  if #args > 0 then
    if #args == 2 then
      M.difft(args[1], args[2])
    else
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file == "" then
        vim.notify("Current buffer has no file path", vim.log.levels.ERROR)
        return
      end
      if #args == 1 then
        M.difft(args[1], current_file)
      else
        local system_register_file = vim.trim(vim.fn.getreg("+"))
        if system_register_file == "" then
          vim.notify("System register (+) is empty", vim.log.levels.ERROR)
          return
        end
        M.difft(system_register_file, current_file)
      end
    end
    return
  end
  M.difft()
end, {
  nargs = "?",
  desc = "Run difft on files from registers 1/2, or current file vs system register (+) when argument is provided",
})

require("util.git.conflict").setup()

return M
