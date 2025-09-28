-- Root Spec Modifier Utility
--
-- Provides a flexible API for registering custom root detectors and inserting them
-- into LazyVim's root detection spec at desired positions.
--
-- Usage:
--   local modifier = require("util.lazy.root_spec_modifier")
--   
--   modifier.register_detector("my_detector", my_detector_function)
--   modifier.insert_after("lsp", "my_detector")
--   modifier.apply()

---@class RootSpecModifier
local M = {}

-- Get the LazyVim root utility
local root_util = require("lazyvim.util.root")

-- Store pending modifications
local pending_detectors = {}
local pending_insertions = {}

---Register a custom detector function
---@param name string The name for the detector
---@param detector_func function The detector function that takes (buf) and returns string[]
function M.register_detector(name, detector_func)
  if type(name) ~= "string" or name == "" then
    error("Detector name must be a non-empty string")
  end
  
  if type(detector_func) ~= "function" then
    error("Detector must be a function")
  end
  
  pending_detectors[name] = detector_func
end

---Insert a detector after a specific position in the spec
---@param after string|number The detector name or index to insert after
---@param detector_name string The name of the detector to insert
function M.insert_after(after, detector_name)
  table.insert(pending_insertions, {
    type = "after",
    reference = after,
    detector = detector_name
  })
end

---Insert a detector before a specific position in the spec
---@param before string|number The detector name or index to insert before
---@param detector_name string The name of the detector to insert
function M.insert_before(before, detector_name)
  table.insert(pending_insertions, {
    type = "before",
    reference = before,
    detector = detector_name
  })
end

---Insert a detector at the beginning of the spec
---@param detector_name string The name of the detector to insert
function M.insert_at_start(detector_name)
  table.insert(pending_insertions, {
    type = "start",
    detector = detector_name
  })
end

---Insert a detector at the end of the spec
---@param detector_name string The name of the detector to insert
function M.insert_at_end(detector_name)
  table.insert(pending_insertions, {
    type = "end",
    detector = detector_name
  })
end

---Insert a detector at a specific index
---@param index number The index to insert at (1-based)
---@param detector_name string The name of the detector to insert
function M.insert_at_index(index, detector_name)
  table.insert(pending_insertions, {
    type = "index",
    reference = index,
    detector = detector_name
  })
end

---Find the index of a detector in a spec
---@param spec table The spec to search in
---@param reference string|number The detector name or index to find
---@return number|nil The index if found, nil otherwise
local function find_reference_index(spec, reference)
  if type(reference) == "number" then
    return reference
  end
  
  for i, item in ipairs(spec) do
    if item == reference then
      return i
    end
  end
  
  return nil
end

---Apply a single insertion to a spec
---@param spec table The spec to modify
---@param insertion table The insertion configuration
---@return boolean Whether the insertion was successful
local function apply_insertion(spec, insertion)
  local detector = insertion.detector
  
  if insertion.type == "start" then
    table.insert(spec, 1, detector)
    return true
  elseif insertion.type == "end" then
    table.insert(spec, detector)
    return true
  elseif insertion.type == "index" then
    local index = insertion.reference
    if index < 1 or index > #spec + 1 then
      vim.notify(
        string.format("Invalid index %d for detector %s (spec has %d items)", index, detector, #spec),
        vim.log.levels.WARN
      )
      return false
    end
    table.insert(spec, index, detector)
    return true
  elseif insertion.type == "after" then
    local ref_index = find_reference_index(spec, insertion.reference)
    if not ref_index then
      vim.notify(
        string.format("Reference '%s' not found for detector %s", insertion.reference, detector),
        vim.log.levels.WARN
      )
      return false
    end
    table.insert(spec, ref_index + 1, detector)
    return true
  elseif insertion.type == "before" then
    local ref_index = find_reference_index(spec, insertion.reference)
    if not ref_index then
      vim.notify(
        string.format("Reference '%s' not found for detector %s", insertion.reference, detector),
        vim.log.levels.WARN
      )
      return false
    end
    table.insert(spec, ref_index, detector)
    return true
  end
  
  return false
end

---Apply all pending modifications to the root spec
function M.apply()
  -- Register all pending detectors
  for name, func in pairs(pending_detectors) do
    root_util.detectors[name] = func
  end
  
  -- Get the current spec (either user customized or default)
  local current_spec
  if vim.g.root_spec then
    current_spec = vim.deepcopy(vim.g.root_spec)
  else
    current_spec = vim.deepcopy(root_util.spec)
  end
  
  -- Apply all insertions in order
  for _, insertion in ipairs(pending_insertions) do
    apply_insertion(current_spec, insertion)
  end
  
  -- Update both the root_util.spec and vim.g.root_spec
  root_util.spec = current_spec
  vim.g.root_spec = current_spec
  
  -- Clear pending modifications
  pending_detectors = {}
  pending_insertions = {}
end

---Reset all pending modifications without applying them
function M.reset()
  pending_detectors = {}
  pending_insertions = {}
end

---Get the current pending modifications (for debugging)
---@return table
function M.get_pending()
  return {
    detectors = vim.deepcopy(pending_detectors),
    insertions = vim.deepcopy(pending_insertions)
  }
end

---Fluent interface for chaining operations
---@class RootSpecBuilder
local Builder = {}
Builder.__index = Builder

function Builder:register(name, detector_func)
  M.register_detector(name, detector_func)
  return self
end

function Builder:after(after, detector_name)
  M.insert_after(after, detector_name)
  return self
end

function Builder:before(before, detector_name)
  M.insert_before(before, detector_name)
  return self
end

function Builder:at_start(detector_name)
  M.insert_at_start(detector_name)
  return self
end

function Builder:at_end(detector_name)
  M.insert_at_end(detector_name)
  return self
end

function Builder:at_index(index, detector_name)
  M.insert_at_index(index, detector_name)
  return self
end

function Builder:apply()
  M.apply()
  return self
end

function Builder:reset()
  M.reset()
  return self
end

---Create a new builder instance for fluent interface
---@return RootSpecBuilder
function M.builder()
  return setmetatable({}, Builder)
end

---Convenience function for the most common use case: register and insert after
---@param name string The detector name
---@param detector_func function The detector function
---@param after string The detector to insert after
function M.register_and_insert_after(name, detector_func, after)
  M.register_detector(name, detector_func)
  M.insert_after(after, name)
  M.apply()
end

---Convenience function for the most common use case: register and insert before
---@param name string The detector name
---@param detector_func function The detector function
---@param before string The detector to insert before
function M.register_and_insert_before(name, detector_func, before)
  M.register_detector(name, detector_func)
  M.insert_before(before, name)
  M.apply()
end

return M
