local path = require("plenary.path")

---@class util.fzf.devdocs
local M = {}

local dir_path = vim.fn.stdpath("data") .. "/devdocs"
DATA_DIR = path:new(dir_path)
DOCS_DIR = DATA_DIR:joinpath("docs")
INDEX_PATH = DATA_DIR:joinpath("index.json")

---if we have a pattern to search for, only consider lines after the pattern
---@param lines string[]
---@param pattern? string
---@param next_pattern? string
---@return string[]
M.filter_doc = function(lines, pattern, next_pattern)
  if not pattern then return lines end

  -- https://stackoverflow.com/a/34953646/516188
  local function create_pattern(text)
    return text:gsub("([^%w])", "%%%1")
  end

  local filtered_lines = {}
  local found = false
  local pattern_lines = vim.split(pattern, "\n")
  local search_pattern = create_pattern(pattern_lines[1]) -- only search the first line
  local next_search_pattern = nil

  if next_pattern then
    local next_pattern_lines = vim.split(next_pattern, "\n")
    next_search_pattern = create_pattern(next_pattern_lines[1]) -- only search the first line
  end

  for _, line in ipairs(lines) do
    if found and next_search_pattern then
      if line:match(next_search_pattern) then break end
    end
    if line:match(search_pattern) then found = true end
    if found then table.insert(filtered_lines, line) end
  end

  if not found then return lines end

  return filtered_lines
end

function M.read_entry(entry)
  local splited_path = vim.split(entry.path, ",")
  local file = splited_path[1]
  local file_path = DOCS_DIR:joinpath(entry.alias, file .. ".md")
  local content = file_path:read()
  local pattern = splited_path[2]
  local next_pattern = nil

  if entry.next_path ~= nil then next_pattern = vim.split(entry.next_path, ",")[2] end

  local lines = vim.split(content, "\n")
  local filtered_lines = M.filter_doc(lines, pattern, next_pattern)
  return filtered_lines
end

local builtin = require("fzf-lua.previewer.builtin")
local fzf = require("fzf-lua")
local fzf_utils = require("fzf-lua.utils")

M.init = function()
  if M.entries and #M.entries > 0 then return end
  M.entries = M.get_doc_entries({ "lua-5.4", "jest", "javascript", "ruby" })
end

M.read_index = function()
  if not INDEX_PATH:exists() then return end
  local buf = INDEX_PATH:read()
  return vim.fn.json_decode(buf)
end

M.cache = {}
M.get_doc_entries = function(aliases)
  local entries = {}
  local index = M.read_index()

  if not index then return end

  for _, alias in pairs(aliases) do
    if index[alias] then
      local current_entries = index[alias].entries

      for idx, doc_entry in ipairs(current_entries) do
        local next_path = nil
        local entries_count = #current_entries

        if idx < entries_count then next_path = current_entries[idx + 1].path end

        local entry = {
          name = doc_entry.name,
          path = doc_entry.path,
          link = doc_entry.link,
          alias = alias,
          next_path = next_path,
        }

        M.cache[entry.alias .. " " .. entry.name] = entry
        table.insert(entries, entry)
      end
    end
  end

  return entries
end
M.last_preview = nil
function M.previewer()
  local previewer = builtin.buffer_or_file:extend()

  function previewer:new(o, opts, fzf_win)
    previewer.super.new(self, o, opts, fzf_win)
    self.title = "Devdocs"
    setmetatable(self, previewer)
    return self
  end

  function previewer:parse_entry(entry_str)
    -- local res = vim.tbl_filter(function(e)
    --   return e.name == entry_str
    -- end, M.entries)
    local entry = entry_str:match("^%s*(.-)%s*$")
    local res = M.cache[entry]
    -- assert(res, "No entry found for " .. entry_str)
    if not res then return end
    return M.read_entry(res)
  end

  function previewer:populate_preview_buf(entry_str)
    local buf = self:get_tmp_buffer()
    local lines = self:parse_entry(entry_str)
    -- assert(lines, "No message found for entry: " .. entry_str)
    if not lines then lines = { "No entry found for " .. entry_str } end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].filetype = "markdown"
    M.last_preview = self:get_tmp_buffer()
    vim.api.nvim_buf_set_lines(M.last_preview, 0, -1, false, lines)
    vim.bo[M.last_preview].filetype = "markdown"

    -- vim.bo[buf].wrap = true

    ---@type FzfWin
    local win = self.win
    self:set_preview_buf(buf)
    if win.update_title then win:update_title(" Devdocs ") end
    if win.update_scrollbar then win:update_scrollbar() end
  end

  return previewer
end

---@param opts? table<string, any>
function M.open(opts)
  opts = vim.tbl_deep_extend("force", opts or {}, {
    prompt = false,
    winopts = {
      title = " Devdocs ",
      title_pos = "center",
      preview = {
        title = " Devdocs ",
        title_pos = "center",
        wrap = "wrap",
      },
    },
    previewer = M.previewer(),
    fzf_opts = {
      ["--no-multi"] = "",
      -- ["--with-nth"] = "2..",
    },
    actions = {
      default = function(name)
        vim.cmd("vsplit")
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, M.last_preview)
        -- vim.api.nvim_set_option_value("wrap", true, { win = win })
      end,
    },
  })
  local lines = vim.tbl_map(function(entry)
    return string.format(" %-15s %15s", fzf_utils.ansi_codes.yellow(entry.alias), fzf_utils.ansi_codes.blue(entry.name))
  end, M.entries)
  return fzf.fzf_exec(lines, opts)
end

return setmetatable({}, {
  __call = function(_, ...)
    M.init()
    return M.open(...)
  end,
})
