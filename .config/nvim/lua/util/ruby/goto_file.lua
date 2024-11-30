local M = {}
-- Function to handle Rails file navigation (similar to gf)
M.rails_goto_file = function()
  -- Get the word under cursor
  local cfile = vim.fn.expand("<cfile>")

  -- Get the current buffer's rails root directory
  local rails_root = vim.b.rails_root
  if not rails_root then
    -- Try to find rails root from current file path
    local current_file = vim.fn.expand("%:p")
    rails_root = vim.fn.fnamemodify(vim.fn.findfile("config/environment.rb", current_file .. ";"), ":h:h")
    if rails_root == "" then
      vim.notify("Not in a Rails project", vim.log.levels.ERROR)
      return
    end
  end

  -- List of common Rails paths to search
  local search_paths = {
    "app/models",
    "app/controllers",
    "app/views",
    "app/helpers",
    "app/mailers",
    "app/jobs",
    "lib",
    "test",
    "spec",
    "config",
  }

  -- Convert Ruby constant style to file path style
  local file_path = string.gsub(cfile, "::", "/"):gsub("(%u)(%l)", "_%1%2"):lower():gsub("^_", "")
  if not file_path:match("%.rb$") then file_path = file_path .. ".rb" end

  -- Search for the file in Rails paths
  for _, path in ipairs(search_paths) do
    local full_path = rails_root .. "/" .. path .. "/" .. file_path
    if vim.fn.filereadable(full_path) == 1 then
      -- Open the file
      vim.cmd("edit " .. vim.fn.fnameescape(full_path))
      return
    end
  end

  -- If file not found, try alternate conventions
  local alt_path = vim.fn["rails#ruby_cfile"]()
  if alt_path and alt_path ~= "" and vim.fn.filereadable(rails_root .. "/" .. alt_path) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(rails_root .. "/" .. alt_path))
    return
  end

  vim.notify("Could not find file: " .. cfile, vim.log.levels.WARN)
end

M.setup_keymaps = function()
  -- Set up the keymap
  vim.api.nvim_set_keymap("n", "gf", "<cmd>lua rails_goto_file()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-W>f", "<cmd>split | lua rails_goto_file()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap(
    "n",
    "<C-W><C-F>",
    "<cmd>split | lua rails_goto_file()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap("n", "<C-W>gf", "<cmd>tabe | lua rails_goto_file()<CR>", { noremap = true, silent = true })
end

return M
