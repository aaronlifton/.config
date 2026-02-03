---@class util.picker
local M = {}

function M.node_modules_dir()
  local path = vim.fs.joinpath(LazyVim.root(), "node_modules")
  if vim.fn.isdirectory(path) == 0 then
    vim.notify("node_modules directory not found: " .. path, vim.log.levels.WARN)
    return nil
  end
  return path
end

function M.node_module_subdir()
  local cwd = vim.fn.expand("%:p:h")
  local start = string.find(cwd, "node_modules/")
  if start then
    local display = vim.fn.fnamemodify(cwd, ":t")
    return { path = cwd, display = display }
  end
  vim.api.nvim_echo({ { "Not a path within a node_modules folder", "Normal" } }, false, {})
  return nil
end

local gem = "ruby-lsp" -- rails
function M.gem_dir(callback)
  local function handle_output(stdout, code, stderr)
    if code ~= 0 then
      vim.api.nvim_echo({ { ("Error getting gem path: %s"):format(stderr), "Error" } }, true, {})
      return
    end
    local path = stdout:match("^(.-)\n")
    if not path or path == "" then
      vim.api.nvim_echo({ { "Could not find ruby-lsp gem path", "Error" } }, true, {})
      return
    end
    path = vim.fn.fnamemodify(path, ":h")
    local gems_dir = vim.fn.fnamemodify(path, ":~:h:h")
    callback(path, gems_dir)
  end

  vim.system({ "bundle", "show", gem }, { text = true }, function(res)
    vim.schedule(function()
      handle_output(res.stdout, res.code, res.stderr)
    end)
  end)
end

return M
