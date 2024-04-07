-- local border = function(hl)
--   return {
--     { "┌", hl },
--     { "─", hl },
--     { "┐", hl },
--     { "│", hl },
--     { "┘", hl },
--     { "─", hl },
--     { "└", hl },
--     { "│", hl },
--   }
-- end

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
    "ray-x/cmp-treesitter",
  },
  keys = {
    { "<leader>ciC", "<cmd>CmpStatus<CR>", desc = "Cmp Status" },
  },
  opts = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local neogen = require("neogen")
    local compare = require("cmp.config.compare")
    local cmp_window = require("cmp.config.window")
    local has_words_before = require("util.editor").has_words_before

    compare.lsp_scores = function(entry1, entry2)
      local diff
      if entry1.completion_item.score and entry2.completion_item.score then
        diff = (entry2.completion_item.score * entry2.score) - (entry1.completion_item.score * entry1.score)
      else
        diff = entry2.score - entry1.score
      end
      return (diff < 0)
    end
    -- cmp.setup.cmdline("/", {
    --   mapping = cmp.mapping.preset.cmdline({
    --     ["<CR>"] = cmp.mapping.confirm({ select = true }),
    --     ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    --     ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    --     ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    --     ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    --   }),
    --   sources = {
    --     { name = "buffer" },
    --   },
    -- })
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      }),
      sources = {
        { name = "buffer" },
      },
    })
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    opts.performance = {
      debounce = 20,
      throttle = 20,
      fetching_timeout = 20,
      confirm_resolve_timeout = 20,
      async_budget = 1,
      max_view_entries = 50,
    }

    opts.sources = cmp.config.sources({
      { name = "nvim_lsp", max_item_count = 15 },
      { name = "nvim_lua" },
      -- { name = "cmp_tabnine" },
      { name = "treesitter" },
      { name = "luasnip", max_item_count = 8 },
    }, {
      { name = "buffer" },
      { name = "path" },
    })
    opts.window = {
      -- completion = cmp_window.bordered(),
      -- documentation = cmp_window.bordered(),
      completion = {
        border = "rounded",
        ---------------"Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None"
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        zindex = 1001,
        scrolloff = 0, -- 0
        col_offset = 0, -- -3
        side_padding = 1, -- 1
        scrollbar = true,
      },
      -- completion = {
      --   border = "rounded",
      --   winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
      --   scrollbar = false,
      --   col_offset = -3,
      --   side_padding = 1,
      -- },
      documentation = {
        -- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        border = "rounded",
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
        -- winhighlight = "Normal:CmpDoc",
        scrollbar = false,
      },
      -- astro
      -- completion = cmp.config.window.bordered {
      --   col_offset = -2,
      --   side_padding = 0,
      --   border = "rounded",
      --   winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      -- },
      -- documentation = cmp.config.window.bordered {
      --   border = "rounded",
      --   winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      -- },
    }
    -- preselect = cmp.PreselectMode.Item,
    -- sorting = {
    --   priority_weight = 2,
    --   comparators = {
    --     -- 2                      -- 1 (Defaults)
    --     -- compare.score,         -- cmp.config.compare.offset
    --     -- compare.recently_used, -- -- cmp.config.compare.scopes -- this is commented in nvim-cmp too
    --
    --     -- compare.offset,        -- cmp.config.compare.exact
    --     -- compare.exact,         -- cmp.config.compare.score
    --     -- compare.kind,          -- cmp.config.compare.recently_used
    --     -- compare.sort_text,     -- cmp.config.compare.locality
    --     -- compare.length,        -- cmp.config.compare.kind
    --     -- compare.order,         -- cmp.config.compare.sort_text
    --     --                       -- cmp.config.compare.length,
    --     --                       -- cmp.config.compare.order
    --
    --     -- 3
    --     require("copilot_cmp.comparators").prioritize,
    --     require("copilot_cmp.comparators").score,
    --     -- require("cmp_tabnine.compare"),
    --     compare.offset, -- Items closer to cursor will have lower priority
    --     compare.exact,
    --     compare.lsp_scores,
    --     compare.sort_text,
    --     compare.score,
    --     compare.recently_used,
    --     -- compare.locality, -- Items closer to cursor will have higher priority, conflicts with `offset`
    --     compare.kind,
    --     compare.length,
    --     compare.order,
    --   },
    -- },
    -- formatting = {
    --   fields = { "abbr", "kind", "menu" },
    -- },
    -- sources = cmp.config.sources({
    --   { name = "nvim_lsp" },
    --   { name = "path" },
    -- }, {
    --   { name = "buffer" },
    -- }),
    -- LazyVim extras like copilot and codeium will be inserted into the sources list after nvim-cmp is loaded
    opts.mapping = cmp.mapping.preset.insert({
      ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      -- ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      -- ["<C-e>"] = cmp.mapping.abort(),
      -- ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      -- ["<CR>"] = cmp.mapping({
      --   i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      --   c = function(fallback)
      --     if cmp.visible() then
      --       cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
      --     else
      --       fallback()
      --     end
      --   end,
      -- }),
      ["<S-CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<C-CR>"] = function(fallback)
        cmp.abort()
        fallback()
      end,
      -- mine
      -- ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
      -- ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      ["<C-h>"] = cmp.mapping.open_docs(),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          -- cmp.select_next_item()
          cmp.confirm({ select = true })
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
        elseif vim.snippet and vim.snippet.jumpable(1) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif neogen.jumpable() then
          neogen.jump_next()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet and vim.snippet.jumpable(-1) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        elseif neogen.jumpable(true) then
          neogen.jump_prev()
        else
          fallback()
        end
      end, { "i", "s" }),
    })
  end,
}
