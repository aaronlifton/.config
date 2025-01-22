-- https://github.com/FelipeSanchezSoberanis/copy-path
local ts = require("vim.treesitter")

---@param lang? string parser languge override
---@return TSNode
local function get_root_node(lang)
  local parser = ts.get_parser(nil, lang)
  local tree = parser:parse()[1]
  return tree:root()
end

---@param lang? string parser languge override
---@return TSNode
local function get_current_node(lang)
  local opts = lang and { lang = lang } or nil
  local current_node = ts.get_node(opts)
  if current_node == nil then error("Could not get current node") end
  return current_node
end

local function named_child_by_name(node, name)
  for _, child in ipairs(node:named_children()) do
    if child:name() == name then return child end
  end
end

--- @param argument_list TSNode
local function argument_list_to_string(argument_list)
  -- for child in argument_list:iter_children() do
  --   vim.api.nvim_echo({ { vim.inspect(ts.get_node_text(child, 0)), "Normal" } }, true, {})
  -- end
  local parts = {}
  for _, child in ipairs(argument_list:named_children()) do
    table.insert(parts, ts.get_node_text(child, 0))
  end
  return table.concat(parts, ", ")
end

local function json_javascript_traversed_nodes_to_path(parts)
  local path = ""
  for i = #parts, 1, -1 do
    path = path .. parts[i].text
    if i ~= 1 then path = path .. "." end
  end
  return string.gsub(path, "%.%[", "[")
end

local M = {}

---@class PathConfigOpts
---@field lang string Language for the parser
---@field searchable_node_types table<string, boolean> Node types that should be included in the path
---@field stop_node_types? string[] Optional node type to stop traversal at
---@field get_parent_text fun(node: TSNode): string? function to extract parent text
---@field get_cursor_node_part fun(node: TSNode): string? function to extract current node text
---@field traversed_nodes_to_path fun(traversed_nodes: string[]): string function to convert traversed nodes to path

---@class PathConfig
---Base function to copy treesitter path
---@param args table opts including register
---@param opts PathConfigOpts opts for path extraction
local function copy_path_base(args, opts)
  local register = args.register
  local root_node = get_root_node(opts.lang)
  -- local current_node = get_current_node(opts.lang)
  local current_node = ts.get_node({ lang = opts.lang })

  local traversed_nodes = {}
  local prev_node

  if current_node and opts.get_cursor_node_part then
    local cursor_node_part = opts.get_cursor_node_part(current_node)
    if cursor_node_part then table.insert(traversed_nodes, cursor_node_part) end
  end
  while
    current_node ~= nil
    and current_node ~= root_node
    and (not opts.stop_node_types or not vim.tbl_contains(opts.stop_node_types, current_node:type()))
  do
    local key_name_part = opts.get_parent_text(current_node)
    if key_name_part then
      table.insert(traversed_nodes, key_name_part)
    elseif opts.searchable_node_types[current_node:type()] then
      if current_node:type() == "array" and prev_node then
        for i, child_node in ipairs(current_node:named_children()) do
          if child_node == prev_node then
            table.insert(traversed_nodes, { type = "array_element", text = "[" .. i - 1 .. "]" })
            prev_node = nil
            break
          end
        end
      end
      prev_node = current_node
    end
    current_node = current_node:parent()
  end

  -- Handle stop node if configured
  if opts.stop_node_types and current_node and vim.tbl_contains(opts.stop_node_types, current_node:type()) then
    local name_node = current_node:named_children()[1]
    table.insert(traversed_nodes, { type = current_node:type(), text = ts.get_node_text(name_node, 0) })
  end

  local path = opts.traversed_nodes_to_path(traversed_nodes)
  vim.fn.setreg(register, path)
  print("Path " .. path .. " copied to register " .. register)
end

M.copy_json_path = function(args)
  copy_path_base(args, {
    lang = "json",
    get_parent_text = function(current_node)
      if current_node:type() == "pair" then
        local key_node = current_node:named_children()[1]
        if key_node then
          local named_child = key_node:named_child(0)
          if named_child then return { type = named_child:type(), text = ts.get_node_text(named_child, 0) } end
        end
      end
    end,
    traversed_nodes_to_path = json_javascript_traversed_nodes_to_path,
    searchable_node_types = {
      ["string"] = true,
      ["number"] = true,
      ["true"] = true,
      ["false"] = true,
      ["object"] = true,
      ["array"] = true,
      ["null"] = true,
    },
  })
end

M.copy_javascript_path = function(args)
  copy_path_base(args, {
    lang = "javascript",
    get_parent_text = function(current_node)
      if current_node:type() == "pair" then
        local key_node = current_node:named_children()[1]
        if key_node then
          local named_child = key_node:named_child(0)
          if named_child then return { type = named_child:type(), text = ts.get_node_text(named_child, 0) } end
        end
      end
    end,
    traversed_nodes_to_path = json_javascript_traversed_nodes_to_path,
    searchable_node_types = {
      ["string"] = true,
      ["number"] = true,
      ["true"] = true,
      ["false"] = true,
      ["object"] = true,
      ["array"] = true,
      ["null"] = true,
      ["undefined"] = true,
      ["arrow_function"] = true,
      ["identifier"] = true,
    },
    stop_node_types = { "variable_declarator" },
  })
end

M.copy_ruby_path = function(args)
  copy_path_base(args, {
    lang = "ruby",
    ---@param current_node TSNode
    get_parent_text = function(current_node)
      if current_node:type() == "module" or current_node:type() == "class" then
        local named_child = current_node:named_child(0)
        if named_child then return { type = named_child:type(), text = ts.get_node_text(named_child, 0) } end
      end
    end,
    ---@param current_node TSNode
    get_cursor_node_part = function(current_node)
      if current_node:named() then
        local parent = current_node:parent()
        if not parent then return end

        if parent:type() == "argument_list" then
          local argument_list = argument_list_to_string(parent)
          -- vim.api.nvim_echo({ { "argument list: ", "Title" }, { vim.inspect(argument_list), "Normal" } }, true, {})

          local parent2 = parent:parent()
          if not parent2 then return end

          local node_text = ts.get_node_text(current_node, 0)
          local method_name
          if parent2:type() == "call" then
            local parent3 = parent2:parent()
            if not parent3 then return end

            local method_node = parent2:named_child(0)
            if not method_node then return end

            method_name = ts.get_node_text(method_node, 0)
            -- vim.api.nvim_echo({ { vim.inspect(method_name), "Normal" } }, true, {})
            if parent3:type() == "body_statement" then
              local parent4 = parent3:parent()
              if not parent4 then return end

              if parent4:type() == "class" then
                return { type = "class_call", text = method_name .. ": " .. node_text }
              else
                return { type = "call", text = method_name .. "(" .. argument_list .. ")" }
              end
            else
              return { type = "call", text = method_name .. "(" .. argument_list .. ")" }
            end
          end
        end
        if parent:type() == "method" then
          -- local named_child = parent:named_child(0)
          -- if not named_child then return end
          -- return { type = "method", text = ts.get_node_text(named_child, 0) }

          return { type = "method", text = ts.get_node_text(current_node, 0) }
        elseif parent:type() == "singleton_method" then
          return { type = "singleton_method", text = ts.get_node_text(current_node, 0) }
        end
      end
    end,
    traversed_nodes_to_path = function(parts)
      local path = ""
      for i = #parts, 1, -1 do
        local part = parts[i]
        path = path .. part.text
        if i ~= 1 then
          -- Look at the next part's type to determine separator
          local next_part = parts[i - 1]
          if next_part.type == "method" then
            path = path .. "#"
          elseif next_part.type == "singleton_method" or next_part.type == "class_call" then
            path = path .. "."
          else
            path = path .. "::"
          end
        end
      end
      return string.gsub(path, "%.%[", "[")
    end,
    searchable_node_types = {
      ["string"] = true,
      ["integer"] = true,
      ["float"] = true,
      ["true"] = true,
      ["false"] = true,
      ["hash"] = true,
      ["array"] = true,
      ["nil"] = true,
      ["symbol"] = true,
    },
    -- stop_node_types = { "method", "singleton_method" },
  })
end

return M
