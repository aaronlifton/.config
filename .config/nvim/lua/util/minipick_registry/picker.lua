local M = {}

function M.root_dir()
  local buf = vim.api.nvim_get_current_buf()
  return Snacks.git.get_root(Util.path.bufdir(buf))
end

function M.cwd_dir()
  return vim.fn.getcwd()
end

local default_files_local_opts = {
  matcher = "auto", -- "fzf" | "fzf_dp" | "auto"
  auto = { threshold = 20000 },
}

function M.pick_files(cwd, local_opts, opts)
  local_opts = vim.tbl_extend("force", local_opts or {}, default_files_local_opts)
  opts = vim.tbl_deep_extend("force", { source = { cwd = cwd } }, opts or {})
  -- require("mini.pick").builtin.files({}, { source = { cwd = cwd } })
  require("mini.pick").registry.fuzzy_files(local_opts, opts)
end

function M.pick_grep(pattern, local_opts, opts)
  pattern = pattern or Util.selection.get_visual_selection()
  if not pattern or pattern == "" then return end

  local_opts = local_opts or {}
  opts = opts or {}
  local_opts.pattern = pattern

  local MiniPick = require("mini.pick")
  MiniPick.registry.rg_grep(local_opts, opts)
end

function M.pick_grep_live(local_opts, opts)
  local_opts = local_opts or {}
  opts = opts or {}

  opts = vim.tbl_deep_extend("force", opts, { hinted = { enable = false } })

  local MiniPick = require("mini.pick")
  MiniPick.registry.rg_live_grep(local_opts, opts)
  -- if query and query ~= "" then vim.schedule(function()
  --   pcall(MiniPick.set_picker_query, { query })
  -- end) end
end

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

function M.pick_lsp2(local_opts, opts)
  opts = opts or {}
  local MiniPick = require("mini.pick")
  if not MiniPick.registry.lsp2 then require("util.minipick_registry.lsp2").setup(MiniPick) end
  opts = vim.tbl_deep_extend("force", opts, { hinted = { enable = true, use_autosubmit = true } })
  return MiniPick.registry.lsp2(local_opts, opts)
end

function M.get_visual_selection()
  local lines = require("util.selection").getVisualSelectionLines()
  if not lines or vim.tbl_isempty(lines) then return nil end
  return vim.trim(table.concat(lines, "\n"))
end

function M.node_modules_dir()
  local path = vim.fs.joinpath(M.root_dir(), "node_modules")
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

M.grep_files = function(opts)
  M.pick_grep_live({ source = { cwd = M.root_dir() } })
end

return M
