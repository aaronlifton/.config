local M = {
  branch_cache = {},
}

local function is_valid_git_repo(buf_id)
  -- Check if it's a valid buffer
  local path = vim.api.nvim_buf_get_name(buf_id)
  if path == "" or vim.fn.filereadable(path) ~= 1 then return false end

  -- Check if the current directory is a Git repository
  if vim.fn.isdirectory(".git") == 0 then return false end

  return true
end

-- Function to clear the Git branch cache
function M.clear_git_branch_cache()
  -- Clear by doing an empty table :)
  M.branch_cache = {}
end

local function update_git_branch(data)
  if not is_valid_git_repo(data.buf) then return end

  -- Check if branch is already cached
  local cached_branch = branch_cache[data.buf]
  if cached_branch then
    vim.b.git_branch = cached_branch
    return
  end

  local stdout = vim.uv.new_pipe()
  -- local stderr = vim.uv.new_pipe()
  local handle, pid
  handle, pid = vim.uv.spawn(
    "git",
    ---@diagnostic disable-next-line: missing-fields
    {
      args = { "-C", vim.fn.expand("%:p:h"), "branch", "--show-current" },
      env = {},
      stdio = { nil, stdout, nil },
      -- cwd = vim.fn.expand("%:p:h"), -- Use the directory of the current file
      -- -- NOTE: the following 2 functions are not libuv functions and are not
      -- -- supported on Windows.
      -- uid = string(vim.uv.getuid()),
      -- gid = string(vim.fn.getgid()),
      -- verbatim = true,
      -- detached = false,
      -- -- On Unix this is ignored, but meanginful on Windows.
      -- hide = false,
    },
    vim.schedule_wrap(function(code, signal)
      if code == 0 then
        -- vim.uv.read_start(stdout, function(err, content)
        --   if err then
        --     vim.notify("Error reading Git branch: " .. err, vim.log.levels.ERROR)
        --     return
        --   end
        --   if content and content ~= "" then
        --     vim.b.git_branch = content:gsub("\n", "") -- Remove newline character
        --     branch_cache[data.buf] = vim.b.git_branch -- Cache the branch name
        --   else
        --     vim.b.git_branch = "No branch"
        --     branch_cache[data.buf] = "No branch" -- Cache the no branch state
        --   end
        --   Util.async.close_handle(stdout)
        --   Util.async.close_handle(handle)
        -- end)
        stdout:read_start(function(err, content)
          if content then
            vim.b.git_branch = content:gsub("\n", "") -- Remove newline character
            branch_cache[data.buf] = vim.b.git_branch -- Cache the branch name
            Util.async.close_handle(stdout)
            Util.async.close_handle(handle)
          end
        end)
      else
        Util.async.close_handle(stdout)
        Util.async.close_handle(handle)
      end
    end)
  )
end

function M.setup()
  -- Call this function when the buffer is opened in a window
  vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = update_git_branch,
  })

  -- Autocommand to clear the Git branch cache when the directory changes
  vim.api.nvim_create_autocmd("DirChanged", {
    callback = M.clear_git_branch_cache,
  })
end

return M
