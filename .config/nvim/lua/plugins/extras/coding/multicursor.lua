-- https://www.reddit.com/r/neovim/comments/1fo8wvh/multicursornvim_10_released/
local function feedkeys_action()
  local mc = require("multicursor-nvim")
  mc.action(function(ctx)
    local cursor = ctx:firstCursor()
    if cursor == nil then return end

    vim.print(cursor:getLine())
    cursor:feedkeys("ihello world")
  end)
end

vim.api.nvim_create_user_command("WordCount", feedkeys_action, { range = true })

local function keys()
  local mc = require("multicursor-nvim")
  -- stylua: ignore start
  return {
    -- Add or skip cursor above/below
    { { "n",   "v" },           "<up>",                                 "<cmd>lua require('multicursor-nvim').lineAddCursor(-1)<cr>",   { desc = "Add cursor above" } },
    { { "n",   "v" },           "<down>",                               "<cmd>lua require('multicursor-nvim').lineAddCursor(1)<cr>",    { desc = "Add cursor below" } },
    { { "n",   "v" },           "<leader><up>",                         "<cmd>lua require('multicursor-nvim').lineSkipCursor(-1)<cr>",  { desc = "Skip cursor above" } },
    { { "n",   "v" },           "<leader><down>",                       "<cmd>lua require('multicursor-nvim').lineSkipCursor(1)<cr>",   { desc = "Skip cursor below" } },

    -- Add or skip matching word/selection
    { { "n",   "v" },           "<leader>n",                            "<cmd>lua require('multicursor-nvim').matchAddCursor(1)<cr>",   { desc = "Add next matching cursor" } },
    { { "n",   "v" },           "<leader>s",                            "<cmd>lua require('multicursor-nvim').matchSkipCursor(1)<cr>",  { desc = "Skip next matching cursor" } },
    { { "n",   "v" },           "<leader>N",                            "<cmd>lua require('multicursor-nvim').matchAddCursor(-1)<cr>",  { desc = "Add previous matching cursor" } },
    { { "n",   "v" },           "<leader>S",                            "<cmd>lua require('multicursor-nvim').matchSkipCursor(-1)<cr>", { desc = "Skip previous matching cursor" } },

    -- Add all matches
    { { "n",   "v" },           "<leader>A",                            "<cmd>lua require('multicursor-nvim').matchAllAddCursors()<cr>",   { desc = "Add all matching cursors" } },

    -- Rotate main cursor
    { { "n",   "v" },           "<left>",                               "<cmd>lua require('multicursor-nvim').nextCursor()<cr>",           { desc = "Next cursor" } },
    { { "n",   "v" },           "<right>",                              "<cmd>lua require('multicursor-nvim').prevCursor()<cr>",           { desc = "Previous cursor" } },

    -- Cursor management
    { { "n",   "v" },           "<leader>x",                            "<cmd>lua require('multicursor-nvim').deleteCursor()<cr>",         { desc = "Delete cursor" } },
    { { "n" }, "<c-leftmouse>", "<cmd>lua require('multicursor-nvim').handleMouse()<cr>",                     { desc = "Toggle cursor at mouse" } },
    { { "n",   "v" },           "<c-q>",                                "<cmd>lua require('multicursor-nvim').toggleCursor()<cr>",         { desc = "Toggle cursor" } },
    { { "n",   "v" },           "<leader><c-q>",                        "<cmd>lua require('multicursor-nvim').duplicateCursors()<cr>",     { desc = "Duplicate cursors" } },
    { {"n"},   "<leader>gv",                                            "<cmd>lua require('multicursor-nvim').restoreCursors()<cr>",       { desc = "Restore cursors" } },
    { {"n"},   "<leader>a",                                             "<cmd>lua require('multicursor-nvim').alignCursors()<cr>",         { desc = "Align cursors" } },

    -- Visual mode operations
    { {"v"},   "S",                                                     "<cmd>lua require('multicursor-nvim').splitCursors()<cr>",         { desc = "Split cursors by regex" } },
    { {"v"},   "I",                                                     "<cmd>lua require('multicursor-nvim').insertVisual()<cr>",         { desc = "Insert at cursors" } },
    { {"v"},   "A",                                                     "<cmd>lua require('multicursor-nvim').appendVisual()<cr>",         { desc = "Append at cursors" } },
    { {"v"},   "M",                                                     "<cmd>lua require('multicursor-nvim').matchCursors()<cr>",         { desc = "Match cursors by regex" } },
    { {"v"},   "<leader>t",                                             "<cmd>lua require('multicursor-nvim').transposeCursors(1)<cr>",    { desc = "Transpose cursors forward" } },
    { {"v"},   "<leader>T",                                             "<cmd>lua require('multicursor-nvim').transposeCursors(-1)<cr>",   { desc = "Transpose cursors backward" } },

    -- Jumplist
    { { "v",   "n" },           "<c-i>",                                "<cmd>lua require('multicursor-nvim').jumpForward()<cr>",          { desc = "Jump forward" } },
    { { "v",   "n" },           "<c-o>",                                "<cmd>lua require('multicursor-nvim').jumpBackward()<cr>",         { desc = "Jump backward" } },

    -- Escape handling
    { {"n"},   "<esc>",                                                 "<cmd>lua if not require('multicursor-nvim').cursorsEnabled() then require('multicursor-nvim').enableCursors() elseif require('multicursor-nvim').hasCursors() then require('multicursor-nvim').clearCursors() end<cr>", { desc = "Toggle/clear cursors" } },
    { {"n"}, "<leader>f", "MultiCursorFeedKeys", { desc = "Feedkeys"}}
  }
  -- stylua: ignore end
end

local set_keymaps = function(buf)
  for _, key in ipairs(keys()) do
    local mode, lhs, rhs, opts = unpack(key)
    for _, m in ipairs(mode) do
      vim.api.nvim_buf_set_keymap(buf, m, lhs, rhs, opts)
    end
  end
end

local clear_keymaps = function(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end

  if not vim.bo[buf].buflisted then return end

  for _, key in ipairs(keys()) do
    local mode, lhs, rhs, opts = unpack(key)
    for _, m in ipairs(mode) do
      vim.api.nvim_buf_del_keymap(buf, m, lhs)
      -- pcall(vim.api.nvim_del_keymap, m, lhs)
    end
  end
end

-- Using Snacks.toggle instead
-- local toggle_multicursor_mode = function()
--   local buf = vim.api.nvim_get_current_buf()
--   vim.g.multicursor_mode_disable = not vim.g.multicursor_mode_disable
--   if vim.g.multicursor_mode_disable then
--     clear_keymaps(buf)
--   else
--     set_keymaps(buf)
--   end
-- end

return {
  "jake-stewart/multicursor.nvim",
  event = "VeryLazy", -- needed for Snacks.toggle
  branch = "1.0",
  -- keys = {
  --   { "<leader><cr>", toggle_multicursor_mode, desc = "Toggle Multicursor", mode = { "n", "v" } },
  -- },
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup()

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { link = "Cursor" })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })

    vim.g.multicursor_mode_disable = true
    Snacks.toggle({
      name = "Multicursor mode",
      get = function()
        return not vim.g.multicursor_mode_disable
      end,
      set = function(state)
        vim.g.multicursor_mode_disable = not state
        local buf = vim.api.nvim_get_current_buf()
        if state then
          set_keymaps(buf)
        else
          clear_keymaps(buf)
        end
      end,
    }):map("<leader><cr>")
  end,
}
