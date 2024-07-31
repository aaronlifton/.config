local actions = require("fzf-lua.actions")
---@param flag string
local toggle_flag = function(flag)
  return function(_, opts)
    actions.toggle_flag(
      _,
      vim.tbl_extend("force", opts, {
        toggle_flag = flag,
      })
    )
  end
end

local function symbols_filter(entry, ctx)
  if ctx.symbols_filter == nil then
    ctx.symbols_filter = LazyVim.config.get_kind_filter(ctx.bufnr) or false
  end
  if ctx.symbols_filter == false then
    return true
  end
  return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

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
    ["alt-u"] = toggle_flag("--iglob=*.lua --iglob=!*{test,spec}*"),
    ["alt-j"] = toggle_flag("--iglob=*.{js,ts,tsx} --iglob=!*{test,spec}*"),
    ["alt-r"] = toggle_flag("--iglob=*.rb --iglob=!*{test,spec}/"),
    ["alt-y"] = toggle_flag("--iglob=!{test,spec}/"),
    ["alt-t"] = toggle_flag("--iglob=*{spec,test}*.{lua,js,ts,tsx,rb}"),
    ["alt-s"] = toggle_flag("--iglob=spec/**/*.rb"),
    ["alt-v"] = actions.toggle_hidden,
    ["alt-x"] = function()
      local buf = vim.api.nvim_get_current_buf()
      local leap = require("util.leap").get_leap_for_buf(buf)
      leap()
    end,
  },
}
local live_grep_opts_with_reset = vim.tbl_extend("force", live_grep_opts, {
  search = "",
})
return {
  { import = "lazyvim.plugins.extras.editor.fzf" },
  -- { "nvim-telescope/telescope.nvim", enabled = true },
  { import = "plugins.extras.telescope.urlview" },
  {
    "ibhagwan/fzf-lua",
    -- Submitted issue: https://github.com/ibhagwan/fzf-lua/issues/1368
    -- commit = "0c7cd0169cb8433f4f3b102bf6d4c0c7e0a20446",
    opts = function(_, opts)
      opts.files.actions["alt-v"] = opts.files.actions["alt-h"]
      opts.files.actions["alt-h"] = nil
      opts.grep.actions["alt-v"] = opts.grep.actions["alt-h"]
      opts.grep.actions["alt-h"] = nil
    end,
    keys = {
      -- { "<leader>su", "<cmd>lua require('fzf-lua').grep_cword()<CR>", desc = "Grep (current word)", mode = "n" },
      -- { "<leader>su", "<cmd>lua require('fzf-lua').grep_visual()<CR>", desc = "Grep (selection)", mode = "v" },
      -- { "<c-n>", "<c-n>", ft = "fzf", mode = "t", nowait = true },
      -- { "<c-p>", "<c-p>", ft = "fzf", mode = "t", nowait = true },
      {
        "<leader>su",
        function()
          -- require("fzf-lua").grep_cword(vim.tbl_extend("force", live_grep_opts, { search = "" }))
          -- LazyVim.pick("grep_cword", vim.tbl_extend("force", live_grep_opts, { search = "" }))()
          LazyVim.pick("grep_cword", live_grep_opts)()
        end,
        desc = "Word (Root Dir)",
        mode = "n",
      },
      {
        "<leader>su",
        function()
          -- require("fzf-lua").grep_visual(live_grep_opts)
          LazyVim.pick("grep_visual", live_grep_opts)()
        end,
        desc = "Selection (Root Dir)",
        mode = "v",
      },
      { "<leader>sx", "<cmd>lua require('fzf-lua').grep_cWORD()<CR>", desc = "WORD (Root Dir)", mode = "n" },
      {
        "<leader>sw",
        function()
          -- require("fzf-lua").grep_cword(vim.tbl_extend("force", live_grep_opts, { rg_glob = false, git_icons = true }))
          LazyVim.pick("grep_cword", vim.tbl_extend("force", live_grep_opts, { rg_glob = false, git_icons = true }))()
        end,
        desc = "Word (Root Dir)",
        mode = "n",
      },
      {
        "<leader>sW",
        function()
          -- require("fzf-lua").grep_cword(
          --   vim.tbl_extend("force", live_grep_opts, { rg_glob = false, git_icons = true, root = false })
          -- )
          LazyVim.pick(
            "grep_cword",
            vim.tbl_extend("force", live_grep_opts, { rg_glob = false, git_icons = true, root = false })
          )()
        end,
        desc = "Word (cwd)",
        mode = "n",
      },
      {
        "<leader>sw",
        function()
          -- require("fzf-lua").grep_visual(vim.tbl_extend("force", live_grep_opts, { rg_glob = false }))
          LazyVim.pick("grep_visual", vim.tbl_extend("force", live_grep_opts, { rg_glob = false }))()
        end,
        desc = "Selection (Root Dir)",
        mode = "v",
      },
      {
        "<leader>sW",
        function()
          -- require("fzf-lua").grep_visual(vim.tbl_extend("force", live_grep_opts, { rg_glob = false, root = false }))
          LazyVim.pick("grep_visual", vim.tbl_extend("force", live_grep_opts, { rg_glob = false, root = false }))()
        end,
        desc = "Selection (cwd)",
        mode = "v",
      },
      -- { "<leader>sB", "<cmd>lua require('fzf-lua').lgrep_curbuf()<CR>", desc = "Buffer (Live Grep)", mode = "n" },
      { "<leader>sB", "<cmd>lua LazyVim.pick('lgrep_curbuf')()<CR>", desc = "Buffer (Live Grep)", mode = "n" },
      -- require("fzf-lua").live_grep({ no_esc = false, rg_opts = "--fixed-strings --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e" })

      {
        "<leader>sF",
        function()
          -- require("fzf-lua").live_grep({
          LazyVim.pick("live_grep", {
            no_esc = false,
            rg_opts = "--fixed-strings --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
          })()
        end,
        desc = "Grep (--fixed-strings)",
        mode = "n",
      },
      {
        "<leader>sg",
        function()
          -- require("fzf-lua").live_grep_glob(live_grep_opts_with_reset)
          LazyVim.pick("live_grep_glob", live_grep_opts)()
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sG",
        function()
          -- require("fzf-lua").live_grep_glob(vim.tbl_extend("force", live_grep_opts_with_reset, { root = false }))
          LazyVim.pick("live_grep_glob", vim.tbl_extend("force", live_grep_opts_with_reset, { root = false }))()
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>sN",
        function()
          LazyVim.pick("live_grep", { cwd = "./node_modules" })()
        end,
        desc = "Grep (node_modules)",
      },
      {
        "<leader>fM",
        function()
          LazyVim.pick("files", { cwd = "./node_modules" })()
        end,
        desc = "Find Files (node_modules)",
      },
      {
        "<C-x><C-f>",
        function()
          require("fzf-lua").complete_path()
        end,
        mode = { "n", "v", "i" },
        silent = true,
        desc = "Fuzzy complete path",
      },
      {
        "<leader>sL",
        function()
          require("fzf-lua").lsp_finder({
            -- regex_filter = symbols_filter,
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sX",
        function()
          require("fzf-lua").fzf_exec({ "foo", "bar" }, {
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
        desc = "Custom Completion",
      },
      {
        "<leader>sZ",
        function()
          require("fzf-lua").fzf_exec({ 1, 2, 3, 4 }, {
            keymap = { fzf = { ["backward-eof"] = "print(_myaction)+accept" } },
            actions = {
              ["enter"] = function(sel, _opts)
                print("enter, num sel:", #sel)
              end,
              ["_myaction"] = function(sel, _opts)
                print("_myaction, num sel", #sel)
              end,
            },
          })
        end,
        desc = "No-bind interal action test",
      },
      {
        "<leader>fz",
        function()
          local util = require("util.fzf.zoxide")
          util.fzf_zoxide()
        end,
        desc = "Zoxide",
      },
      {
        "<leader>fZ",
        function()
          local util = require("util.fzf.zoxide")
          util.fzf_zoxide2()
        end,
        desc = "Zoxide (Test)",
      },
      {
        "gR",
        function()
          local ts_util = require("util.treesitter")
          local search_term = vim.fn.expand("<cword>")
          local node_type = ts_util.parent_node_type_at_cursor()
          if node_type == "function_declaration" then
            search_term = " " .. search_term .. "("
          elseif node_type == "function_call" then
            local next_char = ts_util.get_cword_next_char()
            vim.api.nvim_echo({ { next_char, "Comment" } }, false, {})
            search_term = " " .. search_term
            if next_char == "(" then
              search_term = search_term .. "("
            end
          end

          local current_file = vim.fn.expand("%:t")
          local file_extension = current_file:match("^.+(%..+)$")
          -- require("fzf-lua").live_grep({
          LazyVim.pick("live_grep", {
            search = search_term,
            glob = "*." .. file_extension .. "!*{test,spec}/",
          })()
        end,
        desc = "References (grep)",
      },
    },
  },
  {

    "ibhagwan/fzf-lua",
    cond = LazyVim.has("nvim-dap"),
    optional = true,
    keys = {
      -- | `dap_commands`         | list,run `nvim-dap` builtin commands         |
      -- | `dap_configurations`   | list,run debug configurations              |
      -- | `dap_breakpoints`      | list,delete breakpoints                    |
      -- | `dap_variables`        | active session variables                   |
      -- | `dap_frames`           | active session jump to frame               |

      -- stylua: ignore start
      { "<leader>dm", function() require("fzf-lua").dap_commands({ winopts = { height = 0.33, width = 0.33 } }) end, desc = "Commands", mode = "n" },
      { "<leader>dG", function() require("fzf-lua").dap_configurations() end, desc = "Configurations", mode = "n" },
      { "<leader>dbL", function() require("fzf-lua").dap_breakpoints() end, desc = "Breakpoints", mode = "n" },
      { "<leader>dv", function() require("fzf-lua").dap_variables() end, desc = "Variables", mode = "n" },
      { "<leader>df", function() require("fzf-lua").dap_frames() end, desc = "Frames", mode = "n" },
      -- stylua: ignore end
    },
  },
}
