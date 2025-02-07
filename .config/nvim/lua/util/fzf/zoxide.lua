---@class util.fzf.zoxide
local M = {}

local fzf_lua = require("fzf-lua")
local fzf_utils = require("fzf-lua.utils")

local function sort_results(result)
  local max_rank_width = 0
  local function parselines()
    local pairs = {}
    for _, line in ipairs(result) do
      local num, path = line:match("^%s*(%d+%.?%d*)%s+(.+)$")
      if num and path then
        table.insert(pairs, { tonumber(num), path })
        if #num > max_rank_width then max_rank_width = #num end
      end
    end
    return pairs
  end

  -- sort the paths by the first number
  local pairs = parselines()
  table.sort(pairs, function(a, b)
    return a[1] > b[1]
  end)

  return pairs, max_rank_width
end

local function make_entries(results)
  local paths = {}
  for _, pair in ipairs(results) do
    table.insert(paths, pair[2])
  end

  return paths
end

M.fzf_zoxide = function()
  local handle = io.popen("zoxide query -ls")
  if not handle then return end
  local result = handle:read("*a")
  handle:close()
  local lines = {}
  for s in result:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  local sorted_results = sort_results(lines)
  local entries = make_entries(sorted_results)

  local opts = {
    fzf_opts = { ["--no-sort"] = true, ["--exact"] = true },
    fzf_colors = true,
    previewer = false,
    winopts = {
      height = 0.25,
      width = 0.4,
      -- row = 0.45,
    },
    actions = {
      ["default"] = function(selected)
        require("fzf-lua").files({ fzf_opts = { ["--layout"] = "reverse-list" }, cwd = selected[1] })
      end,
    },
  }

  fzf_lua.fzf_exec(entries, opts)
end

local function make_entry(result, opts)
  local rank, path = unpack(result)
  local format_string = "%-" .. (opts.max_width + 11) .. "s %s"
  return string.format(format_string, fzf_utils.ansi_codes.green(tostring(rank)), path)
end

function M.fzf_zoxide_async()
  -- fzf-lua/lua/fzf-lua/providers/oldfiles.lua:47
  local contents = function(cb)
    local function add_entry(x, co, opts)
      x = make_entry(x, opts)
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

      local handle = io.popen("zoxide query -ls")
      if not handle then return end
      local result = handle:read("*a")
      handle:close()
      local lines = {}
      for s in result:gmatch("[^\r\n]+") do
        table.insert(lines, s)
      end
      local sorted_results, max_rank_width = sort_results(lines)

      -- local start = os.time(); for _ = 1,10000,1 do
      for _, file in ipairs(sorted_results) do
        add_entry(file, co, { max_width = max_rank_width })
      end
      -- end; print("took", os.time()-start, "seconds.")

      -- done
      cb(nil)
    end)()
  end

  local opts = {
    fzf_opts = { ["--no-sort"] = true, ["--exact"] = true },
    fzf_colors = true,
    previewer = false,
    prompt = "zoxide❯ ",
    winopts = {
      height = 0.25,
      width = 0.4,
      -- row = 0.45,
    },
    actions = {
      ["default"] = function(selected)
        local path = selected[1]:match("%s+(.+)$")
        require("fzf-lua").files({ fzf_opts = { ["--layout"] = "reverse-list" }, cwd = path })
      end,
    },
  }

  fzf_lua.fzf_exec(contents, opts)
end

return M
