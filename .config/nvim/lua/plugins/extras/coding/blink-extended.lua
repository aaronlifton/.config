return {
  { import = "lazyvim.plugins.extras.coding.blink" },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
      completion = {
        menu = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            -- To right-align the kind label ext https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
            -- components = {
            --   kind_icon = { width = { fill = true } },
            -- },
          },
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= "cmdline" and not require("blink.cmp").snippet_active({ direction = 1 })
            end,
          },
        },
      },
      sources = {
        -- default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          -- snippets = {
          --   score_offset = -2,
          -- },

          -- copilot = {
          --   score_offset = 100
          -- }
          -- buffer = {
          -- should_show_items = false,
          -- },
        },
        -- Included by default, but override LazyVim setting empty cmdline sources
        cmdline = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then return { "buffer" } end
          -- Commands
          if type == ":" then return { "cmdline" } end
          return {}
        end,
      },
      -- keymap = {
      --   -- Supertab
      --   ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      --   ["<C-e>"] = { "hide", "fallback" },
      --
      --   ["<Tab>"] = {
      --     function(cmp)
      --       -- vim.api.nvim_echo({ { vim.inspect(cmp), "Normal" } }, true, {})
      --
      --       if cmp.is_in_snippet() then
      --         return cmp.accept()
      --       else
      --         return cmp.select_and_accept()
      --       end
      --     end,
      --     "snippet_forward",
      --     "fallback",
      --   },
      --   ["<S-Tab>"] = { "snippet_backward", "fallback" },
      --
      --   ["<Up>"] = { "select_prev", "fallback" },
      --   ["<Down>"] = { "select_next", "fallback" },
      --   ["<C-p>"] = { "select_prev", "fallback" },
      --   ["<C-n>"] = { "select_next", "fallback" },
      --
      --   ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      --   ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      -- },
    },
  },
  -- Configure per-filetype completion sources
  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   config = function(_, opts)
  --     -- { "lsp", "path", "snippets", "buffer", "lazydev", "dadbod", "copilot" }
  --     opts.sources.completion = opts.sources.completion or {}
  --     local prev_enabled_providers = opts.sources.completion.enabled_providers
  --     opts.sources.completion.enabled_providers = function()
  --       if vim.bo.filetype == "mchat" then return { "buffer", "path" } end
  --
  --       return prev_enabled_providers
  --     end
  --   end,
  -- },
}

--   ['<C-e>'] = { 'hide', 'fallback' },
--
--   ['<Tab>'] = {
--     function(cmp)
--       if cmp.snippet_active() then return cmp.accept()
--       else return cmp.select_and_accept() end
--     end,
--     'snippet_forward',
--     'fallback'
--   },
--   ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
--
--   ['<Up>'] = { 'select_prev', 'fallback' },
--   ['<Down>'] = { 'select_next', 'fallback' },
--   ['<C-p>'] = { 'select_prev', 'fallback' },
--   ['<C-n>'] = { 'select_next', 'fallback' },
--
--   ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
--   ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
