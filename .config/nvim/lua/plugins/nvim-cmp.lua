if vim.g.native_snippets_enabled then
  return {
    desc = "Use native snippets instead of LuaSnip. Only works on Neovim >= 0.10!",
    {
      "L3MON4D3/LuaSnip",
      enabled = false,
    },
    {
      "nvim-cmp",
      opts = function(_, opts)
        local cmp = require("cmp")
        return vim.tbl_deep_extend("force", opts, {
          snippet = {
            expand = function(args)
              vim.snippet.expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-g>"] = cmp.mapping.confirm({ select = true }),
          }),
        })
        --     ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        --     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        --     ["<C-f>"] = cmp.mapping.scroll_docs(4),
        --     ["<C-Space>"] = cmp.mapping.complete(),
        --     ["<C-e>"] = cmp.mapping.abort(),
        --     ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        --     ["<S-CR>"] = cmp.mapping.confirm({
        --       behavior = cmp.ConfirmBehavior.Replace,
        --       select = true,
        --     }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        --     ["<C-CR>"] = function(fallback)
        --       cmp.abort()
        --       fallback()
        --     end,
        --   })
        -- end,
      end,
      -- },
      keys = {
        {
          "<Tab>",
          function()
            if vim.snippet.jumpable(1) then
              vim.schedule(function()
                vim.snippet.jump(1)
              end)
              return
            end
            return "<Tab>"
          end,
          expr = true,
          silent = true,
          mode = "i",
        },
        {
          "<Tab>",
          function()
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          end,
          silent = true,
          mode = "s",
        },
        {
          "<S-Tab>",
          function()
            if vim.snippet.jumpable(-1) then
              vim.schedule(function()
                vim.snippet.jump(-1)
              end)
              return
            end
            return "<S-Tab>"
          end,
          expr = true,
          silent = true,
          mode = { "i", "s" },
        },
      },
    },
  }
else
  return {
    {
      "L3MON4D3/LuaSnip",
      build = (not jit.os:find("Windows"))
          and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
        or nil,
      dependencies = {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load() -- from LazyVim
          require("luasnip.loaders.from_vscode").load({ paths = vim.fn.stdpath("config") .. "/snippets" })
          require("luasnip.loaders.from_snipmate").load({ paths = { vim.fn.stdpath("config") .. "/snipmate" } })
          require("luasnip").filetype_extend("ruby", { "rails" })
        end,
      },
      keys = function()
        return {}
      end,
    },
    { "onsails/lspkind.nvim" },
    {
      "hrsh7th/nvim-cmp",
      dependencies = { "onsails/lspkind.nvim" },
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        local cmp_window = require("cmp.config.window")

        return {
          mapping = cmp.mapping.preset.insert({
            ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.abort(),
            -- ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            -- ["<S-CR>"] = cmp.mapping.confirm({
            --   behavior = cmp.ConfirmBehavior.Replace,
            --   select = true,
            -- }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            -- ["<C-CR>"] = function(fallback)
            --   cmp.abort()
            --   fallback()
            -- end,
            -- ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            -- ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = SelectBehavior.Select }), { "i" }),
            ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = SelectBehavior.Select }), { "i" }),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-y>"] = cmp.mapping({
              i = cmp.mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
              c = function(fallback)
                if cmp.visible() then
                  cmp.confirm({ behavior = ConfirmBehavior.Replace, select = false })
                else
                  fallback()
                end
              end,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              elseif jumpable(1) then
                luasnip.jump(1)
              elseif has_words_before() then
                -- cmp.complete()
                fallback()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                local confirm_opts = vim.deepcopy(lvim.builtin.cmp.confirm_opts) -- avoid mutating the original opts below
                local is_insert_mode = function()
                  return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
                end
                if is_insert_mode() then -- prevent overwriting brackets
                  confirm_opts.behavior = ConfirmBehavior.Insert
                end
                local entry = cmp.get_selected_entry()
                local is_copilot = entry and entry.source.name == "copilot"
                if is_copilot then
                  confirm_opts.behavior = ConfirmBehavior.Replace
                  confirm_opts.select = true
                end
                if cmp.confirm(confirm_opts) then
                  return -- success, exit early
                end
              end
              fallback() -- if not exited early, always fallback
            end),
          }),
          -- window = {
          --   completion = {
          --     border = "rounded",
          --     winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
          --     scrollbar = false,
          --     col_offset = -3,
          --     side_padding = 1,
          --   },
          --   documentation = {
          --     border = "rounded",
          --     winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
          --     scrollbar = false,
          --   },
          -- },
          window = {
            completion = cmp_window.bordered(),
            documentation = cmp_window.bordered(),
          },
          -- performance = {
          --   debounce = 20,
          --   throttle = 20,
          --   fetching_timeout = 20,
          --   confirm_resolve_timeout = 20,
          --   async_budget = 1,
          --   max_view_entries = 50,
          -- }

          -- formatting = {
          --   format = lspkind.cmp_format({
          --     mode = 'symbol', -- show only symbol annotations
          --     maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          --                   -- can also be a function to dynamically calculate max width such as
          --                   -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
          --     ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          --     show_labelDetails = true, -- show labelDetails in menu. Disabled by default
          --
          --     -- The function below will be called before any actual modifications from lspkind
          --     -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          --     before = function (entry, vim_item)
          --       ...
          --       return vim_item
          --     end
          --   })
          -- }
        }
      end,
      -- lspkind.cmp_format({
      --   with_text = false,
      --   before = function(entry, vim_item)
      --     local str = require("cmp.utils.str")
      --     local types = require("cmp.types")
      --     -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      --     -- Get the full snippet (and only keep first line)
      --     local word = entry:get_insert_text()
      --     if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
      --       word = vim.lsp.util.parse_snippet(word)
      --     end
      --     word = str.oneline(word)
      --
      --     -- concatenates the string
      --     -- local max = 50
      --     -- if string.len(word) >= max then
      --     -- 	local before = string.sub(word, 1, math.floor((max - 3) / 2))
      --     -- 	word = before .. "..."
      --     -- end
      --
      --     if
      --         entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
      --         and string.sub(vim_item.abbr, -1, -1) == "~"
      --     then
      --       word = word .. "~"
      --     end
      --     vim_item.abbr = word
      --
      --     return vim_item
      --   end,
      -- })
    },
  }
end
