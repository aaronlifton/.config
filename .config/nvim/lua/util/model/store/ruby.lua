-- function M.ts_extract(file, extract_child)
--   -- local lang = vim.treesitter.get_lang(vim.filetype.match({ filename = file.filepath }))
--   local lang = vim.filetype.match({ filename = file.filepath })
--   local parser = vim.treesitter.get_string_parser(file.content, lang)
--   local tree = parser:parse()[1]
--   local root = tree:root()
--
--   local results = {}
--
--   for child in root:iter_children() do
--     local result = extract_child(child, file)
--     if result ~= nil then
--       table.insert(results, result)
--     end
--   end
--
--   return results
-- end

---@param function_item FunctionItem
-- local function normalize_function_item_filepath_to_store(function_item)
--   local store_rel_path = vim.fn.pyeval('store.path_relative_to_store(r"' .. function_item.filepath .. '", s)')
--
--   return {
--     id = store_rel_path .. ":" .. function_item.name,
--     content = function_item.content,
--   }
-- end

-- local function node_get_text(node, content)
--   local _, _, start = node:start()
--   local _, _, end_ = node:end_()
--
--   return content:sub(start + 1, end_)
-- end

local ts_source = require("model.store.sources.treesitter")
M = {}
ts_source.lang.ruby = {}
vim.treesitter.get_lang = vim.treesitter.language.get_lang

---@class File
---@field filepath string
---@field content string

---@param file File
function M.ts_extract(file, extract_child)
  local lang = vim.treesitter.language.get_lang(vim.filetype.match({ filename = file.filepath }))
  local parser = vim.treesitter.get_string_parser(file.content, lang)
  local tree = parser:parse()[1]
  local root = tree:root()

  local results = recur_children(root, file, extract_child)
  -- local results = {}
  -- for child in root:iter_children() do
  --   local result = extract_child(child, file)
  --   if result ~= nil then
  --     table.insert(results, result)
  --   end
  -- end

  return results
end

---@param child Node
---@param file File
---@param extract_child Function
function recur_children(child, file, extract_child)
  local results = {}
  local recur
  recur = function(node)
    vim.api.nvim_echo({ { (node:type() or "") .. "\n", "Title" }, { vim.inspect(node), "Normal" } }, true, {})
    local result = extract_child(node, file)
    if result ~= nil then table.insert(results, result) end
    for child_node in node:iter_noderen() do
      recur(child_node)
    end
  end
  recur()
  return results
end

function M.ts_extract_function(opts)
  local type = opts.type
  local get_name = opts.get_name

  return function(child, file)
    vim.api.nvim_echo({ { (child:type() or "") .. "\n", "Title" }, { vim.inspect(child), "Normal" } }, true, {})
    if child:type() == type then
      return {
        content = node_get_text(child, file.content),
        filepath = file.filepath,
        name = node_get_text(get_name(child), file.content),
      }
    end
  end
end

function ts_source.lang.ruby.functions(file)
  return ts_source.ts_extract(
    file,
    M.ts_extract_function({
      type = "function_declaration",
      get_name = function(child)
        return child:field("name")[1]
      end,
    })
  )
end

---@param function_item FunctionItem
local function normalize_function_item_filepath_to_store(function_item)
  local store_rel_path = vim.fn.pyeval('store.path_relative_to_store(r"' .. function_item.filepath .. '", s)')

  return {
    id = store_rel_path .. ":" .. function_item.name,
    content = function_item.content,
  }
end

local store = require("model.store")
function store.add_ruby_functions(glob)
  if glob == nil then glob = vim.fn.expand("%") end
  -- Extracts lua functions as items
  local function to_ruby_functions(file)
    return vim.tbl_map(normalize_function_item_filepath_to_store, ts_source.lang.ruby.functions(file))
  end

  ---@param glob_ string glob pattern to search for files, starting from current directory
  ---@param to_items function converts each filepath to a list of items
  local function glob_to_items(glob_, to_items)
    local filepaths = vim.fn.glob(glob_, nil, true)

    local results = {}

    for _, filepath in ipairs(filepaths) do
      -- show(filepath)
      local file = ts_source.ingest_file(filepath)
      local items = to_items(file)

      for _, item in ipairs(items) do
        table.insert(results, item)
      end
    end

    return results
  end

  store.add_items(glob_to_items(glob, to_ruby_functions))
end

function M.extract2() end

function M.extract()
  local filepath = "/Users/aaron/Code/rails/birddex/app/controllers/api/v1/birds_controller.rb"
  local file = io.open(filepath, "r")
  if file == nil then error("Unable to open file: " .. filepath) end

  local content = file:read("*a")
  ts_source.ts_extract(
    file,
    ts_source.ts_extract_function({
      type = "function_declaration",
      get_name = function(child)
        return child:field("name")[1]
      end,
    })
  )
end

-- Usage
-- (function()
--   local file = ingest_file('treesitter.lua')
--   show(M.lang.ruby.functions(file))
-- end)()
-- Check the module functions exposed in [store](./lua/model/store/init.lua). This uses the OpenAI embeddings api to generate vectors and queries them by cosine similarity.
--
-- To add items call into the `model.store` lua module functions, e.g.
--   - `:lua require('model.store').add_ruby_functions()`
--   - `:lua require('model.store').add_files('.')`
--
-- Look at `store.add_lua_functions` for an example of how to use treesitter to parse files to nodes and add them to the local store.
--
-- To get query results call `store.prompt.query_store` with your input text, desired count and similarity cutoff threshold (0.75 seems to be decent). It returns a list of {id: string, content: string}:
--
-- ```lua
-- builder = function(input, context)
--   ---@type {id: string, content: string}[]
--   local store_results = require('model.store').prompt.query_store(input, 2, 0.75)
--
--   -- add store_results to your messages
-- end
-- ```
--
-- </details>
--
-- - `:Mstore [command]`
--   - `:Mstore init` — initialize a store.json file at the closest git root directory
--   - `:Mstore query <query text>` — query a store.json
--
