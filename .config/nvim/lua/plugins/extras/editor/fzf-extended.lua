---@param flag string
local toggle_flag = function(flag)
  return function(_, opts)
    require("fzf-lua.actions").toggle_flag(_, vim.tbl_extend("force", opts, { toggle_flag = flag }))
  end
end

--- Append an iglob pattern
---@param opts {search:string, resume:boolean}
---@param path string
local function _toggle_iglob(opts, path)
  local o = vim.tbl_deep_extend("keep", { resume = true }, opts.__call_opts)
  -- vim.api.nvim_echo({ { vim.inspect(o), "Normal" } }, true, {})

  if o.search:find(path, nil, true) then
    o.search = o.search:gsub("%s*" .. vim.pesc(path), "")
    -- Check if there's only whitespace or nothing after "--"
    local after_dashdash = o.search:match("%-%-(.*)$")
    if after_dashdash and after_dashdash:match("^%s*$") then
      -- Remove "-- " and trailing whitespace
      o.search = o.search:gsub("%s*%-%-%s*$", "")
    end
  elseif o.search:find("--", nil, true) then
    o.search = o.search .. " " .. path
  else
    o.search = o.search .. " -- " .. path
  end

  opts.__call_fn(o)
end

local function toggle_iglob(path)
  return function(_selected, opts)
    _toggle_iglob(opts, path)
  end
end

local function toggle_file_ignore_pattern(pattern)
  return function(_, opts)
    -- vim.api.nvim_echo({ { vim.inspect(opts), "Normal" } }, true, {})

    local o = vim.tbl_deep_extend("keep", { resume = true }, opts.__call_opts)
    o.file_ignore_patterns = o.file_ignore_patterns or {}
    local found
    for idx, path in ipairs(o.file_ignore_patterns) do
      if path == pattern then
        table.remove(o.file_ignore_patterns, idx)
        found = true
        break
      end
    end
    if not found then table.insert(o.file_ignore_patterns, pattern) end

    opts.__call_fn(o)
  end
end

local function toggle_fd_exclude_patterns(patterns)
  -- Convert single pattern to list for consistent handling
  if type(patterns) == "string" then patterns = { patterns } end

  return function(_, opts)
    local o = vim.tbl_deep_extend("keep", { resume = true }, opts.__call_opts)
    o.fd_opts = o.fd_opts or ""

    -- Check if all patterns exist in fd_opts
    local all_patterns_exist = true
    for _, pattern in ipairs(patterns) do
      if not o.fd_opts:find(pattern, nil, true) then
        all_patterns_exist = false
        break
      end
    end

    if all_patterns_exist then
      -- Remove all patterns
      for _, pattern in ipairs(patterns) do
        o.fd_opts = o.fd_opts:gsub("--exclude '" .. vim.pesc(pattern) .. "'", "")
      end
    else
      -- Add all missing patterns
      for _, pattern in ipairs(patterns) do
        if not o.fd_opts:find(pattern, nil, true) then o.fd_opts = o.fd_opts .. " --exclude '" .. pattern .. "'" end
      end
    end

    -- vim.api.nvim_echo({ { vim.inspect({ opts = o.fd_opts, patterns = patterns }), "Normal" } }, true, {})
    opts.__call_fn(o)
  end
end

local use_lazyvim_picker = true
local pick = use_lazyvim_picker and function(name, opts)
  return LazyVim.pick(name, opts)()
end or function(name, opts)
  require("fzf-lua")[name](opts)
end
local default_grep_rg_opts = "--column --line-number --no-heading --color=always --smart-case " .. "--max-columns=4096" -- " -e"
-- TODO: replace with --ignore-file=/Users/$USER/.config/nvim/rules/rg-ignore
local rg_opts = default_grep_rg_opts .. [[ -g '!**/dist/**.js*' -g '!*{-,.}min.js' -e]]
local rg_opts_pcre2 = default_grep_rg_opts .. [[ --pcre2 ]]
-- local default_find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']]
local default_fd_opts = "--color=never --type f --hidden --follow --exclude .git"
local fd_opts = default_fd_opts
  .. " --exclude '**/dist/*.js*' --exclude '**/dist/*.css*' --exclude '*.min.*' --exclude '*-min.*'"

local file_opts = {
  actions = {
    -- https://docs.rs/globset/latest/globset/#syntax
    ["alt-9"] = toggle_fd_exclude_patterns({ "spec/**/*", "**{__tests__,tests?}**", "{test,tests}/" }),
    ["alt-l"] = toggle_flag("-e lua"),
    ["alt-r"] = toggle_flag("-e rb"),
    ["alt-s"] = toggle_flag("--newer 7day"),
  },
}

local live_grep_opts = {
  rg_glob = true,
  -- rg_glob_fn = function(query)
  -- -- Test
  -- -- local ua = "hello -- *.lua"
  -- -- local regex = "^(.-)%s%-%-(.*)$"
  -- -- print(string.match(ua, regex))
  --   local regex, flags = query:match("^(.-)%s%-%-(.*)$")
  --   -- If no separator is detected will return the original query
  --   return (regex or query), flags
  -- end,
  rg_opts = rg_opts,
  git_icons = false,
  actions = {
    -- LazyVim mapping:
    -- ctrl-q: select-all+accept
    -- ctrl-u: half-page-up
    -- ctrl-d: half-page-down
    -- ctrl-x: jump
    -- <c-f>: preview-page-down
    -- <c-b>: preview-page-up
    -- ctrl-t: trouble
    -- ctrl-r: toggle-root-dir
    -- alt-c: toggle-root-dir
    -- ["alt-u"] = toggle_iglob("*.lua !*{test,spec}*"),
    ["alt-j"] = toggle_iglob("*.{js,ts,tsx} !*{test,spec}*"),
    ["alt-o"] = toggle_iglob("*.{js,ts,tsx} **test**"),
    ["alt-1"] = toggle_iglob("**{test,spec}**"),
    ["alt-2"] = toggle_iglob("!**{test,spec}**"),
    ["alt-3"] = toggle_iglob("*.{js,ts,tsx}"),
    -- ["alt-4"] = toggle_iglob("*.rb !spec/**/*.rb"),
    -- ["alt-y"] = toggle_flag("--iglob=!{test,spec}/"),
    -- ["alt-t"] = toggle_flag("--iglob=*{spec,test}*.{lua,js,ts,tsx,rb}"),
    ["alt-4"] = toggle_iglob("!**{umd,cjs,esm}**"),
    -- ["alt-r"] = toggle_iglob("*.rb !*{test,spec}/"),
    -- ["alt-5"] = toggle_iglob("*.rb !*{test,spec}/"),
    -- stylua: ignore start
    ["alt-6"] = toggle_iglob("app/models/**"),
    ["alt-7"] = toggle_iglob("app/controllers/**"),
    ["alt-8"] = toggle_iglob("spec/**/*.rb **/test*/** **/__tests__/**"),
    -- ["alt-9"] = toggle_iglob("!spec/**/* !**/test*/** !test/**"),
    ["alt-9"] = toggle_iglob("!spec/**/* !**/test*/** !__tests__"),
    ["alt-p"] = toggle_flag("--pcre2"),
    -- dotall (?s:.) ; regular (?-s:.)
    ["alt-u"] = toggle_flag("-U"),
    ["alt-l"] = toggle_flag("-t lua"),
    ["alt-r"] = toggle_flag("-t ruby"),
    ["alt-R"] = toggle_iglob("*.rb !*{test,spec}/"),
    ["alt-s"] = toggle_flag("--sortr=created"),
    -- ["alt-z"] = toggle_live_iglob("*.lua"),
    -- ["alt-x"] = function()
    --   local buf = vim.api.nvim_get_current_buf()
    --   local leap = require("util.leap").get_leap_for_buf(buf)
    --   leap()
    -- end,
    -- stylua: ignore end
  },
}

local live_grep_opts_with_reset = vim.tbl_extend("force", live_grep_opts, { search = "" })

return {
  { import = "lazyvim.plugins.extras.editor.fzf" },
  { import = "plugins.extras.editor.telescope.urlview" },
  {
    "ibhagwan/fzf-lua",
    optional = true,
    dependencies = {
      {
        "drop-stones/fzf-lua-normal-mode",
        enabled = false,
        opts = {
          keys = {
            -- repeatable keys
            { key = "j", action = "<Down>" },
            { key = "k", action = "<Up>" },
            { key = "gg", action = "<A-g>" },
            { key = "G", action = "<A-G>" },
            { key = "<C-u>", action = "<C-u>" },
            { key = "<C-d>", action = "<C-d>" },
            -- additional user input keys
            { key = "s", action = "<your-jumps-keybind>", wait_user_input = true },
            -- exit keys
            { key = "q", action = "<Esc>", repeatable = false },
            { key = "<Enter>", action = "<CR>", repeatable = false },
            -- custom function keys
            {
              key = "z",
              action = function()
                vim.cmd("echo 'custom action'")
              end,
            },
          },
        },
      },
      -- { "drop-stones/fzf-lua-grep-context" },
    },
    opts = function(_, opts)
      -- if testing telescope
      if not opts then return end

      -- opts[1] = "border-fused"
      -- opts[1] = "borderless-full"
      local config = require("fzf-lua.config")
      config.defaults.keymap.builtin["<F7>"] = "toggle-fullscreen"
      config.defaults.actions.files["alt-t"] = require("fzf-lua.actions").file_tabedit
      config.defaults.actions.files["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf
      config.defaults.actions.files["ctrl-t"] = require("util.fzf.actions").add_selected

      return vim.tbl_extend("force", opts, {
        git = {
          branches = {
            -- cmd = "git branch --all --color=always --sort=-committerdate",
            cmd = "git branch --color=always --sort=-committerdate",
            preview = "git log --graph --pretty=oneline --abbrev-commit --color --stat {1}",
          },
        },
        previewers = {
          builtin = {
            syntax_limit_b = 1024 * 100, -- 100KB
          },
        },
        lsp = {
          -- Causes the fzf window to flash on the screen when there's only 1 result
          -- async_or_timeout = true,
          async_or_timeout = 35000,
        },
        -- grep = {
        --   rg_glob = false, -- 1. Disable automatic --iglob injection by fzf-lua
        --   fn_transform_cmd = function(query, cmd, _)
        --     -- 2. Load grep-context module in runtime
        --     -- This ensures the plugin is available when used from inside fzf-lua sessions
        --     vim.opt.rtp:append(vim.env.FZF_LUA_GREP_CONTEXT)
        --     return require("fzf-lua-grep-context.transform").rg(query, cmd)
        --   end,
        --   actions = {
        --     -- 3. Open grep context picker with <C-t>
        --     ["ctrl-t"] = function()
        --       require("fzf-lua-grep-context").picker()
        --     end,
        --   },
        -- },
      })
    end,
    keys = {
      -- stylua: ignore start
      { "<leader><space>", function() pick("files", vim.tbl_extend("force", file_opts, { git_icons = false, fd_opts = fd_opts })) end, desc = "Find Files (Root Dir)" },
      -- { "<leader><S-space>", LazyVim.pick("files", vim.tbl_extend("force", file_opts, { git_icons = false, fd_opts = fd_opts, root = false })), desc = "Find Files (cwd)" },
      { "<leader>ff", function() pick("files", vim.tbl_extend("force", file_opts, { git_icons = false, fd_opts = fd_opts })) end, desc = "Find Files (Root Dir)" },
      { "<leader>fF", function() pick("files", vim.tbl_extend("force", file_opts, { git_icons = false, fd_opts = fd_opts, root = false })) end, desc = "Find Files (cwd)" },
      { "<leader>su", function() pick("grep_cword", live_grep_opts) end, desc = "Word (Root Dir)", mode = "n" },
      { "<leader>su", function() pick("grep_visual", live_grep_opts) end, desc = "Selection (Root Dir)", mode = "v" },
      { "<leader>s<C-w>", "<cmd>FzfLua grep_cWORD<CR>", desc = "WORD (Root Dir)", mode = "n" },
      { "<leader>sx", function() pick("live_grep_native", live_grep_opts) end, desc = "Grep (Native)", mode = "n" },
      { "<leader>sw", function() pick("grep_cword", vim.tbl_extend("force", live_grep_opts, { rg_glob = false, git_icons = true })) end, desc = "Word (Root Dir)", mode = "n" },
      { "<leader>sW", function() pick("grep_cword", vim.tbl_extend("force", live_grep_opts, { rg_glob = false, git_icons = true, root = false })) end, desc = "Word (cwd)", mode = "n" },
      { "<leader>sw", function() pick("grep_visual", vim.tbl_extend("force", live_grep_opts, { rg_glob = false })) end, desc = "Selection (Root Dir)", mode = "v" },
      { "<leader>sW", function() pick("grep_visual", vim.tbl_extend("force", live_grep_opts, { rg_glob = false, root = false })) end, desc = "Selection (cwd)", mode = "v" },
      -- { "<leader>sB", "<cmd>lua LazyVim.pick('lgrep_curbuf')()<CR>", desc = "Buffer (Live Grep)", mode = "n" },
      { "<leader>sg", function() pick("live_grep_glob", live_grep_opts_with_reset) end, desc = "Grep (Root Dir)" },
      { "<leader>sG", function() pick("live_grep_glob", vim.tbl_extend("force", live_grep_opts_with_reset, { root = false })) end, desc = "Grep (cwd)" },
      { "<leader>sP", function() pick("live_grep_glob", { rg_opts = rg_opts_pcre2, silent = true }) end, desc = "Grep (--pcre2)" },
      { "<leader>sN", function() pick("live_grep_glob", { cwd = "node_modules", rg_opts = "-uu" }) end, desc = "Grep (node_modules)" },
      { "<leader>fM", function() pick("files", { cwd = "node_modules", fd_opts = fd_opts .. " -u" }) end, desc = "Find Files (node_modules)" },
      -- { "<leader><space>", pick("files", { winopts = { height = 0.33, width = 0.33, preview = { hidden = "hidden" } } }), desc = "Find Files (Root Dir)" },
      -- { "<leader>fz", function() require("util.fzf.zoxide").fzf_zoxide() end, desc = "Zoxide"},
      { "<leader>fz", function() require("util.fzf.zoxide").fzf_zoxide_async() end, desc = "Zoxide"},
      { "<leader>sL", "<cmd>FzfLua lsp_finder<cr>", desc = "LSP Finder" },
      { "<leader>ga", "<cmd>FzfLua git_branches<cr>", desc = "Git Branches" },
      { "<leader>gr", "<cmd>FzfLua git_branches<cr>", desc = "Branches" },
      { "<leader>sA", "<cmd>FzfLua treesitter<cr>", desc = "Treesiter Symbols" },
      -- { "<leader>sX", "<cmd>FzfLua treesitter<cr>", desc = "Treesiter Symbols" },
      -- { "<leader><C-s>", "<cmd>FzfLua spell_suggest<cr>", desc = "Spelling" },
      -- Disabled in favor of Snacks.picker (syntax highlighting, etc.)
      { "<leader>sm", false },
      -- stylua: ignore end
      {
        "<leader>sF",
        function()
          pick("live_grep", {
            no_esc = false,
            rg_opts = "--fixed-strings --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
          })
        end,
        desc = "Grep (--fixed-strings)",
        mode = "n",
      },
      -- stylua: ignore start
      { "<leader>mt", function() require("util.fzf.grapple").open() end, desc = "Marks (Fzf)" },
      { "<leader>s<C-d>", function() require("util.fzf.devdocs").open_async({ languages = vim.bo.filetype }) end, desc = "Devdocs" },
      -- stylua: ignore end
      {
        "<leader>fp",
        function()
          pick(
            "files",
            vim.tbl_extend("force", file_opts, {
              cwd = vim.fn.fnamemodify(get_lazyvim_base_dir(), ":h"),
              git_icons = false,
              fd_opts = fd_opts .. " -g '*.lua'",
            })
          )
        end,
        desc = "Plugins",
      },
      {
        "<leader>sp",
        function()
          pick(
            "live_grep",
            vim.tbl_extend("force", live_grep_opts, {
              cwd = vim.fn.fnamemodify(get_lazyvim_base_dir(), ":h"),
              git_icons = false,
              rg_opts = default_grep_rg_opts .. " -t lua -e",
            })
          )
        end,
        desc = "Plugins",
      },
      {
        "<leader>sY",
        function()
          local cwd = vim.fn.expand("%:p:h")
          -- TODO: make this work if a file is opened in a subdirectory of a node_modules directory
          local function get_module_path(path)
            local start, _ = string.find(path, "node_modules/")
            if start then
              local nextSlash = string.find(path, "/", start + 13) -- find the next slash after "node_modules/"
              if nextSlash then
                return string.sub(path, 1, nextSlash - 1)
              else
                return string.sub(path, 1, start + 12) -- if there is no next slash, return everything up to "node_modules/"
              end
            else
              vim.api.nvim_echo({ { "Not a path within a node_modules folder", "Normal" } }, false, {})
              return false
            end
          end
          local path = get_module_path(cwd)
          if path then pick("live_grep", { cwd = path })() end
        end,
        desc = "Within node_modules subdirectory",
      },
      {
        "<leader>gR",
        function()
          require("util.fzf.recently_committed").open_fzf(10)
        end,
        desc = "Recently commited",
      },
      -- interferes with ins-completion, which is unused
      -- {
      --   "<C-x><C-f>",
      --   function()
      --     require("fzf-lua").complete_path({ winopts = { height = 0.33, width = 0.5 } })
      --   end,
      --   mode = { "n", "v", "i" },
      --   silent = true,
      --   desc = "Fuzzy complete path",
      -- },
      {
        "<leader>sZ",
        function()
          FzfLua.fzf_exec({ "foo", "bar" }, {
            -- @param selected: the selected entry or entries
            -- @param opts: fzf-lua caller/provider options
            -- @param line: originating buffer completed line
            -- @param col: originating cursor column location
            -- @return newline: will replace the current buffer line
            -- @return newcol?: optional, sets the new cursor column
            complete = function(selected, opts, line, col)
              local newline = line:sub(1, col) .. selected[1]
              -- set cursor to EOL, since `nvim_win_set_cursor`
              -- is 0-based we have to lower the col value by 1
              return newline, #newline - 1
            end,
          })
        end,
        desc = "No-bind interal action test",
      },
      -- {
      --   "<leader>sX",
      --   function()
      --     require("fzf-lua").fzf_exec({ "foo", "bar" }, {
      --       -- @param selected: the selected entry or entries
      --       -- @param opts: fzf-lua caller/provider options
      --       -- @param line: originating buffer completed line
      --       -- @param col: originating cursor column location
      --       -- @return newline: will replace the current buffer line
      --       -- @return newcol?: optional, sets the new cursor column
      --       complete = function(selected, opts, line, col)
      --         local newline = line:sub(1, col) .. selected[1]
      --         -- set cursor to EOL, since `nvim_win_set_cursor`
      --         -- is 0-based we have to lower the col value by 1
      --         return newline, #newline - 1
      --       end,
      --     })
      --   end,
      --   desc = "Custom Completion",
      -- },
    },
  },
  {
    "ibhagwan/fzf-lua",
    optional = true,
    -- cond = LazyVim.has("nvim-dap"),
    keys = {
      -- | `dap_commands`         | list,run `nvim-dap` builtin commands         |
      -- | `dap_configurations`   | list,run debug configurations              |
      -- | `dap_breakpoints`      | list,delete breakpoints                    |
      -- | `dap_variables`        | active session variables                   |
      -- | `dap_frames`           | active session jump to frame               |

      -- stylua: ignore start
      { "<leader>dm", function() require("fzf-lua").dap_commands({ winopts = { height = 0.33, width = 0.33 } }) end, desc = "Commands", mode = "n" },
      { "<leader>dG", function() require("fzf-lua").dap_configurations() end, desc = "Configurations", mode = "n" },
      { "<leader>dL", function() require("fzf-lua").dap_breakpoints() end, desc = "Breakpoints", mode = "n" },
      { "<leader>dv", function() require("fzf-lua").dap_variables() end, desc = "Variables", mode = "n" },
      { "<leader>df", function() require("fzf-lua").dap_frames() end, desc = "Frames", mode = "n" },
      -- stylua: ignore end
    },
  },
}
