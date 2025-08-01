---@class util.fzf.finders
local M = {}

local get_runtime_dir = function()
  return vim.fn.stdpath("config")
end

function M.grep_config_files(opts)
  local dir = get_runtime_dir()
  require("fzf-lua").live_grep({
    prompt = "My Config>",
    cwd = dir,
  })
end

function M.find_config_files(opts)
  opts = opts or {}
  local dir = get_runtime_dir()
  require("fzf-lua").files({
    prompt = "My Config>",
    cwd = dir,
  })
end

function M.find_lazyvim_files(opts)
  require("fzf-lua").files({
    prompt = "Util.lazy files>",
    cwd = get_lazyvim_base_dir(),
  })
end

function M.grep_lazyvim_files(opts)
  require("fzf-lua").live_grep({
    prompt = "Util.lazy files>",
    cwd = get_lazyvim_base_dir(),
  })
end

function M.grep_neovim_plugins(opts)
  require("fzf-lua").live_grep({
    prompt = "Neovim plugins>",
    cwd = vim.fn.fnamemodify(get_lazyvim_base_dir(), ":h"),
  })
end

return M
