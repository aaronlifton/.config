local M = {}

function M.delete_solution_blocks()
  local buf = 0
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local out = {}
  local in_block = false

  for _, line in ipairs(lines) do
    if line:find("^%s*### BEGIN SOLUTION%s*$") then
      in_block = true
      table.insert(out, line) -- keep marker
    elseif line:find("^%s*### END SOLUTION%s*$") then
      in_block = false
      table.insert(out, line) -- keep marker
    elseif not in_block then
      table.insert(out, line)
    end
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
end

return M
