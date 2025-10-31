-- TOML Table Converter
-- Converts multi-line TOML tables to inline format
-- Usage: Place cursor anywhere within a TOML table and run :TomlInline
local M = {}

-- Function to convert TOML multi-line table to inline format
function M.convert_to_inline()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local start_line = cursor_pos[1]

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Find the start of the TOML table
  local table_start = nil
  local table_end = nil

  -- Look backwards from cursor to find table start
  for i = start_line, 1, -1 do
    if lines[i] and lines[i]:match("^%[%[.*%]%]") then
      table_start = i
      break
    end
  end

  if not table_start then
    vim.notify("No TOML table header found above cursor", vim.log.levels.WARN)
    return
  end

  -- Find the end of the table
  for i = table_start + 1, #lines do
    if not lines[i] or lines[i]:match("^%s*$") or lines[i]:match("^%[") then
      table_end = i - 1
      break
    end
  end

  if not table_end then table_end = #lines end

  -- Extract key-value pairs with proper formatting
  local pairs = {}
  for i = table_start + 1, table_end do
    local line = lines[i]
    if line and line:match("%S") then
      -- Handle different spacing patterns
      local key, value = line:match("^%s*([%w_]+)%s*=%s*(.+)%s*$")
      if key and value then
        -- Clean up the value (remove trailing whitespace)
        value = value:gsub("%s+$", "")
        -- Preserve original spacing for readability
        if key == "on" then
          table.insert(pairs, "on   = " .. value)
        else
          table.insert(pairs, key .. "  = " .. value)
        end
      end
    end
  end

  if #pairs == 0 then
    vim.notify("No key-value pairs found in table", vim.log.levels.WARN)
    return
  end

  -- Create the inline format with proper spacing
  local inline = "{ " .. table.concat(pairs, ", ") .. " }"

  -- Replace the multi-line table with inline format
  vim.api.nvim_buf_set_lines(bufnr, table_start - 1, table_end, false, { inline })

  vim.notify("Converted TOML table to inline format", vim.log.levels.INFO)
end

-- Function to convert inline table back to multi-line (reverse operation)
-- Before:
-- [mgr.prepend_keymap] = { key1 = 'value1', key2 = 'value2' }
-- After:
-- [[mgr.prepend_keymap]]
-- key1 = 'value1'
-- key2 = 'value2'
function M.convert_to_multiline()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor_pos[1]

  local lines = vim.api.nvim_buf_get_lines(bufnr, line_num - 1, line_num, false)
  local line = lines[1]

  if not line or not line:match("^%s*{.*}%s*$") then
    vim.notify("No inline table found on current line", vim.log.levels.WARN)
    return
  end

  -- Extract content between braces
  local content = line:match("{%s*(.-)%s*}")
  if not content then
    vim.notify("Invalid inline table format", vim.log.levels.ERROR)
    return
  end

  -- Split by comma and create multi-line format
  local new_lines = { "[[mgr.prepend_keymap]]" }

  -- Simple split by comma (this could be improved for complex cases)
  for pair in content:gmatch("[^,]+") do
    pair = pair:gsub("^%s+", ""):gsub("%s+$", "") -- trim whitespace
    table.insert(new_lines, pair)
  end

  -- Replace the inline table with multi-line format
  vim.api.nvim_buf_set_lines(bufnr, line_num - 1, line_num, false, new_lines)

  vim.notify("Converted inline table to multi-line format", vim.log.levels.INFO)
end

-- A function to convert multiple lines TOML table to inline format
--- Before:
-- [[on-window-detected]]
-- if.app-id = 'com.electron.scrypted'
-- check-further-callbacks = false
-- run = ['layout floating']
-- After:
-- [on-window-detected] = { if.app-id = 'com.electron.scrypted',
-- check-further-callbacks = false, run = ['layout floating'] }
M.convert_to_inline_multiline = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local start_line = cursor_pos[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local table_start = nil
  local table_end = nil
  -- Look backwards from cursor to find table start
  for i = start_line, 1, -1 do
    if lines[i] and lines[i]:match("^%[%[.*%]%]") then
      table_start = i
      break
    end
  end
  if not table_start then
    vim.notify("No TOML table header found above cursor", vim.log.levels.WARN)
    return
  end
  -- Find the end of the table
  for i = table_start + 1, #lines do
    if not lines[i] or lines[i]:match("^%s*$") or lines[i]:match("^%[") then
      table_end = i - 1
      break
    end
  end
  if not table_end then table_end = #lines end
  -- Extract key-value pairs with proper formatting
  local pairs = {}
  for i = table_start + 1, table_end do
    local line = lines[i]
    if line and line:match("%S") then
      local key, value = line:match("^%s*([%w_%.%-]+)%s*=%s*(.+)%s*$")
      if key and value then
        value = value:gsub("%s+$", "")
        table.insert(pairs, key .. " = " .. value)
      end
    end
  end
  if #pairs == 0 then
    vim.notify("No key-value pairs found in table", vim.log.levels.WARN)
    return
  end
  -- Create the inline format with proper spacing
  local inline = lines[table_start]:gsub("%[%[(.*)%]%]", "[%1]") .. " = { " .. table.concat(pairs, ", ") .. " }"
  -- Replace the multi-line table with inline format
  vim.api.nvim_buf_set_lines(bufnr, table_start - 1, table_end, false, { inline })
  vim.notify("Converted TOML multi-line table to inline format", vim.log.levels.INFO)
end

function M.setup()
  local modes = { "n", "v" }
  for _, mode in ipairs(modes) do
    vim.keymap.set(mode, "<leader>ti", M.convert_to_inline, { desc = "TOML to inline" })
    vim.keymap.set(mode, "<leader>tm", M.convert_to_multiline, { desc = "TOML to multiline" })
    vim.keymap.set(mode, "<leader>tI", M.convert_to_inline_multiline, { desc = "TOML multi-line to inline" })
  end
end

return M
