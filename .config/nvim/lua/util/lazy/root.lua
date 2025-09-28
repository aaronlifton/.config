-- Custom LazyVim Root Detector for ~/.config Subdirectories
--
-- Problem: When editing files in ~/.config/kitty (or other ~/.config subdirs),
-- LazyVim finds .git in ~/.config and sets that as root instead of ~/.config/kitty
--
-- Solution: This detector has higher precedence and uses cwd when:
-- 1. We're in a subdirectory of ~/.config
-- 2. LSP detector returns no roots
-- 3. We're not directly in ~/.config itself

---@class ConfigSubdirDetector
local M = {
  debug = false,
}

local notify = function(msg, level)
  if M.debug then vim.notify(msg, level or vim.log.levels.INFO, { title = "ConfigSubdirDetector" }) end
end

-- Get the LazyVim root utility
local root_util = require("lazyvim.util.root")

local outside_config_dirs = {
  "hammerspoon",
}

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

  -- Check if we're in a special outside config directory
  for _, dir in ipairs(outside_config_dirs) do
    config_dir = normalized_bufpath:match(string.format("(.*/%s)", dir))

    if config_dir then return { config_dir } end
  end
  -- if normalized_bufpath:find("hammerspoon", 1, true) then
  --   local hammerspoon_dir = normalized_bufpath:match("(.*/hammerspoon)")
  --   -- Special case: if editing in hammerspoon config, use its directory as root
  --   if hammerspoon_dir then return { hammerspoon_dir } end
  -- end

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

-- Register the custom detector
function M.setup()
  -- Add our custom detector to the detectors table
  root_util.detectors.config_subdir = M.detector

  -- Monkey-patch the spec to include our detector with higher precedence
  local original_spec = root_util.spec
  root_util.spec = { "lsp", "config_subdir", { ".git", "lua" }, "cwd" }

  LazyVim.on_very_lazy(function()
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
        notify("Found lsp index, inserting config_subdir after it", { level = vim.log.levels.DEBUG })
        table.insert(custom_spec, lsp_index + 1, "config_subdir")
      else
        -- If no lsp found, insert at the beginning
        notify("Inserting config_subdir at start of root_spec", { level = vim.log.levels.DEBUG })
        table.insert(custom_spec, 1, "config_subdir")
      end

      vim.g.root_spec = custom_spec
    else
      -- Set our custom spec as the global one
      notify(
        "No vim.g.root_spec found, so setting root_spec to custom one with config_subdir",
        { level = vim.log.levels.DEBUG }
      )
      vim.g.root_spec = root_util.spec
    end

    if M.debug then
      LazyVim.info({
        "**Current spec:**",
        "```lua",
        vim.inspect(type(vim.g.root_spec) == "table" and vim.g.root_spec or root_util.spec),
        "```",
      }, { title = "Root Detector" })
    end
  end)

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

return M
