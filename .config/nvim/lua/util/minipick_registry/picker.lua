local M = {}

-- Helpers
local H = {}

function H.is_array_of(x, ref_type)
  if not vim.islist(x) then return false end
  for i = 1, #x do
    if type(x[i]) ~= ref_type then return false end
  end
  return true
end

function H.hl_group_or(group, fallback)
  if vim.fn.hlexists(group) == 1 then return group end
  return fallback
end

function H.is_executable(tool)
  if tool == "fallback" then return true end
  return vim.fn.executable(tool) == 1
end

function H.get_config(config)
  return vim.tbl_deep_extend("force", MiniPick.config, vim.b.minipick_config or {}, config or {})
end

function H.full_path(path)
  return (vim.fn.fnamemodify(path, ":p"):gsub("(.)/$", "%1"))
end

function H.is_hidden_path(path)
  if path:sub(1, 1) == "." then return true end
  return path:find("/%.") ~= nil
end

-- Pickers ---------------------------------------------------------------------
function M.pick_files(cwd, local_opts, opts)
  local_opts = local_opts or {}
  if local_opts.matcher == nil then local_opts.matcher = "auto" end
  if local_opts.auto == nil then local_opts.auto = { threshold = 20000 } end

  opts = opts or {}
  opts.source = opts.source or {}
  opts.source.cwd = opts.source.cwd or cwd or LazyVim.root()

  require("mini.pick").registry.fuzzy_files(local_opts, opts)
end

function M.pick_grep(pattern, local_opts, opts)
  pattern = pattern or Util.selection.get_visual_selection()
  if not pattern or pattern == "" then return end

  local_opts = local_opts or {}
  opts = opts or {}
  opts.source = opts.source or {}
  opts.source.cwd = opts.source.cwd or LazyVim.root()
  local_opts.pattern = pattern

  local MiniPick = require("mini.pick")
  MiniPick.registry.rg_grep(local_opts, opts)
end

function M.pick_grep_live(local_opts, opts)
  local_opts = local_opts or {}
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", { source = { cwd = nil }, hinted = { enable = false } }, opts)

  local path = vim.api.nvim_buf_get_name(0)
  local mason_package_dir = ("/Users/%s/.local/share/nvim/mason/packages"):format(vim.env.USER)
  local mise_gem_dir = ("/Users/%s/"):format(vim.env.USER)
    .. ".local/share/mise/installs/ruby/%d+%.%d+%.%d+/lib/ruby/gems/%d+%.%d+%.%d+/gems"

  if path:match(mason_package_dir) then
    local gem_root = path:match(mason_package_dir .. "/ruby%-lsp/gems/[^/]+")
    if gem_root then opts.source.cwd = gem_root end
  elseif path:match(mise_gem_dir) then
    local gem_root = path:match(mise_gem_dir .. "/[^/]+")
    if gem_root then opts.source.cwd = gem_root end
  end
  if not opts.source.cwd then opts.source.cwd = LazyVim.root() end

  local MiniPick = require("mini.pick")
  MiniPick.registry.rg_live_grep(local_opts, opts)
end

function M.pick_lsp2(local_opts, opts)
  opts = opts or {}
  local MiniPick = require("mini.pick")
  if not MiniPick.registry.lsp2 then require("util.minipick_registry.lsp2").setup(MiniPick) end
  opts = vim.tbl_deep_extend("force", opts, { hinted = { enable = true, use_autosubmit = true } })
  return MiniPick.registry.lsp2(local_opts, opts)
end

-- Utils -----------------------------------------------------------------------
function M.symbol_query_from_kind_filter()
  local kind_filter = LazyVim.config.kind_filter
  if kind_filter == nil then return nil end

  local ft = vim.bo.filetype
  if ft == "markdown" or ft == "help" then return nil end

  if type(kind_filter) ~= "table" then return kind_filter end
  if kind_filter[ft] ~= nil then return kind_filter[ft] end
  if kind_filter.default ~= nil then return kind_filter.default end
  return kind_filter
end

function M.get_visual_selection()
  local lines = require("util.selection").getVisualSelectionLines()
  if not lines or vim.tbl_isempty(lines) then return nil end
  return vim.trim(table.concat(lines, "\n"))
end

-- Dirs ------------------------------------------------------------------------

function M.cwd_dir()
  return vim.fn.getcwd()
end

function M.node_modules_dir()
  local path = vim.fs.joinpath(LazyVim.root(), "node_modules")
  if vim.fn.isdirectory(path) == 0 then
    vim.notify("node_modules directory not found: " .. path, vim.log.levels.WARN)
    return nil
  end
  return path
end

function M.lazyvim_plugins_dir()
  return vim.fn.fnamemodify(get_lazyvim_base_dir(), ":h")
end

function M.node_module_subdir()
  local cwd = vim.fn.expand("%:p:h")
  local start = string.find(cwd, "node_modules/")
  if start then
    local display = vim.fn.fnamemodify(cwd, ":t")
    return { path = cwd, display = display }
  end
  vim.api.nvim_echo({ { "Not a path within a node_modules folder", "Normal" } }, false, {})
  return nil
end

function M.ruby_gem_subdir()
  local cwd = vim.fn.expand("%:p:h")
  local start = string.find(cwd, "gems/")
  if start then
    local ruby_version = vim.fn.fnamemodify(cwd, ":h:h:t")
    local gem_dir = vim.fn.fnamemodify(cwd, ":t")
    local display = ("%sruby/%s/gems/%s").format("…", ruby_version, gem_dir)
    return { path = cwd, display = display }
  end
  vim.api.nvim_echo({
    { "Not a path within a ", "Normal" },
    { "gems", "Special" },
    { " folder", "Normal" },
  }, false, {})
  return nil
end

M.H = H
return M
