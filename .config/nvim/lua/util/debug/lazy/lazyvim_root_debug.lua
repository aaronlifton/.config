-- LazyVim Root Detector Debug Extension
-- This module extends LazyVim's root detection functionality with debugging capabilities

---@class lazyvim.util.root.debug
local M = {}

-- Reference to the original LazyVim root module
local root_util = require("lazyvim.util.root")

---@param opts? { buf?: number, spec?: LazyRootSpec[] }
---@return table<string, string[]>
local function get_detector_outputs(opts)
  opts = opts or {}
  opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or root_util.spec
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

  local outputs = {} ---@type table<string, string[]>

  for _, spec in ipairs(opts.spec) do
    local detector_name
    local paths

    if type(spec) == "string" then
      detector_name = spec
      paths = root_util.resolve(spec)(opts.buf)
    elseif type(spec) == "table" then
      detector_name = table.concat(spec, ", ")
      paths = root_util.resolve(spec)(opts.buf)
    elseif type(spec) == "function" then
      detector_name = "function"
      paths = spec(opts.buf)
    else
      detector_name = tostring(spec)
      paths = root_util.resolve(spec)(opts.buf)
    end

    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }

    -- Normalize and filter valid paths
    local normalized_paths = {}
    for _, p in ipairs(paths) do
      local pp = root_util.realpath(p)
      if pp then normalized_paths[#normalized_paths + 1] = pp end
    end

    outputs[detector_name] = normalized_paths
  end

  return outputs
end

---@param opts? { buf?: number, spec?: LazyRootSpec[] }
function M.show_detector_outputs(opts)
  local outputs = get_detector_outputs(opts)

  local lines = {} ---@type string[]
  lines[#lines + 1] = "# LazyVim Root Detector Outputs"
  lines[#lines + 1] = ""

  for detector_name, paths in pairs(outputs) do
    lines[#lines + 1] = ("## %s"):format(detector_name)
    if #paths == 0 then
      lines[#lines + 1] = "  (no paths found)"
    else
      for _, path in ipairs(paths) do
        lines[#lines + 1] = ("  - `%s`"):format(path)
      end
    end
    lines[#lines + 1] = ""
  end

  -- Show current root for comparison
  local current_root = root_util.get()
  lines[#lines + 1] = ("**Current selected root:** `%s`"):format(current_root)

  LazyVim.info(lines, { title = "LazyVim Root Detector Debug" })
end

-- Add a user command for easy access
vim.api.nvim_create_user_command("LazyRootDebug", function()
  M.show_detector_outputs()
end, { desc = "Show output from all LazyVim root detectors" })

--- Public debug function
--- require("util.debug.lazy.lazyvim_root_debug").debug()
function M.debug()
  -- Example usage of the debug module
  M.show_detector_outputs() -- Show outputs for the current buffer with default spec
  -- Or specify a different buffer and custom spec
  -- M.show_detector_outputs({ buf = 5, spec = { "lsp", "pattern" } })
  local root_debug = require("lazyvim_root_debug")

  -- Test with current buffer
  local outputs = root_debug.get_detector_outputs()
  print(vim.inspect(outputs))

  -- Test with specific buffer
  local outputs_buf = root_debug.get_detector_outputs({ buf = 1 })
  print(vim.inspect(outputs_buf))

  -- Test with custom spec
  local custom_outputs = root_debug.get_detector_outputs({
    spec = { "lsp", { ".git" }, "cwd" },
  })
  print(vim.inspect(custom_outputs))
end

return M
