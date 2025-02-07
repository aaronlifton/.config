vim.api.nvim_create_user_command("ShowTermcode", function()
  -- Create a temporary buffer for input
  local buf = vim.api.nvim_create_buf(false, true)

  -- Create a floating window
  local width = 40
  local height = 1
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Set buffer options
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Press any key (ESC to quit)" })

  -- Get input
  local ok, key = pcall(function()
    return vim.fn.getchar()
  end)

  -- Clean up the floating window
  vim.api.nvim_win_close(win, true)
  vim.api.nvim_buf_delete(buf, { force = true })

  if ok then
    local char
    if type(key) == "number" then
      char = vim.fn.nr2char(key)
    else
      char = key
    end

    -- Convert to string representation if it's a special key
    local keyname = vim.fn.keytrans(char)

    -- Get termcode
    local termcode = vim.api.nvim_replace_termcodes(keyname, true, true, true)

    -- Convert termcode to a readable format
    local readable = vim.inspect(termcode):gsub('"', "")

    -- Echo the results
    vim.api.nvim_echo({
      { "Pressed: ", "Normal" },
      { keyname, "Special" },
      { "\nTermcode: ", "Normal" },
      { readable, "Special" },
    }, false, {})
  end
end, {})
