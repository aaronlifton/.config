local Util = require("lazyvim.util")

local M = {}

function M.map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

function M.delete_mark()
  local err, mark = pcall(function()
    vim.cmd("echo 'Enter mark to delete: '")
    return string.char(vim.fn.getchar())
  end)
  if not err or not mark then
    return
  end
  vim.cmd(":delmark " .. mark)
end

function M.has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
  local search_str = vim.fn.input("Search for:")
  local replace_str = vim.fn.input("Replace with:")
  local command = string.format([[:.,.+%ds/%s/%s/g<CR>]], num_lines, search_str, replace_str)
  vim.api.nvim_command(command)
end

function M.toggle_vim_g_variable(b)
  if vim.g[b] == 1 then
    vim.g[b] = 0
  else
    vim.g[b] = 1
  end
  -- vim.g.enable_leap_lightspeed_mode = not vim.g.enable_leap_lightspeed_mode
end

function M.clear_all_registers()
  for i = 0, 25 do
    vim.fn.setreg(string.char(i + 97), "")
  end
end

-- Set this check up for nvim-cmp tab mapping
function M.copy_to_pbcopy()
  local selected_text = vim.fn.getreg("*")
  vim.fn.system(string.format("echo '%s' | pbcopy", selected_text))
end

function M.baleia_colorize()
  local bufname = vim.api.nvim_buf_get_name(vim.fn.bufnr())
  if bufname == "LazyTerm" then
    return
  end
  require("baleia").automatically(vim.fn.bufnr())
end

function M.lazyterm()
  Util.terminal.open(nil, { cwd = Util.root.get() })
end

-- Web search & URL handling
function M.search_google()
  -- Get the selected text
  local selected_text = vim.fn.getreg("*")

  -- Construct the Google search URL
  local search_url = "https://www.google.com/search?q=" .. vim.fn.escape(selected_text, " ")

  -- Open the URL in the default browser
  vim.fn.jobstart({ "open", search_url })
end

function M.open_url()
  local text_under_cursor = vim.fn.expand("<cword>")
  vim.fn.jobstart({ "open", text_under_cursor })
end

function M.v_open_url()
  local selected_text = vim.fn.getreg("*")
  vim.fn.jobstart({ "open", selected_text })
end

-- Window functions

local window_picker = require("window-picker")

function M.pick_window()
  local picked_window_id = window_picker.pick_window({
    include_current_win = true,
  }) or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end

-- Swap two windows using the awesome window picker
function M.swap_windows()
  local window = window_picker.pick_window({
    include_current_win = false,
  })
  if not window then
    return
  end
  local target_buffer = vim.fn.winbufnr(window.id)
  -- Set the target window to contain current buffer
  vim.api.nvim_win_set_buf(window, 0)
  -- Set current window to contain target buffer
  vim.api.nvim_win_set_buf(0, target_buffer)
end

function M.switch_to_highest_window()
  local windows = vim.api.nvim_list_wins()
  local highest_win = windows[1]
  local highest_zindex = vim.api.nvim_win_get_config(highest_win).zindex
  for _, win in ipairs(windows) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      highest_win = win
      highest_zindex = vim.api.nvim_win_get_config(highest_win).zindex
      break
    end
  end

  vim.cmd("echo 'highest window is " .. highest_win .. " with zindex " .. highest_zindex .. "'")
  vim.api.nvim_set_current_win(highest_win)
end

function M.close_all_floating_windows()
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      vim.api.nvim_win_close(win, true)
    end
  end
end

function M.render_markdown()
  local content
  local markdown_source = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    -- get the element from  the ipairs
    local name = vim.api.nvim_buf_get_name(bufnr)
    if string.match(name, "^termexec") then
      local term_buf = bufnr
      content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
      -- make the bufnr buffer modifiable
      -- TODO: search github for this
      vim.api.nvim_set_option_value("modifiable", true, { buf = term_buf })
      vim.api.nvim_buf_delete(term_buf, { force = true })
      break
    end
  end
  -- write that content to the main buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, true, content)
  vim.api.nvim_buf_set_lines(markdown_source, 0, -1, true, content)
end

return M
