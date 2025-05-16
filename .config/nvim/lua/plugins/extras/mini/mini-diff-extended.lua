local git_read_stream = function(stream, feed)
  local callback = function(err, data)
    if data ~= nil then return table.insert(feed, data) end
    if err then feed[1] = nil end
    stream:close()
  end
  stream:read_start(callback)
end

--- Set the reference text for the buffer.
---@param buf_id integer
---@param branch string
---@param yadm? boolean[]
local set_mini_diff_ref_text = function(buf_id, branch, yadm)
  local buf_set_ref_text = vim.schedule_wrap(function(text)
    pcall(MiniDiff.set_ref_text, buf_id, text)
  end)

  -- NOTE: Do not cache buffer's name to react to its possible rename
  -- local path = vim.api.nvim_buf_get_name(buf_id)
  local path = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(buf_id))
  if path == "" then return buf_set_ref_text({}) end

  local cwd, basename = vim.fn.fnamemodify(path, ":h"), vim.fn.fnamemodify(path, ":t")
  local stdout = vim.uv.new_pipe()
  local spawn_opts = { args = { "show", branch .. ":./" .. basename }, cwd = cwd, stdio = { nil, stdout, nil } }

  ---@type uv.uv_process_t | nil
  local process, stdout_feed = nil, {}
  local on_exit = function(exit_code)
    process:close()

    -- Unset reference text in case of any error. This results into not showing
    -- hunks at all. Possible reasons to do so:
    -- - 'Not in index' files (new, ignored, etc.).
    -- - 'Neither in index nor on disk' files (after checking out commit which
    --   does not yet have file created).
    -- - 'Relative can not be used outside working tree' (when opening file
    --   inside '.git' directory).
    if exit_code ~= 0 or stdout_feed[1] == nil then return buf_set_ref_text({}) end

    -- Set reference text accounting for possible 'crlf' end of line in index
    local text = table.concat(stdout_feed, ""):gsub("\r\n", "\n")
    buf_set_ref_text(text)
  end

  local exe = yadm and "yadm" or "git"
  process = vim.uv.spawn(exe, spawn_opts, on_exit)
  git_read_stream(stdout, stdout_feed)
end

return {
  { import = "lazyvim.plugins.extras.editor.mini-diff" },
  {
    "echasnovski/mini.diff",
    optional = true,
    -- Examples:
    -- - `vip` followed by `gh` / `gH` applies/resets hunks inside current paragraph.
    -- - vifgh stages hunk inside function, vifgH resets hunk inside function.
    --   Same can be achieved in operator form `ghip` / `gHip`, which has the
    --   advantage of being dot-repeatable (see |single-repeat|).
    -- - `gh_` / `gH_` applies/resets current line (even if it is not a full hunk).
    -- - `ghgh` / `gHgh` applies/resets hunk range under cursor. ghgh stages hunk, gHgh resets a hunk to before change
    -- - `dgh` deletes hunk range under cursor. dgh deletes entire hunk,
    -- - `[H` / `[h` / `]h` / `]H` navigate cursor to the first / previous / next / last
    --   hunk range of the current buffer.
    -- mappings = {
    --   -- Apply hunks inside a visual/operator region
    --   apply = "gh",
    --
    --   -- Reset hunks inside a visual/operator region
    --   reset = "gH",
    --
    --   -- Hunk range textobject to be used inside operator
    --   -- Works also in Visual mode if mapping differs from apply and reset
    --   textobject = "gh",
    --
    --   -- Go to hunk range in corresponding direction
    --   goto_first = "[H",
    --   goto_prev = "[h",
    --   goto_next = "]h",
    --   goto_last = "]H",
    -- },
    keys = {
      {
        "<leader>gdh",
        function()
          local buf_id = vim.api.nvim_get_current_buf()
          set_mini_diff_ref_text(buf_id, ":0")
        end,
        desc = "MiniDiff (HEAD)",
      },
      {
        "<leader>gdH",
        function()
          local buf_id = vim.api.nvim_get_current_buf()
          set_mini_diff_ref_text(buf_id, "@{1}")
        end,
        desc = "MiniDiff (HEAD~1)",
      },
      {
        "<leader>gdm",
        function()
          local buf_id = vim.api.nvim_get_current_buf()
          set_mini_diff_ref_text(buf_id, "master")
        end,
        desc = "MiniDiff (master)",
      },
      {
        "<leader>gdM",
        function()
          local buf_id = vim.api.nvim_get_current_buf()
          set_mini_diff_ref_text(buf_id, "main")
        end,
        desc = "MiniDiff (main)",
      },
      {
        "<leader>gdd",
        function()
          local buf_id = vim.api.nvim_get_current_buf()
          set_mini_diff_ref_text(buf_id, "development")
        end,
        desc = "MiniDiff (development)",
      },
      {
        "<leader>gdx",
        function()
          local buf_id = vim.api.nvim_get_current_buf()
          local input = vim.fn.input("compare:")
          set_mini_diff_ref_text(buf_id, input)
        end,
        desc = "MiniDiff (pick)",
      },
      {
        "<leader>gdo",
        function()
          local buf_id = vim.api.nvim_get_current_buf()
          local handle = io.popen("git rev-parse --abbrev-ref HEAD")
          if not handle then return end
          local result = handle:read("*a")
          handle:close()
          local branch = "origin/" .. result
          handle = io.popen("git branch -a | grep " .. branch)
          if not handle then return end
          result = handle:read("*a")
          handle:close()
          if result then
            vim.api.nvim_echo({ { "Comparing with " .. branch, "Normal" } }, true, {})
            set_mini_diff_ref_text(buf_id, branch)
          else
            vim.api.nvim_echo({ { "No such branch: " .. branch, "WarningMsg" } }, true, {})
          end
        end,
        desc = "MiniDiff (origin)",
      },

      {
        "ghy",
        function()
          return MiniDiff.operator("yank") .. "gh"
        end,
        { mode = "n", expr = true, remap = true },
      },
      {
        "<leader>xH",
        function()
          vim.fn.setqflist(MiniDiff.export("qf"))
          require("trouble").open({ mode = "quickfix", focus = false })
        end,
        desc = "Export hunks to quickfix",
      },
      {
        "<leader>gdY",
        function()
          local current_buf = vim.api.nvim_get_current_buf()
          local old_disable = MiniDiff.disable
          MiniDiff.disable = function(buf_id)
            if buf_id == current_buf then return end
            old_disable(buf_id)
          end
          vim.api.nvim_buf_attach(current_buf, false, {
            on_detach = function()
              MiniDiff.disable = old_disable
              MiniDiff.disable(current_buf)
            end,
          })
          set_mini_diff_ref_text(current_buf, "main", true)
        end,
        desc = "MiniDiff (YADM)",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { "<leader>gd", group = "MiniDiff" },
      },
    },
  },
}
