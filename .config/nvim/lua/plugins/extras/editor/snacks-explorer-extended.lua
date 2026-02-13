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
  if not win then return end

  vim.api.nvim_set_current_win(win)
end

local function reveal_or_open(opts)
  opts = opts or {}
  local explorer_win = find_explorer_win()

  if explorer_win then
    vim.api.nvim_set_current_win(explorer_win)
    -- local buf = vim.api.nvim_get_current_buf()
    -- Snacks.explorer.reveal(vim.tbl_extend("force", { buf = buf }, opts))
  else
    Snacks.explorer(opts)
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
          reveal_or_open({ cwd = LazyVim.root() })
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
            focus_explorer_win()
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
