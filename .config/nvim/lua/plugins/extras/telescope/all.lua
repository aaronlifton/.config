if vim.g.lazyvim_picker == "fzf" then
  return {
    { import = "plugins.extras.telescope.live-grep-fzf" },
    { import = "plugins.extras.telescope.urlview" },
  }
else
  return {
    { import = "plugins.extras.telescope.import" },
    { import = "plugins.extras.telescope.lazy" },
    { import = "plugins.extras.telescope.live-grep-telescope" },
    { import = "plugins.extras.telescope.undotree" },
    { import = "plugins.extras.telescope.urlview" },
    { import = "plugins.extras.telescope.zoxide" },
    -- { import = "plugins.extras.telescope.all-recent" },
  }
end
