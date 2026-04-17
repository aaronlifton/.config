local ft = "snacks_picker_list"

local function find_explorer_win()
  local wins = vim.api.nvim_list_wins()
  local explorer_win

  for _, w in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(w)
    local buf_ft = vim.bo[buf].filetype
    if buf_ft == ft then
      explorer_win = w
      break
    end
  end

  return explorer_win
end

local function focus_explorer_win(win)
  win = win or find_explorer_win()
  if not win then return false end

  vim.api.nvim_set_current_win(win)
  return true
end

local function config_subdir_root(file)
  local home = vim.uv.os_homedir()
  if not home then return nil end

  local config_dir = LazyVim.root.realpath(home .. "/.config")
  if not config_dir then return nil end

  local prefix = config_dir .. "/"
  if file:find(prefix, 1, true) ~= 1 then return nil end

  local subdir = file:sub(#prefix + 1):match("([^/]+)")
  return subdir and (config_dir .. "/" .. subdir) or nil
end

local function root_for_buf(buf)
  local file = LazyVim.root.bufpath(buf)
  if not file then return LazyVim.root.cwd() end

  local root = LazyVim.root.get({ buf = buf, normalize = true })
  if root and (file == root or file:find(root .. "/", 1, true) == 1) then return root end

  return config_subdir_root(file) or vim.fs.dirname(file) or root or LazyVim.root.cwd()
end

local function reveal_or_open(buf, opts)
  opts = opts or {}
  buf = buf or vim.api.nvim_get_current_buf()
  local root = root_for_buf(buf)
  local explorer_win = find_explorer_win()

  if explorer_win then
    focus_explorer_win(explorer_win)
    local picker = Snacks.picker.get({ source = "explorer" })[1]
    if picker then
      picker:set_cwd(root)
      Snacks.explorer.reveal(vim.tbl_extend("force", { buf = buf }, opts))
    end
  else
    Snacks.explorer(vim.tbl_extend("force", { cwd = root }, opts))
    -- Snacks.explorer.reveal(vim.tbl_extend("force", { buf = buf }, opts))
  end
end

return {
  { import = "lazyvim.plugins.extras.editor.snacks_explorer" },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = { explorer = {} },
    keys = {
      {
        "<leader>e",
        function()
          reveal_or_open(vim.api.nvim_get_current_buf())
        end,
        desc = "Explorer Snacks (root dir)",
      },
      {
        "<leader>E",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer Snacks (cwd)",
      },
      { "<leader>fe", "<leader>e", desc = "Explorer Snacks (root dir)", remap = true },
      {
        "<M-e>",
        function()
          if vim.bo.filetype == ft then
            vim.api.nvim_input("<C-w><C-p>")
          else
            local buf = vim.api.nvim_get_current_buf()
            reveal_or_open(buf)
          end
        end,
        desc = "Focus Explorer",
      },
      -- {
      --   "<leader>fe",
      --   function()
      --     local win = { input = { keys = { ["<CR>"] = { "confirm2", mode = { "n", "i" } } } } }
      --     Snacks.explorer({
      --       cwd = LazyVim.root(),
      --       layout = { preset = "center", win = win },
      --     })
      --     -- Snacks.explorer({
      --     --   cwd = LazyVim.root(),
      --     --   -- win = {
      --     --   --   input = {
      --     --   --     keys = { --       ["<CR>"] = { "confirm2", mode = { "n", "i" } }, --     },
      --     --   --   },
      --     --   -- },
      --     --   -- actions = {
      --     --   --   confirm2 = function(p) end,
      --     --   -- },
      --     --   layout = { preset = "center" },
      --     -- })
      --   end,
      --   "Explorer Snacks (root dir)",
      -- },
      -- {
      --   "<leader>fE",
      --   function()
      --     Snacks.explorer({ layout = { preset = "center" } })
      --   end,
      --   desc = "Explorer Snacks (cwd)",
      -- },
    },
  },
}
