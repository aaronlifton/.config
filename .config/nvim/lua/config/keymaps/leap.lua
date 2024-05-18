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
  ---@type TSNode[]?
  -- lang from wininfo
  -- local lang = vim.bo.filetype
  -- local matches = {
  --   -- tsx
  --   tsx = { "assignment_statement", "variable_declaration" },
  --   go = {
  --     "function_declaration",
  --     "function_definition",
  --     "method_definition",
  --   },
  --   lua = {
  --     "assignment_statement",
  --     "comment",
  --     "comment",
  --     "function_call",
  --     "function_declaration",
  --     "variable_declaration",
  --   },
  -- }
  local matches = M.available_text_objs()
  if matches then
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
  -- vim.api.nvim_echo({ { "targets: " .. vim.inspect(targets) } }, true, {})
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

local create_special_highlights_autocmds = function(custom_leap_name, hl_state)
  do
    local hls = {}
    vim.api.nvim_create_autocmd("User", {
      pattern = "LeapEnter",
      callback = function()
        if require("leap").state.args.custom_leap == custom_leap_name then
          for name, _ in pairs(hl_state) do
            hls[name] = vim.api.nvim_get_hl(0, { name = name })
          end
          for name, hl in pairs(hl_state) do
            vim.api.nvim_set_hl(0, name, hl)
          end
        end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "LeapLeave",
      callback = function()
        if require("leap").state.args.custom_leap == custom_leap_name then
          for name, hl in pairs(hls) do
            vim.api.nvim_set_hl(0, name, hl)
          end
          hls = {}
        end
      end,
    })
  end
end

create_special_highlights_autocmds("ts_parents", {
  LeapBackdrop = {},
  LeapLabelPrimary = { link = "Comment" },
})

M.leap_spooky_viw = function()
  require("leap").leap({
    target_windows = { vim.fn.win_getid() },
    action = require("leap-spooky").spooky_action(function()
      return "viw"
    end, {
      keeppos = true,
      on_exit = (vim.v.operator == "y") and "p",
    }),
  })
end

M.leap_spooky_diw = function()
  require("leap").leap({
    target_windows = { vim.fn.win_getid() },
    action = require("leap-spooky").spooky_action(function()
      return "diw"
    end, {
      keeppos = true,
      on_exit = (vim.v.operator == "y") and "p",
    }),
  })
end

M.leap_spooky_dd = function()
  require("leap").leap({
    target_windows = { vim.fn.win_getid() },
    action = require("leap-spooky").spooky_action(function()
      return "dd"
    end, {
      keeppos = true,
      on_exit = (vim.v.operator == "y") and "p",
    }),
  })
end

return M
-- local function get_updown_targets()
--   local current_win = vim.api.nvim_get_current_win()
--   local wininfo = vim.fn.getwininfo(current_win)
--   local height = wininfo[1].height
--   local pos = vim.api.nvim_win_get_cursor(current_win)
--   local row, _ = unpack(pos)
--   local last = wininfo[1].botline - 1
--   local first = wininfo[1].topline
--
--   local bot = math.max(first, math.floor(row - height / 2))
--   local top = math.min(last, height - 1)
--   local midbot = math.floor((bot + row) / 2)
--   local mid = math.floor(bot + top / 2)
--   local midtop = math.floor((top + row) / 2)
--   local target_rows = { bot, midbot, mid, midtop, top }
--   local seen = {}
--   for _, trow in ipairs(target_rows) do
--     if seen[trow] then
--       table.remove(target_rows, trow)
--     else
--       seen[trow] = true
--     end
--   end
--
--   -- for row = last, first, -1 do
--   local targets = {}
--   for _, trow in ipairs(target_rows) do
--     local target = {
--       wininfo = wininfo[1],
--       pos = { trow + 1, 1 },
--       row = trow,
--     }
--     table.insert(targets, target)
--   end
--
--   return targets
-- end

-- local function leap_quarters()
--   require("leap").leap({
--     targets = get_updown_targets(),
--     -- action = function(target)
--     --   target.pick:set_selection(target.row)
--     --   require("telescope.actions").select_default(prompt_bufnr)
--     -- end,
--     opts = {
--       max_phase_one_targets = 0,
--       special_keys = {
--         next_target = "<enter>",
--         prev_target = "<S-enter>",
--       },
--     },
--   })
-- end
-- map("n", "<leader>j", leap_quarters, { desc = "Leap lines" })

-- local function get_ast_nodes()
--   local wininfo = vim.fn.getwininfo(api.nvim_get_current_win())[1]
--   -- Get current TS node.
--   local cur_node = ts_utils.get_node_at_cursor(0)
--   if not cur_node then
--     return
--   end
--   -- Get parent nodes recursively.
--   local nodes = { cur_node }
--   local parent = cur_node:parent()
--   while parent do
--     table.insert(nodes, parent)
--     parent = parent:parent()
--   end
--   -- Create Leap targets from TS nodes.
--   local targets = {}
--   local startline, startcol
--   for _, node in ipairs(nodes) do
--     startline, startcol, _, _ = node:range() -- (0,0)
--     if startline + 1 >= wininfo.topline then
--       local target = { node = node, pos = { startline + 1, startcol + 1 } }
--       table.insert(targets, target)
--     end
--   end
--   if #targets >= 1 then
--     return targets
--   end
-- end

-- local function select_range(target)
--   local mode = api.nvim_get_mode().mode
--   if not mode:match("n?o") then
--     -- Force going back to Normal (implies mode = v | V | ).
--     vim.cmd("normal! " .. mode)
--   end
--   ts_utils.update_selection(
--     0,
--     target.node,
--     mode:match("V") and "linewise" or mode:match("") and "blockwise" or "charwise"
--   )
-- end

-- local function leap_ast()
--   require("leap").leap({
--     targets = get_ast_nodes(),
--     action = api.nvim_get_mode().mode ~= "n" and select_range, -- or jump
--     backward = true,
--   })
-- end
