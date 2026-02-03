--[[
  To select items and put them in quickfix with :MiniPick:
  - Search for whatever you want to select
  - When you have the list of items press <C-a> (Ctrl + a) to select all
  - Then press <M-CR> (Alt + Enter) to put them in quickfix
  To select items from multiple subsequent searches:
  - Search for whatever you want to select
  - When you have the list of items press <C-a> (Ctrl + a) to select all
  - Perform your next search
  - When you have the list of items press <C-a> (Ctrl + a) to select all
  - When you're done selecting all the items across searches press <M-CR>
  (Alt + Enter) to put them in quickfix

  For more info check this: https://github.com/nvim-mini/mini.nvim/discussions/1853
]]

local MiniConf = {}

-- https://github.com/echasnovski/mini.nvim/blob/2e38ed16c2ced64bcd576986ccad4b18e2006e18/doc/mini-pick.txt#L650-L660
MiniConf.win_config = {
  helix = function()
    local height = math.floor(0.4 * vim.o.lines)
    local width = math.floor(0.4 * vim.o.columns)
    return {
      relative = "laststatus",
      anchor = "NW",
      height = height,
      width = width,
      row = 0,
      col = 0,
    }
  end,
  cursor = function()
    return {
      relative = "cursor",
      anchor = "NW",
      row = 0,
      col = 0,
      height = 50,
      width = 16,
    }
  end,
  center_small = function()
    local height = math.floor(0.40 * vim.o.lines)
    local width = math.floor(0.40 * vim.o.columns)
    return {
      -- 3 - Center small window
      border = "rounded",
      anchor = "NW",
      height = height,
      width = width,
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
      -- relative = "editor",
    }
  end,
  center = function()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.618 * vim.o.columns)
    return {
      anchor = "NW",
      height = height,
      width = width,
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
    }
  end,
}

local function map_gsub(items, pattern, replacement)
  return vim.tbl_map(function(item)
    item, _ = string.gsub(item, pattern, replacement)
    return item
  end, items)
end

local function show_align_on_null(buf_id, items, query, opts)
  -- Shorten the pathname to keep the width of the picker window to something
  -- a bit more reasonable for longer pathnames.
  -- items = map_gsub(items, '^%Z+', truncate_path)

  -- Because items is an array of blobs (contains a NUL byte), align_strings
  -- will not work because it expects strings. So, convert the NUL bytes to a
  -- unique (hopefully) separator, then align, and revert back.
  items = map_gsub(items, "%z", "#|#")
  items = require("mini.align").align_strings(items, {
    justify_side = { "left", "right", "right" },
    merge_delimiter = { "", " ", "", " ", "" },
    split_pattern = "#|#",
  })
  items = map_gsub(items, "#|#", "\0")
  MiniPick.default_show(buf_id, items, query, opts)
end

local picker
local function get_picker()
  if not picker then picker = require("util.minipick_registry.picker") end
  return picker
end

return {
  { import = "plugins.extras.ui.snacks-extended" },
  { import = "plugins.extras.editor.fzf-extended" },
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      { "<leader>:", false },
      { "<leader>fR", false },
      { "<leader>fr", false },
      { "<leader>s/", false },
      -- { "<leader>s<C-b>", false },
      { "<leader>sB", false },
      { "<leader>sC", false },
      { "<leader>sD", false },
      { "<leader>sH", false },
      { "<leader>sc", false },
      { "<leader>sd", false },
      { "<leader>sm", false },
      { '<leader>s"', false },
      -- { "<leader>st", false },
    },
  },
  {
    "ibhagwan/fzf-lua",
    optional = true,
    keys = {
      { "<leader>:", false },
      { "<leader><space>", false },
      { "<leader>fF", false },
      { "<leader>fM", false },
      { "<leader>fP", false },
      { "<leader>fR", false },
      { "<leader>fc", false },
      { "<leader>ff", false },
      { "<leader>fg", false },
      { "<leader>fr", false },
      { "<leader>ga", false },
      { "<leader>gc", false },
      { "<leader>gr", false },
      { "<leader>s/", false },
      { "<leader>s<C-m>", false },
      { "<leader>s<C-w>", false },
      { "<leader>sA", false },
      { "<leader>sC", false },
      { "<leader>sF", false },
      { "<leader>sG", false },
      { "<leader>sH", false },
      { "<leader>sN", false },
      { "<leader>sP", false },
      { "<leader>sR", false },
      { "<leader>sW", false },
      { "<leader>sc", false },
      { "<leader>sg", false },
      { "<leader>sh", false },
      { "<leader>sp", false },
      { "<leader>su", false },
      { "<leader>su", false, mode = { "v" } },
      { "<leader>sw", false },
      { "<leader>sw", false, mode = { "v" } },
    },
  },
  -- { import = "plugins.extras.mini.mini-fuzzy" },
  { import = "plugins.extras.mini.mini-visits" },
  {
    "nvim-mini/mini.pick",
    config = function()
      local MiniPick = require("mini.pick")
      require("util.minipick_registry.patches.move").apply()
      local choose_all = function()
        local mappings = MiniPick.get_picker_opts().mappings
        vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
      end
      MiniPick.setup({
        mappings = {
          choose_all = { char = "<c-q>", func = choose_all },
          sys_paste = {
            -- (mini.pick) Use `mappings.paste` (`<C-r>` by default) with "*" or "+" register.
            char = "<d-v>",
            func = function()
              -- Does not support expression register `=`.
              -- MiniPick.set_picker_query({ vim.fn.getreg("+") })
              MiniPick.set_picker_query({ vim.fn.getreg("0") })
            end,
          },
          caret_left = "<Left>",
          caret_right = "<Right>",

          choose = "<CR>",
          choose_in_split = "<C-s>",
          choose_in_tabpage = "<C-t>",
          choose_in_vsplit = "<C-v>",
          choose_marked = "<M-CR>",

          delete_char = "<BS>",
          delete_char_right = "<Del>",
          -- delete_left = "<C-u>",
          delete_left = "<M-u>",
          delete_word = "<C-w>",

          mark = "<C-x>",
          mark_all = "<C-a>",

          move_down = "<C-n>",
          move_start = "<C-g>",
          move_up = "<C-p>",

          move_down_alt = {
            char = "<C-j>",
            func = function()
              vim.api.nvim_input("<C-n>")
            end,
          },

          -- NOTE: doesn't work for some reason
          -- move_up_alt = {
          --   char = "<C-k>",
          --   func = function()
          --     vim.api.nvim_input("<C-p>")
          --   end,
          -- },

          paste = "<C-r>",

          refine = "<C-Space>",
          refine_marked = "<M-Space>",

          -- scroll_down = "<C-f>",
          scroll_down = "<C-d>",
          scroll_left = "<C-h>",
          scroll_right = "<C-l>",
          -- scroll_up = "<C-b>",
          scroll_up = "<C-u>",

          stop = "<Esc>",

          toggle_info = "<S-Tab>",
          toggle_preview = "<Tab>",
          -- Requires the following patch in: /Users/aaron/.local/share/nvim/lazy/mini.pick/lua/mini/pick.lua
          -- MiniPick._with_focus_lock = function(fn)
          --   if type(H.cache) ~= "table" then return fn() end
          --   local prev = H.cache.is_in_getcharstr
          --   H.cache.is_in_getcharstr = true
          --   local ok, result = pcall(fn)
          --   H.cache.is_in_getcharstr = prev
          --   if not ok then error(result) end
          --   return result
          -- end
          -- leap = {
          --   char = "<M-s>",
          --   func = function()
          --     local state = MiniPick.get_picker_state()
          --     if not state or not state.windows or not state.windows.main then return end
          --     local win_id = state.windows.main
          --     local run = function()
          --       require("leap").leap({
          --         target_windows = { win_id },
          --         action = function(target)
          --           local current_line = vim.api.nvim_win_get_cursor(win_id)[1]
          --           local delta = target.pos[1] - current_line
          --           if delta == 0 then return end
          --           local key = delta >= 0 and "<C-n>" or "<C-p>"
          --           for _ = 1, math.abs(delta) do
          --             vim.api.nvim_input(key)
          --           end
          --         end,
          --       })
          --     end
          --     if MiniPick._with_focus_lock then MiniPick._with_focus_lock(run) end
          --   end,
          -- },
        },
        window = { config = MiniConf.win_config.center() },
      })

      -- require("util.minipick_registry.patches.move").apply()
      require("util.minipick_registry.hints").setup({})

      require("util.minipick_registry.files_ext").setup(MiniPick)
      require("util.minipick_registry.my_buffers").setup(MiniPick)
      require("util.minipick_registry.rg_live_grep").setup(MiniPick)
      require("util.minipick_registry.rg_grep").setup(MiniPick)
      require("util.minipick_registry.fuzzy_files").setup(MiniPick)
      require("util.minipick_registry.smart").setup(MiniPick)
      require("util.minipick_registry.keymaps").setup(MiniPick)
      require("util.minipick_registry.bufferlines_ts").setup(MiniPick)
      require("util.minipick_registry.mgrep").setup(MiniPick)

      MiniPick.registry.grep_todo_keywords = function(local_opts)
        local_opts = local_opts or {}
        local_opts.pattern = "(TODO|FIXME|HACK|NOTE):"
        MiniPick.builtin.grep(local_opts, {})
      end

      vim.api.nvim_create_augroup("MiniPick", { clear = true })
    end,
    init = function()
      LazyVim.on_very_lazy(function()
        vim.ui.select = function(...)
          vim.ui.select = MiniPick.ui_select
          require("lazy").load({ plugins = { "mini.pick" } })
          return vim.ui.select(...)
        end
      end)
    end,
    keys = {
      {
        "<D-p>",
        function()
          local buf = vim.api.nvim_get_current_buf()
          local opts = { source = { cwd = Snacks.git.get_root(Util.path.bufdir(buf)) } }
          MiniPick.registry.fuzzy_files({
            matcher = "auto", -- "fzf" | "fzf_dp" | "auto"
            auto = { threshold = 20000 },
            -- fzf = { preset = "filename_bias" }
            -- source = { cwd = Snacks.git.get_root(Util.path.bufdir(buf))
          }, opts)
        end,
        desc = "Files (cwd)",
      },
      {
        "<leader>,",
        function()
          MiniPick.registry.my_buffers()
        end,
        desc = "Buffers (recent)",
      },
      {
        "<leader>fs",
        function()
          MiniPick.registry.smart({ flags = { "two_days" } })
        end,
        desc = "Mini Smart Picker",
      },
      {
        "<leader><space>",
        function()
          get_picker().pick_files()
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>ff",
        function()
          get_picker().pick_files()
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fF",
        function()
          get_picker().pick_files(get_picker().cwd_dir())
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fN",
        function()
          -- Notification is handled by #node_modules_dir
          local path = Util.picker.node_modules_dir()
          if not path then return end

          get_picker().pick_files(path)
        end,
        desc = "Files (node_modules)",
      },
      {
        "<leader>fc",
        function()
          get_picker().pick_files(vim.fn.stdpath("config"), {}, { source = { name = "Config" } })
        end,
        desc = "Find Config Files",
      },
      {
        "<leader>fl",
        function()
          get_picker().pick_files(get_lazyvim_base_dir(), {}, { source = { name = "LazyVim" } })
        end,
        desc = "Find LazyVim Files",
      },
      {
        "<leader>fp",
        function()
          get_picker().pick_files(get_picker().lazyvim_plugins_dir(), {}, { source = { name = "Plugins" } })
        end,
        desc = "Plugins",
      },

      {
        "<leader>su",
        function()
          local pick = get_picker()
          pick.pick_grep(vim.fn.expand("<cword>"))
        end,
        desc = "Word",
        mode = "n",
      },
      {
        "<leader>su",
        function()
          local pick = get_picker()
          pick.pick_grep()
        end,
        desc = "Visual selection or word (Root Dir)",
        mode = "v",
      },
      {
        "<leader>su",
        function()
          local pick = get_picker()
          pick.pick_grep()
        end,
        desc = "Visual selection or word (cwd)",
        mode = "v",
      },
      {
        "<leader>sw",
        function()
          local pick = get_picker()
          pick.pick_grep(vim.fn.expand("<cword>"))
        end,
        desc = "Word (Root Dir)",
        mode = "n",
      },
      {
        "<leader>sW",
        function()
          local pick = get_picker()
          pick.pick_grep(vim.fn.expand("<cword>"), nil, { source = { cwd = pick.cwd_dir() } })
        end,
        desc = "Word (cwd)",
        mode = "n",
      },
      {
        "<leader>sw",
        function()
          local pick = get_picker()
          pick.pick_grep()
        end,
        desc = "Selection (Root Dir)",
        mode = "v",
      },
      {
        "<leader>sW",
        function()
          local pick = get_picker()
          pick.pick_grep(nil, nil, { source = { cwd = pick.cwd_dir() } })
        end,
        desc = "Selection (cwd)",
        mode = "v",
      },
      {
        "<leader>s<C-w>",
        function()
          local pick = get_picker()
          pick.pick_grep(vim.fn.expand("<cWORD>"))
        end,
        desc = "WORD (Root Dir)",
        mode = "n",
      },
      {
        "<leader>/",
        function()
          get_picker().pick_grep_live()
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sg",
        function()
          get_picker().pick_grep_live()
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sG",
        function()
          get_picker().pick_grep_live({}, { source = { cwd = get_picker().cwd_dir() } })
        end,
        desc = "Grep (cwd)",
      },
      -- { "<leader>sP", function() MiniPick.registry.rg_pcre2({}, { source = { cwd = get_picker().root_dir() } }) end, desc = "Grep (--pcre2)" },
      {
        "<leader>s<M-l>",
        function()
          get_picker().pick_grep_live({}, { source = { cwd = get_lazyvim_base_dir(), name = "LazyVim" } })
        end,
        desc = "Grep LazyVim Files",
      },
      {
        "<leader>s<M-c>",
        function()
          get_picker().pick_grep_live({}, { source = { cwd = vim.fn.stdpath("config"), name = "Config" } })
        end,
        desc = "Grep Config Files",
      },
      {
        "<leader>sp",
        function()
          get_picker().pick_grep_live(
            { ts_highlight = false },
            { source = { cwd = get_picker().lazyvim_plugins_dir(), name = "Plugins" } }
          )
        end,
        desc = "Grep Plugins",
      },
      {
        "<leader>sN",
        function()
          local path = Util.picker.node_modules_dir()
          if not path then return end
          get_picker().pick_grep_live({ ts_highlight = false }, { source = { cwd = path, name = "Node Modules" } })
        end,
        desc = "Grep (node_modules)",
      },
      {
        "<leader>sF",
        function()
          get_picker().pick_grep(vim.fn.expand("<cword>"), { flags = { "fixed_strings" } })
        end,
        desc = "Grep (--fixed-strings)",
        mode = { "n" },
      },
      {
        "<leader>sF",
        function()
          get_picker().pick_grep(nil, { flags = { "fixed_strings" } })
        end,
        desc = "Grep (--fixed-strings)",
        mode = { "v" },
      },
      {
        "<leader>s<M-r>",
        function()
          Util.picker.gem_dir(function(path, name)
            get_picker().pick_grep_live({}, { source = { cwd = path, name = name } })
          end)
        end,
      },
      {
        "<leader>s<C-m>",
        function()
          -- Grep ruby gem or node module dir, if current buf is a file inside of one
          local result = Util.picker.node_module_subdir()
          if result then
            local path = result.path or result
            local display = result.display
            get_picker().pick_grep_live({}, { source = { cwd = path, name = ("node_modules/%s"):format(display) } })
          end
        end,
        desc = "Node module subdir",
      },
      {
        "<leader>sB",
        function()
          require("mini.extra").pickers.buf_lines({ scope = "all" })
        end,
        desc = "Grep Buffers",
      },
      -- { "<leader>sb", function() require("mini.extra").pickers.buf_lines({ scope = "current" }) end, desc = "Lines" },
      -- { "<leader>sb", function() MiniPick.registry.bufferlines_ts({ scope = "current" }) end, desc = "Lines" },
      -- { "<leader>sb", function()
      --   MiniPick.registry.bufferlines_ts({ scope = "current" })
      --   local lines, _ = Util.selection.get_visual_selection()
      --   vim.schedule_wrap(function()
      --     MiniPick.set_picker_query(vim.split(lines, "n"))
      --   end)
      -- end, desc = "Lines", mode = {"v"} },
      {
        '<leader>s"',
        function()
          require("mini.extra").pickers.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function()
          require("mini.extra").pickers.history({ scope = "/" }, { hinted = { enable = true } })
        end,
        desc = "Search History",
      },
      {
        "<leader>:",
        function()
          require("mini.extra").pickers.history({ scope = ":" }, { hinted = { enable = true } })
        end,
        desc = "Command History",
      },
      {
        "<leader>sc",
        function()
          require("mini.extra").pickers.history({ scope = ":" }, { hinted = { enable = true } })
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          require("mini.extra").pickers.commands()
        end,
        desc = "Commands",
      },
      -- { "<leader>sD", function() require("mini.extra").pickers.diagnostic() end, desc = "Diagnostics" },
      -- { "<leader>sd", function() require("mini.extra").pickers.diagnostic({ scope = "current" }) end, desc = "Buffer Diagnostics" },
      {
        "<leader>sH",
        function()
          require("mini.extra").pickers.hl_groups()
        end,
        desc = "Search Highlight Groups",
      },
      {
        "<leader>sh",
        function()
          require("mini.pick").builtin.help()
        end,
        desc = "Search Highlight Groups",
      },
      -- { "<leader>sk", function() require("mini.pick").registry.keymaps_callback() end, desc = "Keymaps" },
      {
        "<leader>sm",
        function()
          require("mini.extra").pickers.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sA",
        function()
          require("mini.extra").pickers.treesitter()
        end,
        desc = "Treesitter Symbols",
      },
      {
        "<leader>sR",
        function()
          require("mini.pick").builtin.resume()
        end,
        desc = "Grep (Live)",
      },
      -- { "<leader>st", function() require("mini.pick").registry.grep_todo_keywords() end, desc = "Todo"},
      {
        "<leader>s<C-t>",
        function()
          get_picker().pick_files(nil, { fd_flags = { "today", "no_ignore" }, source = { name = "Today" } })
        end,
        desc = "Today",
      },

      -- Git
      -- { "<leader>ga", function() require("mini.extra").pickers.git_branches() end, desc = "Git Branches" },
      -- { "<leader>gA", function() require("mini.extra").pickers.git_branches({ scope = "remote"}) end, desc = "Branches" },
      {
        "<leader>gc",
        function()
          require("mini.extra").pickers.git_commits()
        end,
        desc = "Commits",
      },
      {
        "<leader>fr",
        function()
          require("mini.extra").pickers.visit_paths()
        end,
        desc = "Visit paths",
      },
      {
        "<leader>fR",
        function()
          require("mini.extra").pickers.oldfiles()
        end,
        desc = "Recent",
      },
      -- { "<leader>fR", function() require("mini.extra").pickers.oldfiles({ current_dir = true }) end, desc = "Recent (cwd)" },
      {
        "z=",
        function()
          require("mini.extra").pickers.spellsuggest()
        end,
        desc = "Spelling Suggestions",
      },
      -- { "<leader>sJ", function() require("mini.extra").pickers.visit_labels() end, desc = "Visit labels" },
      {
        "<leader>fg",
        function()
          require("mini.extra").pickers.git_files()
        end,
        desc = "Files",
      },
      -- { "<leader>gs", function() require("mini.extra").pickers.git_hunks({scope = "unstaged"}) end, desc = "Git Diff" },
      -- { "<leader>gS", function() require("mini.extra").pickers.git_hunks({scope = "staged"}) end, desc = "Git Diff (Staged)" },
      --stylua: ignore end
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- stylua: ignore
          keys = {
            { "gd", function() get_picker().pick_lsp2({ scope = "definition"}) end, desc = "Goto Definition", has = "definition" },
            { "gD", function() get_picker().pick_lsp2({ scope = "declaration"}) end, desc = "Goto Definition", has = "definition" },
            { "gr", function() get_picker().pick_lsp2({ scope = "references"}) end, nowait = true, desc = "References" },
            { "gI", function() get_picker().pick_lsp2({ scope = "implementation"}) end, desc = "Goto Implementation" },
            { "gy", function() get_picker().pick_lsp2({ scope = "type_definition" }) end, desc = "Goto T[y]pe Definition" },
            { "<leader>ss", function() get_picker().pick_lsp2({ scope = "document_symbol_live" }) end, desc = "LSP Symbols", has = "documentSymbol" },
            { "<leader>sS", function() get_picker().pick_lsp2({ scope = "workspace_symbol_live" }) end, desc = "Workspace Symbols", has = "workspace/symbols" },
            -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming", has = "callHierarchy/incomingCalls" },
            -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing", has = "callHierarchy/outgoingCalls" },
          },
        },
      },
    },
  },
}
