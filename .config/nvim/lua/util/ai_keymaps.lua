-- Utility module to programmatically generate keymaps from ai_config
---@diagnostic disable: undefined-global
local M = {}

-- Function to generate keymaps from ai_config
-- @param ai_config The ai_config table with custom_textobjects
-- @param opts Optional configuration options
--   - mode: The mode for the keymaps (default: "o")
--   - prefix: The prefix for the keymaps (default: "")
--   - buffer: Whether to make the keymaps buffer-local (default: true)
function M.generate_keymaps(ai_config, opts)
  if not ai_config or not ai_config.custom_textobjects then
    vim.notify("No custom_textobjects found in ai_config", vim.log.levels.WARN)
    return
  end

  opts = opts or {}
  local mode = opts.mode or "o"
  local prefix = opts.prefix or ""
  local buffer = opts.buffer ~= nil and opts.buffer or true
  local keymaps = {}

  -- Iterate through each custom textobject and create keymaps
  for key, spec in pairs(ai_config.custom_textobjects) do
    -- Skip if the key is longer than 1 character (for complex keys)
    if #key == 1 then
      -- Create keymap for both 'a' and 'i' variants
      local a_mapping = prefix .. "a" .. key
      local i_mapping = prefix .. "i" .. key
      
      -- Get description from the spec if available
      local desc = nil
      if type(spec) == "table" and spec.desc then
        desc = spec.desc
      else
        desc = "Custom textobject " .. key
      end
      
      -- Create the keymaps
      vim.keymap.set(mode, a_mapping, "a" .. key, {
        buffer = buffer and 0 or nil,
        desc = "Around " .. desc
      })
      
      vim.keymap.set(mode, i_mapping, "i" .. key, {
        buffer = buffer and 0 or nil,
        desc = "Inside " .. desc
      })
      
      -- Store the created keymaps for reference
      keymaps[a_mapping] = "Around " .. desc
      keymaps[i_mapping] = "Inside " .. desc
    end
  end
  
  return keymaps
end

-- Function to generate keymaps from the buffer-local miniai_config
-- This can be called in an ftplugin file
function M.generate_buffer_keymaps(opts)
  if not vim.b.miniai_config then
    vim.notify("No miniai_config found for this buffer", vim.log.levels.WARN)
    return
  end
  
  return M.generate_keymaps(vim.b.miniai_config, opts)
end

-- Function to generate keymaps from the global mini.ai config
function M.generate_global_keymaps(opts)
  local ok, mini_ai = pcall(require, "mini.ai")
  if not ok then
    vim.notify("mini.ai is not available", vim.log.levels.WARN)
    return
  end
  
  local config = mini_ai.get_config()
  return M.generate_keymaps({ custom_textobjects = config.custom_textobjects }, opts)
end

return M

