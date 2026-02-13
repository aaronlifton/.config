---@class util.git.conflict
local M = {}

local function merge_in_progress()
  vim.fn.system({ "git", "rev-parse", "-q", "--verify", "MERGE_HEAD" })
  return vim.v.shell_error == 0
end

function M.conflicts_to_qflist()
  if not merge_in_progress() then
    vim.notify("No merge in progress", vim.log.levels.INFO, { title = "Git Conflict" })
    return
  end

  local files = vim.fn.systemlist({ "git", "diff", "--name-only", "--diff-filter=U" })
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to read git conflicts", vim.log.levels.ERROR, { title = "Git Conflict" })
    return
  end

  if #files == 0 then
    vim.notify("No unresolved conflicts", vim.log.levels.INFO, { title = "Git Conflict" })
    return
  end

  local qf_items = {}
  for _, file in ipairs(files) do
    qf_items[#qf_items + 1] = {
      filename = file,
      lnum = 1,
      col = 1,
      text = "Unresolved merge conflict",
    }
  end

  vim.fn.setqflist({}, " ", {
    title = "Git Merge Conflicts",
    items = qf_items,
  })
  vim.cmd("copen")
end

function M.setup()
  vim.api.nvim_create_user_command("GitConflictQf", function()
    -- Use git-conflict.nvim to register conflict locations so that when the file
    -- is opened, the conflict UI is displayed.
    vim.api.nvim_input("<Space>gCl")

    require("util.git.conflict").conflicts_to_qflist()
  end, { desc = "Send Git Conflicts to Quickfix" })
end

return M
