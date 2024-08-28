---@class util.git
local M = {}

---@alias Entry { date: string, hash: string, file: string }

---@param n number number of entries
---@return string
M.recently_commited_cmd = function(n)
  local git_dir = require("lazyvim.util").root.git()
  assert(git_dir, "Not a git repo")
  return string.format('git -C %s log -n %d --pretty=format:"%%ad %%h" --date=short --name-only', git_dir, n)
end

---@return Entry[]
---@param n number number of entries
M.commited_files_with_dates = function(n)
  local cmd = M.recently_commited_cmd(n)
  local git_output = vim.fn.system(cmd)
  ---@type Entry[]
  local files = {}
  local date, hash
  for line in git_output:gmatch("[^\r\n]+") do
    if line:match("^[0-9]") then
      date = line
      -- local pattern = "(%d+%-%d+%-%d+)%s+(%w+)"
      local pattern = "(%S+)%s+(%S+)"
      date, hash = date:match(pattern)
    elseif line:match("^[^ ]") then
      table.insert(files, { date = date, hash = hash, file = line })
    end
  end
  return files
end

---@param entry Entry
---@return string
M.format_entry = function(entry)
  local utils = require("fzf-lua").utils
  return string.format(
    " %-15s %15s %s",
    utils.ansi_codes.yellow(tostring(entry.date)),
    utils.ansi_codes.blue(tostring(entry.hash)),
    -- fzf_utils.ansi_codes.green(tostring(entry.file)),
    entry.file
  )
end

function M.previewer()
  local builtin = require("fzf-lua.previewer.builtin")
  local previewer = builtin.buffer_or_file:extend()

  function previewer:new(o, opts, fzf_win)
    previewer.super.new(self, o, opts, fzf_win)
    self.title = "File"
    setmetatable(self, previewer)
    return self
  end

  function previewer:parse_entry(entry_str)
    local pattern = "(%S+)%s+(%S+)%s+(%S+)"
    local date, hash, file = entry_str:match(pattern)
    return { path = file }
  end

  return previewer
end

---@param n number number of files to show
M.open_recently_commited = function(n)
  local fzf = require("fzf-lua")
  local output = M.commited_files_with_dates(n)
  local entries = {}
  for _, entry in ipairs(output) do
    table.insert(entries, M.format_entry(entry))
  end
  local cmd = M.recently_commited_cmd(n)
  local opts = {
    cmd = cmd,
    cwd = require("fzf-lua").path.git_root(),
    winopts = {
      title = " Recently commited files ",
      title_pos = "left",
    },
    previewer = M.previewer(),
    fzf_opts = {
      ["--no-multi"] = "",
      -- ["--with-nth"] = "2..",
    },
    actions = {
      enter = function(selected, opts)
        local _, _, file = selected[1]:match("(%S+)%s+(%S+)%s+(%S+)")
        fzf.actions.file_edit({ file }, opts or {})
      end,
    },
  }
  opts = fzf.config.normalize_opts(opts, "git.files")
  fzf.core.fzf_exec(entries, opts)
end
return M
