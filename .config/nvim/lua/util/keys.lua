--- Keys utils
---@class util.keys
---@field type_keys fun(keys: string, flags: string): nil
local M = {}

function M.type_keys(keys, flags)
  -- stylua: ignore
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, false, true),
    flags or 'x',
    false
  )
  -- stylua: ignore end
end

---@param buf number
---@param keys table
function M.buf_set_keymap(buf, keys)
  for _, key in ipairs(keys) do
    local mode, lhs, rhs, opts = unpack(key)
    for _, m in ipairs(mode) do
      vim.api.nvim_buf_set_keymap(buf, m, lhs, rhs, opts)
    end
  end
end

---@param buf number
---@param keys table
function M.buf_clear_keymap(buf, keys)
  if not vim.api.nvim_buf_is_valid(buf) then return end

  if not vim.bo[buf].buflisted then return end

  for _, key in ipairs(keys) do
    local mode, lhs, _, _ = unpack(key)
    if type(mode) == "string" then mode = { mode } end
    for _, m in ipairs(mode) do
      -- vim.api.nvim_buf_del_keymap(buf, m, lhs)
      pcall(vim.api.nvim_buf_del_keymap, buf, m, lhs)
    end
  end
end

-- ---@param buf number
-- ---@param keys table
-- No need to pcall nvim_buf_get_keymap first
-- function M.clear_keymaps(buf, keys)
--   if not vim.api.nvim_buf_is_valid(buf) then return end
--
--   if not vim.bo[buf].buflisted then return end
--
--   for _, key in ipairs(keys) do
--     local ok, keymap = pcall(vim.api.nvim_buf_get_keymap, buf, "n")
--     if ok then
--       local has_keymap = vim.iter(keymap):any(function(k)
--         return vim.trim(k.lhs) == key[1]
--       end)
--       if has_keymap then vim.api.nvim_buf_del_keymap(buf, "n", key[1]) end
--     end
--   end
-- end

function M.list_buffer_mappings()
  local modes = { "n", "v", "x", "s", "o", "i", "l", "c", "t" }
  local lines = {}

  for _, mode in ipairs(modes) do
    -- Get buffer-local mappings for the current mode
    local mappings = vim.api.nvim_buf_get_keymap(0, mode)

    if #mappings > 0 then
      table.insert(lines, string.format("--- %s mode ---", mode))

      for _, mapping in ipairs(mappings) do
        local lhs = mapping.lhs or ""
        local rhs = mapping.rhs or ""
        local desc = mapping.desc or ""

        -- Format the mapping information
        local line = string.format("%s -> %s", lhs, rhs)
        if desc ~= "" then line = line .. string.format(" (%s)", desc) end

        table.insert(lines, line)
      end

      table.insert(lines, "")
    end
  end

  if #lines > 0 then
    -- Remove the last empty line
    table.remove(lines)
    -- Echo the results
    vim.api.nvim_echo({ { table.concat(lines, "\n"), "Normal" } }, true, {})
  else
    vim.api.nvim_echo({ { "No buffer-local mappings found", "WarningMsg" } }, true, {})
  end
end
return M
