local prefix = "<leader>gC"
-- stylua: ignore start
local keys = {
  { "co", "<Plug>(git-conflict-ours)",          { desc = "Choose Their Changes" } },
  { "ct", "<Plug>(git-conflict-theirs)",        { desc = "Choose Our Changes" } },
  { "cb", "<Plug>(git-conflict-both)",          { desc = "Choose Both changes" } },
  { "c0", "<Plug>(git-conflict-none)",          { desc = "Choose None" } },
  { "cx", "<Plug>(git-conflict-refresh)",       { desc = "Git Conflict Refresh" } },
  { "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "Prev Git Conflict" } },
  { "]x", "<Plug>(git-conflict-next-conflict)", { desc = "Next Git Conflict" } },
}
-- stylua: ignore end
---@param buf number
local set_git_conflict_keymap = function(buf)
  for _, key in ipairs(keys) do
    vim.api.nvim_buf_set_keymap(buf, "n", key[1], key[2], key[3])
  end
end

local clear_keymaps = function(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end

  if not vim.bo[buf].buflisted then return end

  for _, key in ipairs(keys) do
    local ok = pcall(vim.api.nvim_buf_get_keymap, buf, "n")
    if ok then vim.api.nvim_buf_del_keymap(buf, "n", key[1]) end
  end
end

return {

  {
    "akinsho/git-conflict.nvim",
    opts = {
      default_mappings = false,
      -- default_commands = true, -- disable commands created by this plugin
      -- disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      -- list_opener = "copen", -- command or function to open the conflicts list
      list_opener = function()
        require("trouble").open({ mode = "quickfix", focus = false })
      end,
      -- highlights = { -- They must have background color, otherwise the default color will be used
      --   incoming = "DiffAdd",
      --   current = "DiffText",
      -- },
    },
    version = "*",
    keys = {
      { prefix .. "t", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose Their Changes" },
      { prefix .. "o", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose Our Changes" },
      { prefix .. "b", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose Both changes" },
      { prefix .. "l", "<cmd>GitConflictListQf<cr>", desc = "Git Conflict Quicklist" },
      { prefix .. "r", "<cmd>GitConflictRefresh<cr>", desc = "Git Conflict Refresh" },
      { "[g", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev Git Conflict" },
      { "]g", "<cmd>GitConflictNextConflict<cr>", desc = "Next Git Conflict" },
      {
        prefix .. "R",
        function()
          require("git-conflict").setup()
          vim.api.nvim_command("GitConflictRefresh")
        end,
        "Git Conflict Load",
      },
    },
    -- config = true,
    config = function(_, opts)
      require("git-conflict").setup(opts)

      local group = vim.api.nvim_create_augroup("GitConflictKeymap", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "GitConflictDetected",
        callback = function()
          vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
          local buf = vim.api.nvim_get_current_buf()

          set_git_conflict_keymap(buf)

          vim.api.nvim_create_autocmd("BufLeave", {
            buffer = buf,
            once = true,
            callback = function()
              clear_keymaps(buf)
            end,
          })
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        -- { prefix, group = "conflicts", icon = { icon = "", color = "red" } },
        { prefix, group = "conflicts", icon = { icon = " ", color = "red" } },
      },
    },
  },
}
