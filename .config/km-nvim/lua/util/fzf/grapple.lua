local fzf_lua = require("fzf-lua")
local fzf_utils = require("fzf-lua.utils")

---@class util.fzf.grapple
local M = {}

---@param idx number
---@param tag grapple.tag
---@return string
local function format_entry(idx, tag)
  local path = tag.path
  local line = (tag.cursor or { 1, 0 })[1]
  local col = (tag.cursor or { 1, 0 })[2]
  path = path:gsub("^" .. vim.fn.getcwd() .. "/", "")
  return string.format(
    " %-15s %15s %15s %s",
    fzf_utils.ansi_codes.yellow(tostring(idx)),
    fzf_utils.ansi_codes.blue(tostring(line)),
    fzf_utils.ansi_codes.green(tostring(col)),
    path
  )
end

---@param entries string[]
local function sort_entries(entries)
  table.sort(entries, function(a, b)
    -- Extract the first number, skipping ANSI color codes
    local num_a = tonumber(a:gsub("\27%[[%d;]+m", ""):match("^%s*(%d+)"))
    local num_b = tonumber(b:gsub("\27%[[%d;]+m", ""):match("^%s*(%d+)"))
    return num_a < num_b
  end)
end

M.open = function()
  local tags = require("grapple").tags()
  local entries = {}
  if not tags then return end

  for idx, tag in ipairs(tags) do
    table.insert(entries, format_entry(idx, tag))
  end
  sort_entries(entries)
  table.insert(entries, 1, string.format("%-5s %s  %s %s", "mark", "line", "col", "path"))

  local opts = {
    fzf_opts = { ["--header-lines"] = 1 },
    prompt = "Grapple>",
    fzf_colors = true,
    actions = {
      ["default"] = function(selected)
        local _, lnum, col, filepath = selected[1]:match("(.)%s+(%d+)%s+(%d+)%s+(.*)")
        vim.cmd("e " .. filepath)
        vim.defer_fn(function()
          vim.fn.cursor(lnum, col)
          vim.cmd("normal! zz")
        end, 50)
      end,
    },
    previewer = fzf_lua.defaults.marks.previewer,
  }
  fzf_lua.fzf_exec(entries, opts)
end

return M
