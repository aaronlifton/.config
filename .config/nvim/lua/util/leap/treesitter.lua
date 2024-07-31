---@class util.leap.treesitter
local M = {}
local api = vim.api
-- local ts_utils = require("nvim-treesitter.ts_utils")

M.get_parent_nodes = function()
  local parser = vim.treesitter.get_parser()
  if parser == nil then
    return
  end

  local root = parser:parse()[1]:root()
  local parent_nodes = {}
  local root_children = {}

  local function traverse(node)
    table.insert(parent_nodes, node:type())
    local child_count = node:child_count()
    for i = 0, child_count - 1, 1 do
      local child = node:child(i)
      table.insert(root_children, child)
    end
    -- for _, child in ipairs(node:children()) do
    -- 	traverse(child)
    -- end
  end

  traverse(root)

  return root_children
end

M.available_text_objs = function(query_group)
  local parsers = require("nvim-treesitter.parsers")
  local ts = require("nvim-treesitter.compat")
  local lang = parsers.get_buf_lang()
  query_group = query_group or "textobjects"
  local parsed_queries = ts.get_query(lang, query_group)
  if not parsed_queries then
    return {}
  end
  local found_textobjects = parsed_queries.captures or {}
  for _, p in pairs(parsed_queries.info.patterns) do
    for _, q in ipairs(p) do
      local query, arg1 = unpack(q)
      if query == "make-range!" and not vim.tbl_contains(found_textobjects, arg1) then
        table.insert(found_textobjects, arg1)
      end
    end
  end
  return found_textobjects
end

---@param wininfo table<string, any>
local get_parent_node_startlines = function(wininfo)
  local matches = {
    "variable_declaration",
    "function_declaration",
    "method_definition",
    "function_call",
    "assignment_statement",
    "comment",
    "import_statement",
    "lexical_declaration",
    "expression_statement",
    "export_statement",
  }
  local nodes = M.get_parent_nodes()
  if nodes then
    local startlines = {}
    for _, node in ipairs(nodes) do
      if vim.tbl_contains(matches, node:type()) then
        local startline, startcol, _, _ = node:range()
        if startline + 1 >= wininfo.topline then
          table.insert(startlines, startline)
        end
      end
    end
    return startlines
  end
end

M.leap_ts_parents = function()
  local wininfo = vim.fn.getwininfo(api.nvim_get_current_win())[1]
  if vim.bo.buftype ~= "" then
   return
  end
  local startlines = get_parent_node_startlines(wininfo)
  if not startlines then
    return
  end
  local targets = {}
  for _, startline in ipairs(startlines) do
    local target = {
      wininfo = wininfo,
      pos = { startline + 1, 1 },
      row = startline,
    }
    table.insert(targets, target)
  end

  require("leap").leap({
    custom_leap = "ts_parents",
    targets = targets,
    -- safe_labels = {},
    -- action = function(target)
    --   api.nvim_set_current_win(target.wininfo.winid)
    --   ts_utils.update_selection(0, target.node, "charwise")
    -- end,
  })
end

-- local create_special_highlights_autocmds = function(custom_leap_name, hl_state)
--   do
--     local hls = {}
--     vim.api.nvim_create_autocmd("User", {
--       pattern = "LeapEnter",
--       callback = function()
--         if require("leap").state.args.custom_leap == custom_leap_name then
--           for name, _ in pairs(hl_state) do
--             hls[name] = vim.api.nvim_get_hl(0, { name = name })
--           end
--           for name, hl in pairs(hl_state) do
--             vim.api.nvim_set_hl(0, name, hl)
--           end
--         end
--       end,
--     })
--     vim.api.nvim_create_autocmd("User", {
--       pattern = "LeapLeave",
--       callback = function()
--         if require("leap").state.args.custom_leap == custom_leap_name then
--           for name, hl in pairs(hls) do
--             vim.api.nvim_set_hl(0, name, hl)
--           end
--           hls = {}
--         end
--       end,
--     })
--   end
-- end

-- create_special_highlights_autocmds("ts_parents", {
--   LeapBackdrop = {},
--   LeapLabelPrimary = { link = "Comment" },
-- })

return M
