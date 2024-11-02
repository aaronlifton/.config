---@param flag string
local toggle_flag = function(flag)
  return function(_, opts)
    require("fzf-lua.actions").toggle_flag(_, vim.tbl_extend("force", opts, { toggle_flag = flag }))
  end
end

-- From LazyVim
-- local function symbols_filter(entry, ctx)
--   if ctx.symbols_filter == nil then
--     ctx.symbols_filter = LazyVim.config.get_kind_filter(ctx.bufnr) or false
--   end
--   if ctx.symbols_filter == false then
--     return true
--   end
--   return vim.tbl_contains(ctx.symbols_filter, entry.kind)
-- end

local use_lazyvim_picker = true
local pick = use_lazyvim_picker and function(name, opts)
  return LazyVim.pick(name, opts)()
end or function(name, opts)
  return require("fzf-lua")[name](opts)
end

local default_grep_rg_opts = "--column --line-number --no-heading --color=always --smart-case " .. "--max-columns=4096"
local rg_opts = default_grep_rg_opts .. [[ -g '!**/dist/**.js*' -g '!*{-,.}min.js' -e]]
local rg_opts_pcre2 = default_grep_rg_opts .. [[ --pcre2 ]]
-- local default_find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']]
local default_fd_opts = "--color=never --type f --hidden --follow --exclude .git"
local fd_opts = default_fd_opts .. " --exclude '*dist*.js' --exclude '*.min.*' --exclude '*-min.*'"
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
    ["alt-u"] = toggle_flag("--iglob=*.lua --iglob=!*{test,spec}*"),
    ["alt-j"] = toggle_flag("--iglob=*.{js,ts,tsx} --iglob=!*{test,spec}*"),
    ["alt-o"] = toggle_flag("--iglob=*.{js,ts,tsx} --iglob=**test**"),
    ["alt-1"] = toggle_flag("--iglob=**{test,spec}**"),
    ["alt-2"] = toggle_flag("--iglob=!**{test,spec}**"),
    ["alt-3"] = toggle_flag("--iglob=*.{js,ts,tsx}"),
    ["alt-4"] = toggle_flag("--iglob=*.rb"),
    ["alt-r"] = toggle_flag("--iglob=*.rb --iglob=!*{test,spec}/"),
    ["alt-y"] = toggle_flag("--iglob=!{test,spec}/"),
    ["alt-t"] = toggle_flag("--iglob=*{spec,test}*.{lua,js,ts,tsx,rb}"),
    ["alt-s"] = toggle_flag("--iglob=spec/**/*.rb"),
    ["alt-5"] = toggle_flag("--iglob=!**{umd,cjs,esm}**"),
    ["alt-x"] = function()
      local buf = vim.api.nvim_get_current_buf()
      local leap = require("util.leap").get_leap_for_buf(buf)
      leap()
    end,
  },
}

local live_grep_opts_with_reset = vim.tbl_extend("force", live_grep_opts, { search = "" })
return {
  { import = "lazyvim.plugins.extras.editor.fzf" },
  { import = "plugins.extras.editor.telescope.urlview" },
  {
    "ibhagwan/fzf-lua",
    optional = true,
    opts = function(_, opts)
      local config = require("fzf-lua.config")
      -- opts.files.actions["alt-v"] = opts.files.actions["alt-h"]
      -- opts.files.actions["alt-h"] = nil
      -- opts.grep.actions["alt-v"] = opts.grep.actions["alt-h"]
      -- opts.grep.actions["alt-h"] = nil
      config.defaults.keymap.builtin["<F7>"] = "toggle-fullscreen"
      -- local prev_ui_select = opts.ui_select
      -- opts.ui_select = function(fzf_opts, items)
      --   vim.notify(("kind %s"):format(fzf_opts.kind))
      --   prev_ui_select(fzf_opts, items)
      -- end
    end,
    keys = {
      --stylua: ignore start
      { "<leader><space>", LazyVim.pick("files", { git_icons = false}), desc = "Find Files (Root Dir)" },
      { "<leader>ff", LazyVim.pick("files", { git_icons = false, fd_opts = fd_opts }), desc = "Find Files (Root Dir)" },
      { "<leader>fF", LazyVim.pick("files", { root = false, git_icons = false }), desc = "Find Files (cwd)" },
      { "<leader>su", function() pick("grep_cword", live_grep_opts) end, desc = "Word (Root Dir)", mode = "n" },
      { "<leader>su", function() pick("grep_visual", live_grep_opts) end, desc = "Selection (Root Dir)", mode = "v" },
      -- { "<leader>sx", "<cmd>lua require('fzf-lua').grep_cWORD()<CR>", desc = "WORD (Root Dir)", mode = "n" },
      { "<leader>sx", function() pick("live_grep_native", live_grep_opts) end, desc = "Grep (Native)", mode = "n" },
      { "<leader>sw", function() pick("grep_cword", vim.tbl_extend("force", live_grep_opts, { rg_glob = false, git_icons = true })) end, desc = "Word (Root Dir)", mode = "n" },
      { "<leader>sW", function() pick("grep_cword", vim.tbl_extend("force", live_grep_opts, { rg_glob = false, git_icons = true, root = false })) end, desc = "Word (cwd)", mode = "n" },
      { "<leader>sw", function() pick("grep_visual", vim.tbl_extend("force", live_grep_opts, { rg_glob = false })) end, desc = "Selection (Root Dir)", mode = "v" },
      { "<leader>sW", function() pick("grep_visual", vim.tbl_extend("force", live_grep_opts, { rg_glob = false, root = false })) end, desc = "Selection (cwd)", mode = "v" },
      { "<leader>sB", "<cmd>lua LazyVim.pick('lgrep_curbuf')()<CR>", desc = "Buffer (Live Grep)", mode = "n" },
      { "<leader>sg", function() pick("live_grep_glob", live_grep_opts_with_reset) end, desc = "Grep (Root Dir)" },
      { "<leader>sP", function() pick("live_grep_glob", { rg_opts = rg_opts_pcre2, silent = true }) end, desc = "Grep (pcre2)" },
      { "<leader>sG", function() pick("live_grep_glob", vim.tbl_extend("force", live_grep_opts_with_reset, { root = false })) end, desc = "Grep (cwd)" },
      { "<leader>sN", function() pick("live_grep", { cwd = "./node_modules" }) end, desc = "Grep (node_modules)" },
      { "<leader>fM", function() pick("files", { cwd = "./node_modules" }) end, desc = "Find Files (node_modules)" },
      -- { "<leader><space>", pick("files", { winopts = { height = 0.33, width = 0.33, preview = { hidden = "hidden" } } }), desc = "Find Files (Root Dir)" },
      { "<leader>fz", function() require("util.fzf.zoxide").fzf_zoxide() end, desc = "Zoxide"},
      { "<leader>fZ", function() require("util.fzf.zoxide").fzf_zoxide2() end, desc = "Zoxide (Test)"},
      { "<leader>sL", function() require("fzf-lua").lsp_finder({}) end, desc = "LSP Finder" },
      { "<leader>ga", function() require("fzf-lua").git_branches({}) end, desc = "Git Branches" },
      --stylua: ignore end
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
      },
      {
        "<C-x><C-f>",
        function()
          require("fzf-lua").complete_path({ winopts = { height = 0.33, width = 0.5 } })
        end,
        mode = { "n", "v", "i" },
        silent = true,
        desc = "Fuzzy complete path",
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
        "<leader>sA",
        function()
          local open = require("util.devdocs")()
          open()
        end,
      },
      {
        "<leader>sz",
        function()
          local function get_tmp_buffer()
            local tmp_buf = vim.api.nvim_create_buf(false, true)
            vim.bo[tmp_buf].bufhidden = "wipe"
            return tmp_buf
          end
          vim.ui.input({
            prompt = "Language",
          }, function(input)
            -- split new by /
            local new = string.gsub(input, "/", " ")
            local lang, query = string.match(new, "(%S+)%s(%S+)")
            local output = vim.fn.system("dedoc search " .. lang .. " " .. query)
            local lines = {}
            for s in output:gmatch("[^\r\n]+") do
              table.insert(lines, s)
            end
            local tmpbuf = get_tmp_buffer()
            vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)
            vim.bo[tmpbuf].filetype = "markdown"
            local float = require("lazy.util").float({
              buf = tmpbuf,
              size = { width = 0.6, height = 0.6 },
            })
            local function get_entry(n)
              local entry = lines[n + 2]
              local lines = {}
              for s in entry:gmatch("%S+") do
                table.insert(lines, s)
              end
              second_word = string.gsub(lines[2], ",", "")
              local output = vim.fn.system("dedoc open " .. lang .. " " .. second_word)
              local newlines = {}
              for s in output:gmatch("[^\r\n]+") do
                table.insert(newlines, s)
              end
              local tmpbuf = get_tmp_buffer()
              local tmpbuf = vim.api.nvim_create_buf(true, true)
              -- vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, newlines)
              vim.bo[tmpbuf].filetype = "markdown"
              float:close()
              vim.cmd("vsplit")
              local win = vim.api.nvim_get_current_win()
              vim.api.nvim_win_set_buf(win, tmpbuf)
              vim.cmd("r !" .. "dedoc open " .. lang .. " " .. second_word)
              -- local buf = vim.api.nvim_get_current_buf()
              vim.bo[tmpbuf].filetype = "markdown"
              vim.cmd("normal! ggdd")
            end

            for i = 1, #lines do
              vim.keymap.set("n", tostring(i), function()
                get_entry(i)
              end, { buffer = tmpbuf, noremap = true, silent = true })
            end

            -- vim.ui.input({
            --   prompt = "Query",
            -- }, function(query)
            --   vim.notify("https://devdocs.io/" .. new .. "/" .. query)
            --   -- vim.fn.system("open " .. "https://devdocs.io/" .. query)
            -- end)
          end)
        end,

        -- local choices = {
        --   "bash",
        --   "jest",
        --   "lua-5.4",
        --   "python-3.9",
        --   "python-3.11",
        --   "python-3.12",
        --   "rails-7.1",
        --   "react",
        --   "ruby-3.3",
        -- }
        -- require("fzf-lua").fzf_exec(choices, {
        --   actions = {
        --     ["enter"] = function(sel, _opts)
        --       vim.fn.notify(sel)
        --       -- vim.system("open " .. "https://devdocs.io/" .. sel)
        --     end,
        --   },
        --   -- @param selected: the selected entry or entries
        --   -- @param opts: fzf-lua caller/provider options
        --   -- @param line: originating buffer completed line
        --   -- @param col: originating cursor column location
        --   -- @return newline: will replace the current buffer line
        --   -- @return newcol?: optional, sets the new cursor column
        --   -- complete = function(selected, opts, line, col)
        --   --   local newline = line:sub(1, col) .. selected[1]
        --   --   -- set cursor to EOL, since `nvim_win_set_cursor`
        --   --   -- is 0-based we have to lower the col value by 1
        --   --   return newline, #newline - 1
        --   -- end,
        -- })
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
            if next_char == "(" then search_term = search_term .. "(" end
          end

          local current_file = vim.fn.expand("%:t")
          local file_extension = current_file:match("^.+(%..+)$")
          -- require("fzf-lua").live_grep({
          pick("live_grep", {
            search = search_term,
            glob = "*." .. file_extension .. "!*{test,spec}/",
          })()
        end,
        desc = "References (grep)",
      },
      {
        "<leader>mt",
        function()
          local fzf_utils = require("fzf-lua.utils")
          local tags = require("grapple").tags()
          local entries = {}
          if not tags then return end

          for i, tag in ipairs(tags) do
            local idx = i
            local path = tag.path
            local line = (tag.cursor or { 1, 0 })[1]
            local col = (tag.cursor or { 1, 0 })[2]
            path = path:gsub("^" .. vim.fn.getcwd() .. "/", "")
            table.insert(
              entries,
              string.format(
                " %-15s %15s %15s %s",
                fzf_utils.ansi_codes.yellow(tostring(idx)),
                fzf_utils.ansi_codes.blue(tostring(line)),
                fzf_utils.ansi_codes.green(tostring(col)),
                path
              )
            )
          end
          table.sort(entries, function(a, b)
            return a < b
          end)
          table.insert(entries, 1, string.format("%-5s %s  %s %s", "mark", "line", "col", "path"))

          local fzf_lua = require("fzf-lua")
          local opts = {
            fzf_opts = { ["--header-lines"] = 1 },
            prompt = "Grapple>",
            fzf_colors = true,
            actions = {
              ["default"] = function(selected)
                local _, lnum, col, filepath = selected[1]:match("(.)%s+(%d+)%s+(%d+)%s+(.*)")
                vim.cmd("e " .. filepath)
                vim.defer_fn(function()
                  vim.fn.cursor(lnum, col)
                  vim.cmd("normal! zz")
                end, 50)
              end,
            },
            previewer = fzf_lua.defaults.marks.previewer,
          }
          fzf_lua.fzf_exec(entries, opts)
        end,
        desc = "Marks (Fzf)",
      },
      {
        "<leader>gR",
        function()
          require("util.git").open_recently_commited(10)
        end,
        desc = "Recently commited",
      },
    },
  },
  {

    "ibhagwan/fzf-lua",
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
      { "<leader>dL", function() require("fzf-lua").dap_breakpoints() end, desc = "Breakpoints", mode = "n" },
      { "<leader>dv", function() require("fzf-lua").dap_variables() end, desc = "Variables", mode = "n" },
      { "<leader>df", function() require("fzf-lua").dap_frames() end, desc = "Frames", mode = "n" },
      -- stylua: ignore end
    },
  },
}
