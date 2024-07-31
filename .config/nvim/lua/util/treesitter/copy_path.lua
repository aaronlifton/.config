-- https://github.com/FelipeSanchezSoberanis/copy-path
local ts = require("vim.treesitter")

local function get_root_node()
  local parser = ts.get_parser()
  local tree = parser:parse()[1]
  return tree:root()
end

local function get_current_node()
  local current_node = ts.get_node()
  if current_node == nil then
    error("Could not get current node")
  end
  return current_node
end

local function traversed_nodes_to_path(traversed_nodes)
  local path = ""
  for i = #traversed_nodes, 1, -1 do
    path = path .. traversed_nodes[i]
    if i ~= 1 then
      path = path .. "."
    end
  end
  return string.gsub(path, "%.%[", "[")
end

local M = {}

M.copy_json_path = function(args)
  local register = args.register

  local root_node = get_root_node()
  local current_node = get_current_node()

  local searchable_node_types = {
    ["string"] = true,
    ["number"] = true,
    ["true"] = true,
    ["false"] = true,
    ["object"] = true,
    ["array"] = true,
    ["null"] = true,
  }

  local traversed_nodes = {}
  local prev_node

  while current_node ~= root_node do
    if current_node:type() == "pair" then
      local key_node = current_node:named_children()[1]
      local key_name = ts.get_node_text(key_node:named_child(), 0)
      table.insert(traversed_nodes, key_name)
    elseif searchable_node_types[current_node:type()] then
      if current_node:type() == "array" and prev_node then
        for i, child_node in ipairs(current_node:named_children()) do
          if child_node == prev_node then
            table.insert(traversed_nodes, "[" .. i - 1 .. "]")
            prev_node = nil
            break
          end
        end
      end
      prev_node = current_node
    end
    current_node = current_node:parent()
  end

  local path = traversed_nodes_to_path(traversed_nodes)
  vim.fn.setreg(register, path)
  print("Path " .. path .. " copied to register " .. register)
end

M.copy_javascript_path = function(args)
  local register = args.register

  local current_node = get_current_node()
  local root_node = get_root_node()

  local searchable_node_types = {
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
  }

  local traversed_nodes = {}
  local prev_node

  while current_node ~= root_node and current_node:type() ~= "variable_declarator" do
    if current_node:type() == "pair" then
      local key_node = current_node:named_children()[1]
      local key_name = ts.get_node_text(key_node, 0)
      table.insert(traversed_nodes, key_name)
    elseif searchable_node_types[current_node:type()] then
      if current_node:type() == "array" and prev_node then
        for i, child_node in ipairs(current_node:named_children()) do
          if child_node == prev_node then
            table.insert(traversed_nodes, "[" .. i - 1 .. "]")
            prev_node = nil
            break
          end
        end
      end
      prev_node = current_node
    end
    current_node = current_node:parent()
  end

  if current_node:type() == "variable_declarator" then
    local name_node = current_node:named_children()[1]
    table.insert(traversed_nodes, ts.get_node_text(name_node, 0))
  end

  local path = traversed_nodes_to_path(traversed_nodes)
  vim.fn.setreg(register, path)
  print("Path " .. path .. " copied to register " .. register)
end

return M
