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

return {
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
          leap = {
            char = "<M-s>",
            func = function()
              local state = MiniPick.get_picker_state()
              if not state or not state.windows or not state.windows.main then return end
              local win_id = state.windows.main
              local run = function()
                require("leap").leap({
                  target_windows = { win_id },
                  action = function(target)
                    local current_line = vim.api.nvim_win_get_cursor(win_id)[1]
                    local delta = target.pos[1] - current_line
                    if delta == 0 then return end
                    local key = delta >= 0 and "<C-n>" or "<C-p>"
                    for _ = 1, math.abs(delta) do
                      vim.api.nvim_input(key)
                    end
                  end,
                })
              end
              if MiniPick._with_focus_lock then MiniPick._with_focus_lock(run) end
            end,
          },
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
      -- {
      --   "<leader>s<M-g>",
      --   function()
      --     local buf = vim.api.nvim_get_current_buf()
      --     MiniPick.registry.iglob({}, {
      --       source = { cwd = Snacks.git.get_root(Util.path.bufdir(buf)) },
      --       show = show_align_on_null,
      --     })
      --   end,
      --   desc = "Grep (Live, iglob)",
      -- },
      --stylua: ignore start
      { "<leader>s<C-r>", function() require("mini.pick").builtin.resume() end, desc = "Grep (Live)"},
      -- { "<leader>f<M-b>", function() require("mini.pick").builtin.buffers() end, desc = "Buffers"},
      { "<leader>,", function() MiniPick.registry.my_buffers() end, desc = "Buffers (recent)" },
      { "<leader>fs", function() MiniPick.registry.smart({ flags = { "two_days" } }) end, desc = "Mini Smart Picker" },
      -- { "<leader>Pb", function() MiniExtra.pickers.buf_lines() end, desc = "Buffer lines" },
      -- { "<leader>Pf", function() MiniExtra.pickers.explorer() end, desc = "Explorer" },
      -- { "<leader>PF", function() MiniExtra.pickers.git_files({ scope = "modified" }) end, desc = "Git files" },
      -- { "<leader>Pg", function() MiniExtra.pickers.git_branches() end, desc = "Git branches" },
      -- { "<leader>PG", function() MiniExtra.pickers.git_commits() end, desc = "Git commits" },
      -- { "<leader>Ph", function() MiniExtra.pickers.git_hunks() end, desc = "Git hunks" },
      -- { "<leader>PH", function() MiniExtra.pickers.hipatterns() end, desc = "Hitpatterns" },
      -- { "<leader>Pr", function() MiniExtra.pickers.registers() end, desc = "Registers" },
      -- { "<leader>Pu", function() MiniExtra.pickers.history() end, desc = "History" },
      -- { "<leader>Pg", function() MiniExtra.pickers.hl_groups() end, desc = "Hl groups" },
      -- { "<leader>Pk", function() MiniExtra.pickers.keymaps() end, desc = "Keymaps" },
      -- { "<leader>Pl", function() MiniExtra.pickers.list() end, desc = "List" },
      -- -- "declaration" | "definition" | "document_symbol" | "implementation" | "references" | "type_definition" | "workspace_symbol"
      -- { "<leader>PL", function() MiniExtra.pickers.lsp("declaration") end, desc = "LSP" },
      -- { "<leader>Pm", function() MiniExtra.pickers.marks() end, desc = "Marks" },
      -- { "<leader>Pb", function() MiniExtra.pickers.oldfiles() end, desc = "Buffers" },
      -- { "<leader>Pc", function() MiniExtra.pickers.commands() end, desc = "Commands" },
      -- { "<leader>Ph", function() MiniExtra.pickers.help_tags() end, desc = "Help" },
      -- { "<leader>Pv", function() MiniExtra.pickers.options() end, desc = "Vim options" },
      -- { "<leader>Pt", function() MiniExtra.pickers.treesitter() end, desc = "Treesitter nodes" },
      -- { "<leader>Pv", function() MiniExtra.pickers.visit_paths() end, desc = "Visit paths" },
      -- { "<leader>PV", function() MiniExtra.pickers.visit_labels() end, desc = "Visit labels" },
      -- { "<leader>Pd", function() MiniExtra.pickers.diagnostic() end, desc = "Diagnostics" },
      --stylua: ignore end
    },
  },
}
