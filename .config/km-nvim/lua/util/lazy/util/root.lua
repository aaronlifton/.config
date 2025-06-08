---@class util.lazy.root
---@overload fun(): string
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.get(...)
  end,
})

local specs = { "lsp", { ".git", "lua" }, "cwd" }

M.detectors = {}

function M.detectors.cwd()
  return { vim.loop.cwd() }
end

function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then return {} end
  local roots = {} ---@type string[]
  for _, client in pairs(Util.lazy.lsp.get_clients({ bufnr = buf })) do
    local workspace = client.config.workspace_folders
    if workspace then
      for _, ws in pairs(workspace) do
        roots[#roots + 1] = vim.uri_to_fname(ws.uri)
      end
    end
  end
  return vim.tbl_filter(function(path)
    path = Util.lazy.norm(path)
    return path and (vim.loop.fs_stat(path) or {}).type == "directory"
  end, roots)
end

function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "string" and { patterns } or patterns
  local path = M.bufpath(buf) or vim.loop.cwd()
  local pattern = vim.fs.find(patterns, { path = path, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.bufpath(buf)
  return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

function M.cwd()
  return M.realpath(vim.loop.cwd()) or ""
end

function M.realpath(path)
  if path == "" or path == nil then return nil end
  path = vim.loop.fs_realpath(path) or path
  return Util.lazy.norm(path)
end

---@param spec LazyRootSpec
---@return LazyRootFn
function M.resolve(spec)
  if M.detectors[spec] then return M.detectors[spec] end
  if type(spec) == "function" then return spec end
  return function(buf)
    return M.detectors.pattern(buf, spec)
  end
end

---@param opts? { buf?: number, spec?: LazyRootSpec[], all?: boolean }
function M.detect(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local ret = {} ---@type LazyRoot[]
  for _, spec in ipairs(opts.spec or M.specs or specs) do
    local paths = M.resolve(spec)(buf)
    paths = paths or {}
    paths = type(paths) == "string" and { paths } or paths
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then
        roots[#roots + 1] = pp
      end
    end
    table.sort(roots, function(a, b)
      return #a > #b
    end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then break end
    end
  end
  return ret
end

function M.info()
  local spec = type(M.specs) == "table" and table.concat(M.specs, ", ") or M.specs
  local roots = M.detect({ all = true })
  local lines = {} ---@type string[]
  local first = true
  for _, root in ipairs(roots) do
    for _, path in ipairs(root.paths) do
      lines[#lines + 1] = ("- [%s] `%s` **(%s)**"):format(
        first and "x" or " ",
        path,
        type(root.spec) == "table" and table.concat(root.spec, ", ") or root.spec
      )
      first = false
    end
  end
  require("lazy.core.util").info(
    table.concat(lines, "\n"),
    { title = "LazyVim Roots (" .. spec .. ")" }
  )
  return roots
end

---@return string
function M.get(opts)
  local buf = opts and opts.buf or vim.api.nvim_get_current_buf()
  local ret = M.detect({ buf = buf, all = false })
  if opts and opts.warn and #ret == 0 then
    require("lazy.core.util").warn("No root found")
  end
  return ret[1] and ret[1].paths[1] or vim.loop.cwd()
end

---@return string
function M.git()
  local root = M.get()
  local git_root = vim.fs.find(".git", { path = root, upward = true })[1]
  local ret = git_root and vim.fn.fnamemodify(git_root, ":h") or root
  return ret
end

---@return string
function M.prettify(root)
  return root == vim.loop.cwd() and "." or root
end

return M 