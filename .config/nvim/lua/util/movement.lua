local M = {}

function M.find_next_ordered_list_item()
  -- local win = vim.api.nvim_get_current_win()
  local current_line = vim.api.nvim_get_current_line()
  local current_pos = vim.api.nvim_win_get_cursor(0)[1]

  -- Find the current list item number/letter
  local current_item_match = current_line:match("^[%d%)]+%.?%s*") -- Matches "1.", "1)", etc.

  if not current_item_match then return end

  -- Iterate through subsequent lines to find the next item
  for i = current_pos + 1, vim.api.nvim_buf_line_count(0) do
    local next_line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    local next_item_match = next_line:match("^[%d%)]+%.?%s*")

    if next_item_match then
      vim.api.nvim_win_set_cursor(0, { i, 0 })
      return
    end

    -- Check for blank lines before giving up
    if next_line:match("^%s*$") then
      goto continue -- skips to next iteration of for loop
    end

    -- Check if current line is last in the document and exit if so
    if i == vim.api.nvim_buf_line_count(0) then return end

    ::continue::
  end
end

function M.find_prev_ordered_list_item()
  local current_line = vim.api.nvim_get_current_line()
  local current_pos = vim.api.nvim_win_get_cursor(0)[1]

  -- Find the current list item number/letter
  local current_item_match = current_line:match("^[%d%)]+%.?%s*")
  if not current_item_match then return end

  -- Iterate through preceding lines to find the previous item
  for i = current_pos - 1, 1, -1 do
    local prev_line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    local prev_item_match = prev_line:match("^[%d%)]+%.?%s*")

    if prev_item_match then
      vim.api.nvim_win_set_cursor(0, { i, 0 })
      return
    end

    -- Check for blank lines before giving up
    if prev_line:match("^%s*$") then
      goto continue -- skips to next iteration of for loop
    end

    --Check if current line is first in the document and exit if so
    if i == 1 then return end

    ::continue::
  end
end

return M
