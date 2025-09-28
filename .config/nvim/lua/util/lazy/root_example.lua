-- Example: How to use the Root Spec Modifier Utility
-- This shows how your current root.lua setup function would look using the abstraction

---@class ConfigSubdirDetectorExample
local M = {}

-- Get the LazyVim root utility
local root_util = require("lazyvim.util.root")

---@param buf number
---@return string[]
function M.detector(buf)
  local bufpath = root_util.bufpath(buf)
  if not bufpath then return {} end

  -- Get the home directory and construct ~/.config path
  local home = vim.uv.os_homedir()
  if not home then return {} end

  local config_dir = home .. "/.config"
  local normalized_config = root_util.realpath(config_dir)
  if not normalized_config then return {} end

  -- Check if we're in a subdirectory of ~/.config
  local normalized_bufpath = root_util.realpath(bufpath)
  if not normalized_bufpath then return {} end

  -- Check if buffer path starts with ~/.config/
  if not normalized_bufpath:find(normalized_config, 1, true) then return {} end

  -- Don't handle if we're directly in ~/.config (let normal detectors handle it)
  if normalized_bufpath == normalized_config then return {} end

  -- Check if LSP detector would return any roots
  local lsp_roots = root_util.detectors.lsp(buf)
  if lsp_roots and #lsp_roots > 0 then
    -- LSP has roots, let it handle detection
    return {}
  end

  -- We're in a ~/.config subdirectory and LSP has no roots
  -- Use the current working directory as the root
  local cwd = vim.uv.cwd()
  if cwd then
    local normalized_cwd = root_util.realpath(cwd)
    if normalized_cwd then
      -- Only use cwd if it's also under ~/.config
      if normalized_cwd:find(normalized_config, 1, true) then return { normalized_cwd } end
    end
  end

  -- Fallback: use the directory containing the buffer
  local buffer_dir = vim.fs.dirname(normalized_bufpath)
  if buffer_dir then return { buffer_dir } end

  return {}
end

-- BEFORE: Complex setup function with manual spec manipulation
function M.setup_old_way()
  -- Add our custom detector to the detectors table
  root_util.detectors.config_subdir = M.detector

  -- Monkey-patch the spec to include our detector with higher precedence
  local original_spec = root_util.spec
  root_util.spec = { "lsp", "config_subdir", { ".git", "lua" }, "cwd" }

  -- Also update the global spec if it exists
  if vim.g.root_spec then
    -- If user has customized root_spec, we need to be more careful
    -- Insert our detector after lsp but before other patterns
    local custom_spec = vim.deepcopy(vim.g.root_spec)
    local lsp_index = nil

    -- Find where "lsp" is in the spec
    for i, spec in ipairs(custom_spec) do
      if spec == "lsp" then
        lsp_index = i
        break
      end
    end

    if lsp_index then
      -- Insert our detector right after lsp
      table.insert(custom_spec, lsp_index + 1, "config_subdir")
    else
      -- If no lsp found, insert at the beginning
      table.insert(custom_spec, 1, "config_subdir")
    end

    vim.g.root_spec = custom_spec
  else
    -- Set our custom spec as the global one
    vim.g.root_spec = root_util.spec
  end

  -- Optional: Add a command to test the detector
  vim.api.nvim_create_user_command("TestConfigSubdirDetector", function()
    local buf = vim.api.nvim_get_current_buf()
    local result = M.detector(buf)
    local bufpath = root_util.bufpath(buf) or "nil"
    local current_root = root_util.get()

    local lines = {
      "# Config Subdir Detector Test",
      "",
      ("**Buffer path:** `%s`"):format(bufpath),
      ("**Current root:** `%s`"):format(current_root),
      ("**Detector result:** `%s`"):format(vim.inspect(result)),
      "",
      "**Current spec:**",
      "```lua",
      vim.inspect(type(vim.g.root_spec) == "table" and vim.g.root_spec or root_util.spec),
      "```",
    }

    LazyVim.info(lines, { title = "Config Subdir Detector Test" })
  end, { desc = "Test the config subdirectory detector" })
end

-- AFTER: Simple setup using the abstracted utility
function M.setup()
  local modifier = require("util.lazy.root_spec_modifier")
  
  -- Method 1: Simple convenience function (most common use case)
  modifier.register_and_insert_after("config_subdir", M.detector, "lsp")
  
  -- Optional: Add the test command
  vim.api.nvim_create_user_command("TestConfigSubdirDetector", function()
    local buf = vim.api.nvim_get_current_buf()
    local result = M.detector(buf)
    local bufpath = root_util.bufpath(buf) or "nil"
    local current_root = root_util.get()

    local lines = {
      "# Config Subdir Detector Test",
      "",
      ("**Buffer path:** `%s`"):format(bufpath),
      ("**Current root:** `%s`"):format(current_root),
      ("**Detector result:** `%s`"):format(vim.inspect(result)),
      "",
      "**Current spec:**",
      "```lua",
      vim.inspect(type(vim.g.root_spec) == "table" and vim.g.root_spec or root_util.spec),
      "```",
    }

    LazyVim.info(lines, { title = "Config Subdir Detector Test" })
  end, { desc = "Test the config subdirectory detector" })
end

-- Alternative approaches using the abstraction:

function M.setup_alternative_1()
  local modifier = require("util.lazy.root_spec_modifier")
  
  -- Method 2: Step by step
  modifier.register_detector("config_subdir", M.detector)
  modifier.insert_after("lsp", "config_subdir")
  modifier.apply()
end

function M.setup_alternative_2()
  local modifier = require("util.lazy.root_spec_modifier")
  
  -- Method 3: Fluent interface
  modifier.builder()
    :register("config_subdir", M.detector)
    :after("lsp", "config_subdir")
    :apply()
end

function M.setup_multiple_detectors()
  local modifier = require("util.lazy.root_spec_modifier")
  
  -- Method 4: Multiple detectors at once
  modifier.register_detector("config_subdir", M.detector)
  modifier.register_detector("another_detector", function(buf) return {} end)
  
  modifier.insert_after("lsp", "config_subdir")
  modifier.insert_after("config_subdir", "another_detector")
  
  modifier.apply()
end

function M.setup_complex_positioning()
  local modifier = require("util.lazy.root_spec_modifier")
  
  -- Method 5: Complex positioning options
  modifier.register_detector("high_priority", function(buf) return {} end)
  modifier.register_detector("low_priority", function(buf) return {} end)
  
  modifier.insert_at_start("high_priority")  -- Insert at beginning
  modifier.insert_after("lsp", "config_subdir")  -- Insert after lsp
  modifier.insert_at_end("low_priority")  -- Insert at end
  
  modifier.apply()
end

return M
