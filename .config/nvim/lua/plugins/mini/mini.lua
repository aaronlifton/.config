return {
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.move").setup()
      require("mini.extra").setup()
      require("mini.colors").setup()
      require("mini.bracketed").setup({
        -- can overwrite [b since I use bufferline HL
        buffer = { suffix = "", options = {} },
        comment = { suffix = "", options = {} },
        conflict = { suffix = "", options = {} },
        -- might already be in mini.indent-scope
        -- diagnostic = { suffix = "d", options = {} },
        file = { suffix = "", options = {} },
        -- indent     = { suffix = "i", options = {} },
        jump = { suffix = "j", options = {} },
        -- location   = { suffix = "l", options = {} },
        oldfile = { suffix = "o", options = {} },
        quickfix = { suffix = "q", options = {} },
        treesitter = { suffix = "t", options = {} },
        undo = { suffix = "u", options = {} },
        -- window     = { suffix = "w", options = {} },
        yank = { suffix = "z", options = {} },
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
      --     starter.gen_hook.aligning('center', 'center'),
      --   },
      -- })
    end,
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
    -- keys = {
    -- { "H", "<cmd>lua require('mini.move').goto_line_left()<cr>" },
    -- },
  },

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
}
