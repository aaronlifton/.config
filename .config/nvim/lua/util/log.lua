---@class util.log
local M = {}

-- Create logs directory if it doesn't exist
local log_dir = vim.fn.stdpath("data") .. "/user_logs"
vim.fn.mkdir(log_dir, "p")

---Write content to file asynchronously
---@param filename string
---@param content string
local function write(filename, content)
  local file = io.open(filename, "a")
  if not file then
    vim.notify("Failed to open log file: " .. filename, vim.log.levels.ERROR)
    return
  end

  -- Create a temporary file handle
  file:write(content .. "\n")
  file:close()
end

---Log an object to a specific named log file
---@param name string The name of the log file
---@param obj any The object to log
---@param opts? {timestamp?: boolean} Optional settings
function M.log(name, obj, opts)
  opts = opts or {}
  local filename = log_dir .. "/" .. name .. ".json"

  -- Create log entry
  local entry = obj
  if opts.timestamp ~= false then entry = {
    timestamp = os.time(),
    data = obj,
  } end

  -- Convert to JSON and write asynchronously
  local inspected_str = vim.inspect(entry)
  vim.schedule(function()
    write(filename, inspected_str)
  end)
end

---Clear a specific log file
---@param name string The name of the log file to clear
function M.clear(name)
  local filename = log_dir .. "/" .. name .. ".json"
  local file = io.open(filename, "w")
  if file then file:close() end
end

---Get the full path to a log file
---@param name string The name of the log file
---@return string
function M.get_log_path(name)
  return log_dir .. "/" .. name .. ".json"
end

return M
