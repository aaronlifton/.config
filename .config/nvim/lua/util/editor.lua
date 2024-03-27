local M = {}

function M.has_words_before()
  -- local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

-- Define a function to perform find and replace
function M.find_and_replace()
  -- Get the current mode
  local mode = vim.api.nvim_get_mode().mode

  -- Check if the current mode is visual or select
  if mode == "v" or mode == "V" or mode == "select" or mode == "Select" then
    -- Get the current yank register content
    local yank_content = vim.fn.getreg('"')

    -- Get the user input
    local input_content = vim.fn.input("Enter the replacement text: ")

    -- Get the current selection start and end positions
    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos = vim.api.nvim_buf_get_mark(0, ">")
    -- Get the current buffer lines
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

    -- Replace the yanked content with the user input in the current selection
    for i, line in ipairs(lines) do
      -- set the line to the modified line
      lines[i] = line:gsub(yank_content, input_content)
    end

    -- Replace the current selection with the modified lines
    vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, end_pos[1], false, lines)
  else
    print("Please select a text in visual or select mode")
  end
end

function M.find_and_replace_within_lines()
  local num_lines = tonumber(vim.fn.input("Number of lines to search: "))
  if not num_lines or num_lines <= 0 then return end
  local search_str = vim.fn.input("Search for:")
  local replace_str = vim.fn.input("Replace with:")
  local command = string.format([[:.,.+%ds/%s/%s/g<CR>]], num_lines, search_str, replace_str)
  vim.api.nvim_command(command)
end

function M.baleia_colorize()
  local bufname = vim.api.nvim_buf_get_name(vim.fn.bufnr())
  if bufname == "LazyTerm" then return end
  require("baleia").automatically(vim.fn.bufnr())
end

return M
