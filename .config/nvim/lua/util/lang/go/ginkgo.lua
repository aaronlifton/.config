---@class util.lang.go.ginkgo
---@field prepare_ginkgo_command_from_clipboard fun(): nil
local M = {}

-- Lua function to prepare and copy a ginkgo command to the clipboard
function M.prepare_ginkgo_command_from_clipboard()
  -- 1. Get the content of the system clipboard (+ register)
  --    Use '' as a default if the clipboard is empty or nil
  local clipboard_content = vim.fn.getreg("+") or ""

  -- To safely include clipboard content in a shell command's quoted string,
  -- we should escape any single quotes within it.
  local escaped_clipboard_content = clipboard_content:gsub("'", "'\\''")

  -- 2. Get the relative path of the current buffer (~:.)
  local full_path = vim.fn.expand("%")
  local relative_path = ""

  -- Check if the buffer has a usable path (not unnamed or stdin)
  if full_path ~= "" and full_path ~= "<buffer>" and full_path ~= "<stdin>" then
    relative_path = vim.fn.fnamemodify(full_path, ":~:.")
  end

  -- 3. Add a leading '.' to the relative path if it's not empty
  local final_path_part = ""
  if relative_path ~= "" then
    -- Prepend '.' as requested. This handles cases like:
    -- 'filename.go' -> '.filename.go'
    -- 'path/to/file.go' -> './path/to/file.go'
    -- '../path/to/file.go' -> '../path/to/file.go' -- (:~:. already makes it relative)
    -- Let's re-check `:~:.` behavior relative to CWD. If file is `~/project/file.go` and CWD is `~/project`, `:~:.` gives `file.go`.
    -- If file is `~/project/sub/file.go` and CWD is `~/project`, `:~:.` gives `sub/file.go`.
    -- If file is `~/other/file.go` and CWD is `~/project`, `:~:.` gives `../other/file.go`.
    -- So prepending '.' always seems to fit the user's request "with a . in front of it".
    final_path_part = "." .. relative_path
  end

  -- 4. Construct the final command string
  --    The format is: ❯ godotenv ... --focus='<escaped_clipboard_content>' -v <final_path_part>
  --    Using single quotes for the focus string is safer for shell execution
  local command_template = [[godotenv -f .env.test ginkgo --tags=component --focus='%s' -v %s]]
  local final_command = command_template:format(escaped_clipboard_content, final_path_part)

  -- 5. Set the system clipboard register (+) to the new command string
  vim.fn.setreg("+", final_command)

  -- Optional: Provide feedback to the user
  print("Ginkgo command copied to clipboard:")
  print(final_command)
end

-- To use this function, you can call it directly using :lua,
-- or preferably map it to a keybinding in your Neovim config.
-- Example mapping (using <leader>gg in normal mode):
-- vim.api.nvim_set_keymap('n', '<leader>gg', ':lua prepare_ginkgo_command_from_clipboard()<CR>', { noremap = true, silent = true })

-- You can remove or comment out the example mapping if you prefer to call it manually.
return M
