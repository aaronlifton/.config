local M = {}

local _, builtin = pcall(require, "telescope.builtin")
local _, finders = pcall(require, "telescope.finders")
local _, pickers = pcall(require, "telescope.pickers")
local _, sorters = pcall(require, "telescope.sorters")
local _, themes = pcall(require, "telescope.themes")
local _, actions = pcall(require, "telescope.actions")
local _, previewers = pcall(require, "telescope.previewers")
local _, make_entry = pcall(require, "telescope.make_entry")

local get_runtime_dir = function()
  return vim.fn.stdpath("config")
end

local lvim_dir = vim.fn.expand("~/.local/share/lunarvim/lvim")
local doom_dir = vim.fn.expand("~/.config/doom-nvim")
local astrovim_dir = vim.fn.expand("~/.config/astrovim")
local ftw_dir = vim.fn.expand("~/Code/dotfiles/Matt-FTW-dotfiles/.config/nvim")
local nyoom_dir = vim.fn.expand("~/.config/nyoom.nvim")
local niocalbanese_dir = vim.fn.expand("~/Code/dotfiles/nicoalbanese/.config/nvim")
local modern_nvim_dir = vim.fn.expand("~/Code/dotfiles/modern-neovim")
local nvim_pde_dir = vim.fn.expand("~/.config/neovim-pde")
local folk_dir = vim.fn.expand("~/Code/dotfiles/folke-nvim")
local dots_dir = vim.fn.expand("~/Code/dotfiles/nvim-dots")
local inspiration_dirs = {
  doom = doom_dir,
  lvim = lvim_dir,
  astrovim = astrovim_dir,
  ftw = ftw_dir,
  nyoom = nyoom_dir,
  nicoalbanese = niocalbanese_dir,
  modern = modern_nvim_dir,
  pde = nvim_pde_dir,
  folke = folk_dir,
  dots = dots_dir,
}

local inspiration_dirs_list = {}
for _, dir in pairs(inspiration_dirs) do
  table.insert(inspiration_dirs_list, dir)
end

function M.grep_config_files(opts)
  local dir = get_runtime_dir()
  local theme_opts = themes.get_ivy({
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    prompt_prefix = ">> ",
    prompt_title = "~ Search My Config ~",
    cwd = dir,
    search_dirs = { dir },
  })
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.live_grep(opts)
end

function M.find_config_files(opts)
  local dir = get_runtime_dir()
  opts = opts or {}
  local base_dir = get_lazyvim_base_dir()
  -- get parent foler
  local theme_opts = themes.get_ivy({
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    prompt_prefix = ">> ",
    prompt_title = "~ Search My Config (Files) ~",
    cwd = dir,
    search_dirs = { dir },
  })
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.find_files(opts)
end

function M.find_config_files_cursor(opts)
  local dir = get_runtime_dir()
  opts = opts or {}
  local base_dir = get_lazyvim_base_dir()
  -- get parent foler
  local theme_opts = themes.get_dropdown({
    sorting_strategy = "ascending",
    layout_strategy = "cursor",
    prompt_prefix = ">> ",
    prompt_title = "~ Search My Config (Files) ~",
    cwd = dir,
    search_dirs = { dir },
  })
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.find_files(opts)
end

function M.find_lazyvim_plugins(opts)
  opts = opts or {}
  local base_dir = get_lazyvim_base_dir()
  -- get parent foler
  local parent_dir = vim.fn.fnamemodify(base_dir, ":h")
  local theme_opts = themes.get_ivy({
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    prompt_prefix = ">> ",
    prompt_title = "~ LazyVim plugins~",
    cwd = get_runtime_dir(),
    search_dirs = { parent_dir },
  })
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.find_files(opts)
end

function M.grep_dir(name, opts)
  local theme_opts = themes.get_ivy({
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    prompt_prefix = ">> ",
    prompt_title = "~ Search " .. name .. " Config ~",
    cwd = inspiration_dirs[name],
    search_dirs = { inspiration_dirs[name] },
  })
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.live_grep(opts)
end

function M.grep_inspiration_files(opts)
  local dir = get_runtime_dir()
  local theme_opts = themes.get_ivy({
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    prompt_prefix = ">> ",
    prompt_title = "~ Search Inspiration Configs (Lunar, Doom, FTW) ~",
    cwd = dir,
    search_dirs = inspiration_dirs_list,
  })
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.live_grep(opts)
end

function M.find_lazyvim_files(opts)
  opts = opts or {}
  local theme_opts = themes.get_ivy({
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    prompt_prefix = ">> ",
    prompt_title = "~ LazyVim files ~",
    cwd = get_runtime_dir(),
    search_dirs = { get_lazyvim_base_dir() },
  })
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.find_files(opts)
end

function M.grep_lazyvim_files(opts)
  opts = opts or {}
  local theme_opts = themes.get_ivy({
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    prompt_prefix = ">> ",
    prompt_title = "~ search lazyVim ~",
    cwd = get_runtime_dir(),
    search_dirs = { get_lazyvim_base_dir() },
  })
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.live_grep(opts)
end

local copy_to_clipboard_action = function(prompt_bufnr)
  local _, action_state = pcall(require, "telescope.actions.state")
  local entry = action_state.get_selected_entry()
  local version = entry.value
  vim.fn.setreg("+", version)
  vim.fn.setreg('"', version)
  vim.notify("Copied " .. version .. " to clipboard", vim.log.levels.INFO)
  actions.close(prompt_bufnr)
end

function M.view_lazyvim_changelog()
  local opts = themes.get_ivy({
    cwd = get_lazyvim_base_dir(),
  })
  opts.entry_maker = make_entry.gen_from_git_commits(opts)

  pickers
    .new(opts, {
      prompt_title = "~ LazyVim Changelog ~",

      finder = finders.new_oneshot_job(
        vim.tbl_flatten({
          "git",
          "log",
          "--pretty=oneline",
          "--abbrev-commit",
        }),
        opts
      ),
      previewer = {
        previewers.git_commit_diff_as_was.new(opts),
      },

      --TODO: consider opening a diff view when pressing enter
      attach_mappings = function(_, map)
        map("i", "<enter>", copy_to_clipboard_action)
        map("n", "<enter>", copy_to_clipboard_action)
        map("i", "<esc>", actions.close)
        map("n", "<esc>", actions.close)
        map("n", "q", actions.close)
        return true
      end,
      sorter = sorters.generic_sorter,
    })
    :find()
end

-- Smartly opens either git_files or find_files, depending on whether the working directory is
-- contained in a Git repo.
function M.find_project_files(opts)
  opts = opts or {}
  local ok = pcall(builtin.git_files, opts)

  if not ok then builtin.find_files(opts) end
end

return M
