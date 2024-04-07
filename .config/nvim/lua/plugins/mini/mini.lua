return {
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.move").setup()
      require("mini.extra").setup()
      require("mini.colors").setup()
      require("mini.bracketed").setup()
      require("mini.pick").setup({
        mappings = {
          caret_left = "<Left>",
          caret_right = "<Right>",

          choose = "<CR>",
          choose_in_split = "<C-s>",
          choose_in_tabpage = "<C-t>",
          choose_in_vsplit = "<C-v>",
          choose_marked = "<M-CR>",

          delete_char = "<BS>",
          delete_char_right = "<Del>",
          delete_left = "<C-u>",
          delete_word = "<C-w>",

          mark = "<C-x>",
          mark_all = "<C-a>",

          move_down = "<C-n>",
          move_start = "<C-g>",
          move_up = "<C-p>",

          paste = "<C-r>",

          refine = "<C-Space>",
          refine_marked = "<M-Space>",

          scroll_down = "<C-f>",
          scroll_left = "<C-h>",
          scroll_right = "<C-l>",
          scroll_up = "<C-b>",

          stop = "<Esc>",

          toggle_info = "<S-Tab>",
          toggle_preview = "<Tab>",
        },
      })
      require("mini.splitjoin").setup()

      -- local starter = require("mini.starter")
      -- starter.setup({
      --   evaluate_single = true,
      --   items = {
      --     starter.sections.builtin_actions(),
      --     starter.sections.recent_files(10, false),
      --     starter.sections.recent_files(10, true),
      --     -- Use this if you set up 'mini.sessions'
      --     starter.sections.sessions(5, true),
      --   },
      --   content_hooks = {
      --     starter.gen_hook.adding_bullet(),
      --     starter.gen_hook.indexing("all", { "Builtin actions" }),
      --     starter.gen_hook.padding(3, 2),
      --   },
      -- })
    end,
    -- -- Configuration similar to 'glepnir/dashboard-nvim':
    -- local starter = require('mini.starter')
    -- starter.setup({
    --   items = {
    --     starter.sections.telescope(),
    --   },
    --   content_hooks = {
    --     starter.gen_hook.adding_bullet(),
    --     starter.gen_hook.aligning('center', 'center'),
    --   },
    -- })

    -- local my_items = {
    --   { name = "Echo random number", action = "lua print(math.random())", section = "Section 1" },
    --   function()
    --     return {
    --       { name = "Item #1 from function", action = [[echo 'Item #1']], section = "From function" },
    --       { name = "Placeholder (always inactive) item", action = "", section = "From function" },
    --       function()
    --         return {
    --           name = "Item #1 from double function",
    --           action = [[echo 'Double function']],
    --           section = "From double function",
    --         }
    --       end,
    --     }
    --   end,
    --   { name = [[Another item in 'Section 1']], action = "lua print(math.random() + 10)", section = "Section 1" },
    -- }

    -- local footer_n_seconds = (function()
    --   local timer = vim.loop.new_timer()
    --   local n_seconds = 0
    --   timer:start(
    --     0,
    --     1000,
    --     vim.schedule_wrap(function()
    --       if vim.bo.filetype ~= "starter" then
    --         timer:stop()
    --         return
    --       end
    --       n_seconds = n_seconds + 1
    --       MiniStarter.refresh()
    --     end)
    --   )
    --
    --   return function()
    --     return "Number of seconds since opening: " .. n_seconds
    --   end
    -- end)()

    -- local hook_top_pad_10 = function(content)
    --   -- Pad from top
    --   for _ = 1, 10 do
    --     -- Insert at start a line with single content unit
    --     table.insert(content, 1, { { type = "empty", string = "" } })
    --   end
    --   return content
    -- end

    -- starter.setup({
    --   items = my_items,
    --   footer = footer_n_seconds,
    --   content_hooks = { hook_top_pad_10 },
    -- })
    --
    -- {
    --   buf_lines = <function 1>,
    --   commands = <function 2>,
    --   diagnostic = <function 3>,
    --   explorer = <function 4>,
    --   git_branches = <function 5>,
    --   git_commits = <function 6>,
    --   git_files = <function 7>,
    --   git_hunks = <function 8>,
    --   hipatterns = <function 9>,
    --   history = <function 10>,
    --   hl_groups = <function 11>,
    --   keymaps = <function 12>,
    --   list = <function 13>,
    --   lsp = <function 14>,
    --   marks = <function 15>,
    --   oldfiles = <function 16>,
    --   options = <function 17>,
    --   registers = <function 18>,
    --   spellsuggest = <function 19>,
    --   treesitter = <function 20>,
    --   visit_labels = <function 21>,
    --   visit_paths = <function 22>
    -- }
    -- {
    --   -- Delays (in ms; should be at least 1)
    --   delay = {
    --     -- Delay between forcing asynchronous behavior
    --     async = 10,
    --
    --     -- Delay between computation start and visual feedback about it
    --     busy = 50,
    --   },
    --
    --   -- Keys for performing actions. See `:h MiniPick-actions`.
    --   mappings = {
    --     caret_left = "<Left>",
    --     caret_right = "<Right>",
    --
    --     choose = "<CR>",
    --     choose_in_split = "<C-s>",
    --     choose_in_tabpage = "<C-t>",
    --     choose_in_vsplit = "<C-v>",
    --     choose_marked = "<M-CR>",
    --
    --     delete_char = "<BS>",
    --     delete_char_right = "<Del>",
    --     delete_left = "<C-u>",
    --     delete_word = "<C-w>",
    --
    --     mark = "<C-x>",
    --     mark_all = "<C-a>",
    --
    --     move_down = "<C-n>",
    --     move_start = "<C-g>",
    --     move_up = "<C-p>",
    --
    --     paste = "<C-r>",
    --
    --     refine = "<C-Space>",
    --     refine_marked = "<M-Space>",
    --
    --     scroll_down = "<C-f>",
    --     scroll_left = "<C-h>",
    --     scroll_right = "<C-l>",
    --     scroll_up = "<C-b>",
    --
    --     stop = "<Esc>",
    --
    --     toggle_info = "<S-Tab>",
    --     toggle_preview = "<Tab>",
    --   },
    --
    --   -- General options
    --   options = {
    --     -- Whether to show content from bottom to top
    --     content_from_bottom = false,
    --
    --     -- Whether to cache matches (more speed and memory on repeated prompts)
    --     use_cache = false,
    --   },
    --
    --   -- Source definition. See `:h MiniPick-source`.
    --   source = {
    --     items = nil,
    --     name = nil,
    --     cwd = nil,
    --
    --     match = nil,
    --     show = nil,
    --     preview = nil,
    --
    --     choose = nil,
    --     choose_marked = nil,
    --   },
    --
    --   -- Window related options
    --   window = {
    --     -- Float window config (table or callable returning it)
    --     config = nil,
    --
    --     -- String to use as cursor in prompt
    --     prompt_cursor = "▏",
    --
    --     -- String to use as prefix in prompt
    --     prompt_prefix = "> ",
    --   },
    -- }
    -- )
    keys = {
      -- {
      --   "<C-s>",
      --   function(item)
      --     if vim.fn.filereadable(item) == 0 then
      --       return
      --     end
      --     vim.api.nvim_win_call(MiniPick.get_picker_state().windows.main, function()
      --       vim.cmd("vsplit " .. item)
      --     end)
      --     return true
      --   end,
      -- },
      -- { "H", "<cmd>lua require('mini.move').goto_line_left()<cr>" },
      {
        "<leader>Pb",
        function()
          MiniExtra.pickers.buf_lines()
        end,
        desc = "Buffer lines",
      },
      {
        "<leader>Pf",
        function()
          MiniExtra.pickers.explorer()
        end,
        desc = "Explorer",
      },
      {
        "<leader>PF",
        function()
          MiniExtra.pickers.git_files({ scope = "modified" })
        end,
        desc = "Git files",
      },
      {
        "<leader>Pg",
        function()
          MiniExtra.pickers.git_branches()
        end,
        desc = "Git branches",
      },
      {
        "<leader>PG",
        function()
          MiniExtra.pickers.git_commits()
        end,
        desc = "Git commits",
      },
      {
        "<leader>Ph",
        function()
          MiniExtra.pickers.git_hunks()
        end,
        desc = "Git hunks",
      },
      {
        "<leader>PH",
        function()
          MiniExtra.pickers.hipatterns()
        end,
        desc = "Hitpatterns",
      },
      {
        "<leader>Pr",
        function()
          MiniExtra.pickers.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>Pu",
        function()
          MiniExtra.pickers.history()
        end,
        desc = "History",
      },
      {
        "<leader>Pg",
        function()
          MiniExtra.pickers.hl_groups()
        end,
        desc = "Hl groups",
      },
      {
        "<leader>Pk",
        function()
          MiniExtra.pickers.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>Pl",
        function()
          MiniExtra.pickers.list()
        end,
        desc = "List",
      },
      {
        "<leader>PL",
        function()
          MiniExtra.pickers.lsp("declaration")
          -- - Needs an explicit scope from a list of supported ones:
          --     - "declaration".
          --     - "definition".
          --     - "document_symbol".
          --     - "implementation".
          --     - "references".
          --     - "type_definition".
          --     - "workspace_symbol".
        end,
        desc = "LSP",
      },
      {
        "<leader>Pm",
        function()
          MiniExtra.pickers.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>Pb",
        function()
          MiniExtra.pickers.oldfiles()
        end,
        desc = "Buffers",
      },
      {
        "<leader>Pc",
        function()
          MiniExtra.pickers.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>Ph",
        function()
          MiniExtra.pickers.help_tags()
        end,
        desc = "Help",
      },
      {
        "<leader>Pv",
        function()
          MiniExtra.pickers.options()
        end,
        desc = "Vim options",
      },
      {
        "<leader>Pt",
        function()
          MiniExtra.pickers.treesitter()
        end,
        desc = "Treesitter nodes",
      },
      {
        "<leader>Pv",
        function()
          MiniExtra.pickers.visit_paths()
        end,
        desc = "Visit paths",
      },
      {
        "<leader>PV",
        function()
          MiniExtra.pickers.visit_labels()
        end,
        desc = "Visit labels",
      },
      {
        "<leader>Pd",
        function()
          MiniExtra.pickers.diagnostic()
        end,
        desc = "Diagnostics",
      },
    },
  },
  --   {
  --     "echasnovski/mini.animate",
  --     event = "VeryLazy",
  --     opts = function()
  --       -- don't use animate when scrolling with the mouse
  --       local mouse_scrolled = false
  --       for _, scroll in ipairs({ "Up", "Down" }) do
  --         local key = "<ScrollWheel" .. scroll .. ">"
  --         vim.keymap.set({ "", "i" }, key, function()
  --           mouse_scrolled = true
  --           return key
  --         end, { expr = true })
  --       end
  --
  --       local animate = require("mini.animate")
  --       return {
  --         resize = {
  --           timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
  --         },
  --         scroll = {
  --           timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
  --           subscroll = animate.gen_subscroll.equal({
  --             predicate = function(total_scroll)
  --               if mouse_scrolled then
  --                 mouse_scrolled = false
  --                 return false
  --               end
  --               return total_scroll > 1
  --             end,
  --           }),
  --         },
  --       }
  --     end,
  --   },
  -- {
  --   "echasnovski/mini.surround",
  --   opts = {
  --     mappings = {
  --       add = "gs",
  --       delete = "gsd",
  --       find = "gsf",
  --       find_left = "gsF",
  --       highlight = "gsh",
  --       replace = "gsr",
  --       update_n_lines = "gsn",
  --     },
  --   },
  -- },
  --   {
  --     "echasnovski/mini.pairs",
  --     config = {},
  --     opts = function()
  --       require("mini.pairs").setup(config)
  --     end,
  --   },
  --   {
  --     "echasnovski/mini.hipatterns",
  --     event = "LazyFile",
  --     opts = function()
  --       local hi = require("mini.hipatterns")
  --       return {
  --         -- custom LazyVim option to enable the tailwind integration
  --         tailwind = {
  --           enabled = true,
  --           ft = { "typescriptreact", "javascriptreact", "css", "javascript", "typescript", "html" },
  --           -- full: the whole css class will be highlighted
  --           -- compact: only the color will be highlighted
  --           style = "full",
  --         },
  --         highlighters = {
  --           hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
  --         },
  --       }
  --     end,
  --     config = function(_, opts)
  --       -- backward compatibility
  --       if opts.tailwind == true then
  --         opts.tailwind = {
  --           enabled = true,
  --           ft = { "typescriptreact", "javascriptreact", "css", "javascript", "typescript", "html" },
  --           style = "full",
  --         }
  --       end
  --       if type(opts.tailwind) == "table" and opts.tailwind.enabled then
  --         -- reset hl groups when colorscheme changes
  --         vim.api.nvim_create_autocmd("ColorScheme", {
  --           callback = function()
  --             M.hl = {}
  --           end,
  --         })
  --         opts.highlighters.tailwind = {
  --           pattern = function()
  --             if not vim.tbl_contains(opts.tailwind.ft, vim.bo.filetype) then
  --               return
  --             end
  --             if opts.tailwind.style == "full" then
  --               return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
  --             elseif opts.tailwind.style == "compact" then
  --               return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
  --             end
  --           end,
  --           group = function(_, _, m)
  --             ---@type string
  --             local match = m.full_match
  --             ---@type string, number
  --             local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
  --             shade = tonumber(shade)
  --             local bg = vim.tbl_get(M.colors, color, shade)
  --             if bg then
  --               local hl = "MiniHipatternsTailwind" .. color .. shade
  --               if not M.hl[hl] then
  --                 M.hl[hl] = true
  --                 local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
  --                 local fg = vim.tbl_get(M.colors, color, bg_shade)
  --                 vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
  --               end
  --               return hl
  --             end
  --           end,
  --           priority = 2000,
  --         }
  --       end
  --       require("mini.hipatterns").setup(opts)
  --     end,
  --   },
}
