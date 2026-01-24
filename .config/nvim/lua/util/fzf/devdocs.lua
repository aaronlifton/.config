local path = require("plenary.path")
local builtin = require("fzf-lua.previewer.builtin")
local fzf = require("fzf-lua")
local fzf_utils = require("fzf-lua.utils")

---@class util.fzf.devdocs
local M = {}
M.cache = {}

---@class DevDocEntry
---@field name string The name of the documentation entry
---@field path string The file path of the documentation
---@field link string The documentation link
---@field alias string The documentation alias/category
---@field next_path string|nil The path to the next documentation entry

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

---@param entry DevDocEntry
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

local function language_lookup(languages)
  local new_langauges = {}
  local function devdocs_installed()
    if LazyVim and LazyVim.opts then
      local ok, opts = pcall(LazyVim.opts, "nvim-devdocs")
      if ok and opts and type(opts.ensure_installed) == "table" then return opts.ensure_installed end
    end
    return {}
  end

  local function parse_version(version)
    local parts = {}
    for part in version:gmatch("%d+") do
      parts[#parts + 1] = tonumber(part)
    end
    return parts
  end

  local function is_newer(a, b)
    if not b then return true end
    local max_len = math.max(#a, #b)
    for i = 1, max_len do
      local left = a[i] or 0
      local right = b[i] or 0
      if left ~= right then return left > right end
    end
    return false
  end

  local latest_doc_cache = {}

  local function latest_doc(prefix)
    if latest_doc_cache[prefix] then return latest_doc_cache[prefix] end

    local ensure_installed = devdocs_installed()
    local best_item, best_version
    for _, item in ipairs(ensure_installed) do
      if prefix == "javascript" then
        if item == "javascript" and not best_item then best_item = item end
        if item:match("^javascript%-") then
          local version = item:sub(#prefix + 2)
          local parsed = parse_version(version)
          if is_newer(parsed, best_version) then
            best_item = item
            best_version = parsed
          end
        end
      elseif item:match("^" .. prefix .. "%-") then
        local version = item:sub(#prefix + 2)
        local parsed = parse_version(version)
        if is_newer(parsed, best_version) then
          best_item = item
          best_version = parsed
        end
      end
    end

    latest_doc_cache[prefix] = best_item
    return best_item
  end

  local function detect_ruby_version()
    local output = vim.fn.system("ruby -v")
    if vim.v.shell_error ~= 0 then return nil end
    return output:match("ruby%s+([0-9]+%.[0-9]+%.[0-9]+)")
  end

  local function detect_rails_version()
    local ok, gems = pcall(require, "util.ruby.gems")
    if not ok then return nil end
    local version = gems.gem_version("rails")
    if not version then return nil end
    version = vim.fn.trim(version)
    if version == "" then return nil end
    return version:match("([0-9]+%.[0-9]+%.[0-9]+)")
  end

  for _, lang in ipairs(languages) do
    if lang == "lua" then return { latest_doc("lua") or "lua-5.4" } end
    if lang == "javascript" then return { latest_doc("javascript") or "javascript", "jest" } end
    if lang == "ruby" or lang == "eruby" then
      -- local ruby_version = detect_ruby_version() or latest_doc("ruby")
      -- local rails_version = detect_rails_version() or latest_doc("rails")
      return { "ruby-3.4", "rails-8.0" }
    end
    if lang == "python" then return { latest_doc("python") or "python-3.14" } end
  end
  return vim.iter(new_langauges):flatten():totable()
end

--- @param languages string|string[]|nil
local function parse_languages(languages)
  if languages then
    if type(languages) == "string" then languages = { languages } end
    languages = language_lookup(languages)
  else
    languages =
      { latest_doc("lua"), "jest", "javascript", latest_doc("ruby"), latest_doc("rails"), latest_doc("python") }
  end
  return languages
end

--- Initializes the docs database
--- @param languages string|string[]|nil
M.init = function(languages)
  if M.entries and #M.entries > 0 then return end
  languages = parse_languages(languages)

  M.entries = M.get_doc_entries(languages)
end

M.read_index = function()
  if not INDEX_PATH:exists() then return end
  local buf = INDEX_PATH:read()
  return vim.fn.json_decode(buf)
end

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

---@param entry DevDocEntry
function make_entry(entry)
  return string.format(" %-15s %15s", fzf_utils.ansi_codes.yellow(entry.alias), fzf_utils.ansi_codes.blue(entry.name))
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
    return make_entry(entry)
  end, M.entries)
  return fzf.fzf_exec(lines, opts)
end

--- Sends doc entries to coroutine callback
---@param aliases string[]
---@param co thread
---@param callback function
---@return [TODO:return]
M.get_doc_entries_async = function(aliases, co, callback)
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
        callback(entry, co)
      end
    end
  end

  return entries
end
---@param opts? {languages: string|string[]|nil}
function M.open_async(opts)
  opts = opts or {}
  local languages = parse_languages(opts.languages)
  vim.notify(vim.inspect(languages))

  local contents = function(cb)
    local function add_entry(x, co, opts)
      x = make_entry(x)
      cb(x, function(err)
        coroutine.resume(co)
        if err then
          -- close the pipe to fzf, this
          -- removes the loading indicator in fzf
          cb(nil)
        end
      end)
      coroutine.yield()
    end

    -- run in a coroutine for async progress indication
    coroutine.wrap(function()
      local co = coroutine.running()

      -- local start = os.time()
      M.get_doc_entries_async(languages, co, add_entry)
      -- print("took", os.time() - start, "seconds.")

      -- done
      cb(nil)
    end)()
  end

  local opts = {
    prompt = false,
    winopts = {
      title = " Devdocs 󰲂 ",
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
  }

  fzf.fzf_exec(contents, opts)
end

return setmetatable({}, {
  __call = function(_, languages, ...)
    M.init(languages)
    return M.open(...)
  end,
  __index = M,
})
