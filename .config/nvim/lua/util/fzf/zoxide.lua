local M = {}
local function sort(result)
  local function parselines()
    local pairs = {}
    for _, line in ipairs(result) do
      for num, path in line:gmatch("(%d?%d+%.%d*)%s+(%S+)") do
        table.insert(pairs, { num, path })
      end
    end
    return pairs
  end

  -- sort the paths by the first number
  local pairs = parselines()
  table.sort(pairs, function(a, b)
    return a[1] > b[1]
  end)
  local paths = {}
  for _, pair in ipairs(pairs) do
    table.insert(paths, pair[2])
  end

  return paths
end

M.fzf_zoxide = function()
  local handle = io.popen("zoxide query -ls")
  if not handle then
    return
  end
  local result = handle:read("*a")
  handle:close()
  local lines = {}
  for s in result:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  local sorted_results = sort(lines)

  local fzf_lua = require("fzf-lua")

  local opts = {
    fzf_opts = {},
    fzf_colors = true,
    actions = {
      ["default"] = function(selected)
        require("fzf-lua").files({ fzf_opts = { ["--layout"] = "reverse-list" }, cwd = selected[1] })
      end,
    },
  }
  fzf_lua.fzf_exec(sorted_results, opts)
end

function M.fzf_zoxide2()
  local cwd = vim.fn.getcwd()
  local cb = function(result)
    local lines = {}
    for s in result:gmatch("[^\r\n]+") do
      table.insert(lines, s)
    end
    vim.api.nvim_echo({ { vim.inspect(lines), "Normal" } }, false, {})
  end
  vim.fn.jobstart({ "zoxide", "query", "-ls" }, {
    cwd = cwd,
    on_stdout = function(chan_id, data, name)
      -- print(vim.inspect(data))
      -- table.insert(parts, data)
      -- print(parts)
      cb(data)
    end,
  })
end

return M
