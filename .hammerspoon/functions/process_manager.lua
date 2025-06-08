local logger = require("functions/logger")

--- This module provides functionality to find and kill processes based on a specific command line search string.
---@class ProcessManager
---@field findProcesses fun(search_str: string, callback: function)
---@field findAndKillProcesses fun(search_string: string)
---@field killProcesses fun(pids: table)
local ProcessManager = {}

-- The string to search for in the process command line
ProcessManager.search_strings = {
  gitC = "git -C /Users/alifton",
}

-- Command to find PIDs of processes whose command line contains the search string
-- ps aux: List all processes (user, PID, %CPU, %MEM, etc.)
-- grep "%s": Filter lines containing the search string (%%s is Lua format specifier for string)
-- grep -v grep: Exclude the grep process itself from the results
-- awk '{print $2}': Extract the second column (which is typically the PID in ps aux output)
local find_pids_command_template = [[ps aux | grep "%s" | grep -v grep | awk '{print $2}']]

-- Command to kill a process by PID (using SIGTERM by default)
local kill_command_template = [[kill %s]] -- %s will be the PID

--- Function to find processes containing the search string in their command line.
--- Executes a shell command to get the PIDs.
--- @param search_str string: The substring to search for.
--- @param callback function: A function to call with the table of PIDs when the search is complete.
function ProcessManager.findProcesses(search_str, callback)
  if not callback or type(callback) ~= "function" then
    logger.e("process_manager: findProcesses requires a callback function.")
    return
  end

  local command = string.format(find_pids_command_template, search_str)
  logger.i("process_manager: Running command to find PIDs: " .. command)

  -- Use hs.task to run the command and capture output
  local task = hs.task.new(command, function(task_obj, status)
    local matching_pids = {}
    local stdout = task_obj:readStdout()
    local stderr = task_obj:readStderr()

    if status ~= 0 then
      -- Command failed
      logger.e("process_manager: Find PIDs command failed with status " .. status)
      logger.e("process_manager: stderr: " .. (stderr or "None"))
      hs.alert.show("Error searching for processes.")
      -- Still call the callback, but with an empty list
      callback({})
      return
    end

    if stdout then
      -- Split the output into lines and extract PIDs
      -- The output should be one PID per line
      for line in string.gmatch(stdout, "[^\n]+") do
        local pid = tonumber(Util.string.trim(line)) -- Convert line (PID string) to number
        if pid and pid > 0 then
          table.insert(matching_pids, pid)
          logger.i("process_manager: Found matching PID: " .. pid)
        else
          -- Log lines that couldn't be parsed as PIDs (shouldn't happen with the awk command)
          logger.w("process_manager: Could not parse PID from line: '" .. line .. "'")
        end
      end
    end

    -- Call the provided callback with the list of PIDs
    callback(matching_pids)
  end)

  -- Start the task
  task:start()
end

--- Function to kill a list of processes by their PIDs using the 'kill' command.
--- @param pids table: A table containing PIDs to kill.
function ProcessManager.killProcesses(pids)
  if not pids or #pids == 0 then
    hs.alert.show("No processes found to kill.")
    logger.i("process_manager: No matching processes found to kill.")
    return
  end

  hs.alert.show("Attempting to kill " .. #pids .. " process(es).")
  local killed_count = 0
  local failed_count = 0

  -- Kill each process by its PID
  for _, pid in ipairs(pids) do
    local kill_command = string.format(kill_command_template, pid)
    logger.i("process_manager: Executing kill command: " .. kill_command)

    -- Use hs.execute for fire-and-forget killing
    local status, stdout, stderr = hs.execute(kill_command, true) -- true means wait for command to finish

    if status == 0 then
      logger.i("Successfully killed process PID: " .. pid)
      killed_count = killed_count + 1
    else
      -- Kill command failed (e.g., process already gone, no permissions)
      logger.w("process_manager: Failed to kill process PID: " .. pid .. ". Status: " .. status)
      logger.w("process_manager: stderr: " .. (stderr or "None"))
      failed_count = failed_count + 1
    end
  end

  hs.alert.show("Kill operation finished. Killed: " .. killed_count .. ", Failed: " .. failed_count)
  logger.i("process_manager: Kill operation finished. Killed: " .. killed_count .. ", Failed: " .. failed_count)
end

--- Main function to find and kill processes containing the predefined search string ("git -C").
function ProcessManager.findAndKillProcesses(search_string)
  hs.alert.show("Searching for processes containing '" .. search_string .. "'...")

  -- findProcesses is asynchronous because it uses hs.task.
  -- We pass a callback function that will be executed *after* findProcesses finishes and finds the PIDs.
  ProcessManager.findProcesses(search_string, function(pids_to_kill)
    -- This code runs *after* the ps command completes and PIDs are found
    ProcessManager.killProcesses(pids_to_kill)
  end)
end

-- Return the process_manager module
return ProcessManager
