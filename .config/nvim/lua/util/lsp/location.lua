---@class util.lsp.location
local M = {}

---@class util.lsp.location.loc
---@field text string
---@field bufnr integer
---@field file string
---@field pos {[1]:number, [2]:number}
---@field end_pos {[1]:number, [2]:number}
---@field line string

M.get_clients = function(bufnr)
  return vim.lsp.get_clients({ bufnr = bufnr })
end
--   test
M.request_definition = function(bufnr, cb)
  local clients = M.get_clients(bufnr)
  local win = vim.fn.bufwinid(bufnr)
  local method = "textDocument/definition"
  for _, client in ipairs(clients) do
    -- print(client.offset_encoding)
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    local status, request_id = client:request(method, params, function(_, result)
      cb(client, result)
    end)
  end
end

M.get_declaration = function(bufnr, range)
  local lines = vim.api.nvim_buf_get_lines(bufnr, range.start.line, range["end"].line + 1, false)

  -- If it's a single line, extract the substring between start and end columns
  if #lines == 1 then
    local content = lines[1]:sub(range.start.character + 1, range["end"].character)
    return content
  else
    -- Handle multi-line selection if needed
    lines[1] = lines[1]:sub(range.start.character + 1)
    lines[#lines] = lines[#lines]:sub(1, range["end"].character)
    local content = table.concat(lines, "\n")
    return content
  end
end

function M.get_definition_source(loc)
  if not loc then return nil end

  local start_line = loc.pos[1]
  local end_line = loc.end_pos[1]
  local filename = loc.file
  local file_lines = {}
  if vim.fn.filereadable(filename) == 1 then file_lines = vim.fn.readfile(filename) end

  -- Ensure we have valid lines to work with
  if #file_lines == 0 then return nil end

  -- Get the relevant lines from the file
  ---@type content string[]
  local lines = {}
  for i = start_line, end_line do
    if file_lines[i] then table.insert(lines, file_lines[i]) end
  end
  -- Extract the exact text range using start/end positions
  lines = require("util.selection").normalize_indentation(lines)
  local content = table.concat(lines, "\n")
  return start_line, end_line, content
end

--- Get source text from a definition result
---@param result table The result object containing definition information
---@return string|nil source_text The source text from the definition
---@return string|nil error_message Error message if something went wrong
function M.get_source_text_from_result(result)
  -- Check if we have valid input
  if not result or not result.definition or not result.definition.filename then
    return nil, "Invalid result object or missing filename"
  end
  
  local filename = result.definition.filename
  
  -- Get line information
  local start_line = 1
  local end_line = nil
  
  if result.definition.declaration then
    start_line = result.definition.declaration.start_line or start_line
    end_line = result.definition.declaration.end_line
  end
  
  -- Try to read the file
  if vim.fn.filereadable(filename) ~= 1 then
    return nil, "Could not read file: " .. filename
  end
  
  local file_lines = vim.fn.readfile(filename)
  
  -- Extract the relevant lines
  local content = {}
  for i = start_line, (end_line or #file_lines) do
    if file_lines[i] then
      table.insert(content, file_lines[i])
    end
  end
  
  -- Join the lines into a single string
  return table.concat(content, "\n")
end

---@param loc util.lsp.location.loc[]
M.get_definition = function(locs)
  local declaration = locs[1]
  local definition = locs[2]
  -- Load the file from the definition location
  local filename = declaration.file
  local file_lines = {}
  local def_start_line, def_end_line, content = M.get_definition_source(definition)
  local dec_start_pos = declaration.pos
  local dec_end_pos = declaration.end_pos

  -- Return both line numbers and the extracted content
  local location = {
    filename = filename,
    definition = {
      content = content,
      start_line = def_start_line,
      end_line = def_end_line,
    },
    declaration = {
      start_line = dec_start_pos[1],
      end_line = dec_end_pos[1],
    },
  }

  return location
end

---@param bufnr number
---@return {name: string, definition: {start_line: integer, end_line: integer, content: string}}
function M.get_definition_content(bufnr, cb)
  M.request_definition(bufnr, function(client, result)
    result = result or {}
    result = vim.tbl_isempty(result) and {} or vim.islist(result) and result or { result }
    local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)
    local definition_selection_range = items[1].user_data.originSelectionRange
    local declaration_name = M.get_declaration(bufnr, definition_selection_range)

    -- local res = require("util.lsp.locations").get_definition(items)
    local locs = vim
      .iter(items)
      :map(function(loc)
        return {
          text = loc.filename .. " " .. loc.text,
          buf = loc.bufnr,
          file = loc.filename,
          pos = { loc.lnum, loc.col - 1 },
          end_pos = loc.end_lnum and loc.end_col and { loc.end_lnum, loc.end_col - 1 } or nil,
          line = loc.text,
        }
      end)
      :totable()
    cb({ name = declaration_name, definition = M.get_definition(locs) })
  end)
end

-- M.request_definition(12, function(client, result)
--   result = result or {}
--   result = vim.tbl_isempty(result) and {} or vim.islist(result) and result or { result }
--   local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)
--   print(items)
-- end)

-- call
-- M.get_definition(173, function(client, result)
--   print(result)
--   result = result or {}
--   result = vim.tbl_isempty(result) and {} or vim.islist(result) and result or { result }
--   local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)
--   print(items)
--   local data = vim
--     .iter(items)
--     :map(function(loc)
--       return {
--         text = loc.filename .. " " .. loc.text,
--         buf = loc.bufnr,
--         file = loc.filename,
--         pos = { loc.lnum, loc.col - 1 },
--         end_pos = loc.end_lnum and loc.end_col and { loc.end_lnum, loc.end_col - 1 } or nil,
--         line = loc.text,
--       }
--     end)
--     :totable()
--   print(items)
-- end)

return M
