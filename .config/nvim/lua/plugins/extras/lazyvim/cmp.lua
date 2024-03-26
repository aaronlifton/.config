local cmp = require("cmp")

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },
  keys = {
    { "<leader>ciC", "<cmd>CmpStatus<CR>", desc = "Cmp Status" },
  },
  opts = function(_, opts)
    -- mine
    -- local has_words_before = function()
    --   unpack = unpack or table.unpack
    --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    -- end
    -- local luasnip = require("luasnip")
    -- /mine
    opts.mapping = cmp.mapping.preset.insert({
      ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<S-CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<C-CR>"] = function(fallback)
        cmp.abort()
        fallback()
      end,
      -- mine
      ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
      ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      -- now in LuaSnip definition
      -- can delete
      -- ["<C-y>"] = cmp.mapping({
      --   i = cmp.mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
      --   c = function(fallback)
      --     if cmp.visible() then
      --       cmp.confirm({ behavior = ConfirmBehavior.Replace, select = false })
      --     else
      --       fallback()
      --     end
      --   end,
      -- }),
      -- can delete
      -- ["<Tab>"] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_next_item()
      --   elseif luasnip.expand_or_locally_jumpable() then
      --     luasnip.expand_or_jump()
      --   elseif luasnip.jumpable(1) then
      --     luasnip.jump(1)
      --   elseif has_words_before() then
      --     -- cmp.complete()
      --     fallback()
      --   else
      --     fallback()
      --   end
      -- end, { "i", "s" }),
      -- ["<S-Tab>"] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_prev_item()
      --   elseif luasnip.jumpable(-1) then
      --     luasnip.jump(-1)
      --   else
      --     fallback()
      --   end
      -- end, { "i", "s" }),
      -- ["<CR>"] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     local confirm_opts = vim.deepcopy(lvim.builtin.cmp.confirm_opts) -- avoid mutating the original opts below
      --     local is_insert_mode = function()
      --       return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
      --     end
      --     if is_insert_mode() then -- prevent overwriting brackets
      --       confirm_opts.behavior = ConfirmBehavior.Insert
      --     end
      --     local entry = cmp.get_selected_entry()
      --     local is_copilot = entry and entry.source.name == "copilot"
      --     if is_copilot then
      --       confirm_opts.behavior = ConfirmBehavior.Replace
      --       confirm_opts.select = true
      --     end
      --     if cmp.confirm(confirm_opts) then
      --       return -- success, exit early
      --     end
      --   end
      --   fallback() -- if not exited early, always fallback
      -- end),
      -- /mine
    })

    opts.window = {
      -- local cmp_window = require("cmp.config.window")
      -- completion = cmp_window.bordered(),
      -- documentation = cmp_window.bordered(),
      completion = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
        scrollbar = false,
        col_offset = -3,
        side_padding = 1,
      },
      documentation = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
        scrollbar = false,
      },
    }

    opts.performance = {
      debounce = 20,
      throttle = 20,
      fetching_timeout = 20,
      confirm_resolve_timeout = 20,
      async_budget = 1,
      max_view_entries = 50,
    }

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline({
        ["<C-j>"] = {
          c = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
        },
        ["<C-k>"] = {
          c = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
      }),
      sources = {
        { name = "buffer" },
      },
    })
  end,
}
