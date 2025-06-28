local M = {}

-- Function to run an AppleScript string
-- Requires macOS and appropriate Accessibility permissions for Neovim/System Events
function M.RunAppleScript(script_string)
  -- Escape single quotes within the script string to be safe when passing to osascript -e
  -- Replace "'" with "'\''" for the shell command
  local escaped_script = script_string:gsub("'", "'\\''")

  -- Construct the command to run osascript with the escaped script string
  -- The escaped script must be wrapped in single quotes for osascript -e
  local command = "osascript -e '" .. escaped_script .. "'"

  -- Use vim.fn.system to execute the command and capture output
  -- vim.fn.system executes synchronously and returns the output/error
  local output = vim.fn.system(command)

  -- Optional: Print output or handle errors
  -- if vim.v.shell_error != 0 then
  --     print("AppleScript execution failed:")
  --     print(output)
  -- end

  return output -- Return the output from the osascript command
end

-- Example Usage:
-- Define the AppleScript you want to run as a multi-line string
M.safari_new_tab_script = [[
tell application "Safari"
    activate -- Bring Safari to the front
    tell application "System Events" to tell process "Safari"
        -- Click the 'New Tab' menu item in the 'File' menu
        click menu item "New Tab" of menu "File" of menu bar 1
end tell
function M.close_window
-- RunAppleScript(safari_new_tab_script) -- Uncomment this line to actually run the script

-- Another example: Simulate pressing Cmd+W (Close Window/Tab) in the frontmost app
M.close_window_script = [[
tell application "System Events"
    -- Simulate Command+W key press
    key code 13 using {command down}
end tell
]]

function M.close_window()
  M.RunAppleScript(M.close_window_script)
end

return M
