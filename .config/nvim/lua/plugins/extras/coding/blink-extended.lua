local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function setup_hide_blink_on_copilot_suggestion_autocmds()
  vim.api.nvim_create_autocmd("User", {
    pattern = "BlinkCmpMenuOpen",
    callback = function()
      require("copilot.suggestion").dismiss()
      vim.b.copilot_suggestion_hidden = true
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "BlinkCmpMenuClose",
    callback = function()
      vim.b.copilot_suggestion_hidden = false
    end,
  })
end

return {
  { import = "plugins.coding.cmp-extended", optional = true, enabled = false },
  { import = "hrsh7th/nvim-cmp", optional = true, enabled = false },
  { import = "lazyvim.plugins.extras.coding.blink" },
  {
    "saghen/blink.cmp",
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
      "Kaiser-Yang/blink-cmp-avante",
      {
        "edte/blink-go-import.nvim",
        ft = "go",
        config = function()
          require("blink-go-import").setup()
        end,
      },
    },
    optional = true,
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function(_, opts)
      setup_hide_blink_on_copilot_suggestion_autocmds()

      local new_opts = vim.tbl_deep_extend("force", {}, opts, {
        keymap = {
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-j>"] = { "select_next", "fallback" },
          -- ["<C-y>"] = { "select_and_accept" },
          ["<C-e>"] = { "hide", "fallback" },
          -- Supertab
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

          ["<Tab>"] = {
            function(cmp)
              if cmp.is_in_snippet() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            "snippet_forward",
            "fallback",
          },
          ["<S-Tab>"] = {
            "select_prev",
            "snippet_backward",
            function(cmp)
              if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
            end,
            "fallback",
          },
          -- ["<Tab>"] = {
          --   "select_next",
          --   "snippet_forward",
          --   function(cmp)
          --     if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
          --   end,
          --   "fallback",
          -- },
          -- ["<S-Tab>"] = {
          --   "select_prev",
          --   "snippet_backward",
          --   function(cmp)
          --     if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
          --   end,
          --   "fallback",
          -- },
        },
        fuzzy = {
          -- implementation = 'lua',
          implementation = "prefer_rust_with_warning",
          sorts = {
            "exact",
            -- defaults
            "score",
            "sort_text",
          },
        },
        completion = {
          menu = {
            -- border = "rounded",
            border = "single",
            -- winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            draw = {
              padding = 2,
              columns = {
                { "item_idx", "kind_icon", "kind" },
                { "label", "label_description", gap = 1 },
              },
              -- To right-align the kind label ext https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
              components = {
                -- kind_icon = { width = { fill = true } },
                item_idx = {
                  text = function(ctx)
                    return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
                  end,
                  highlight = "BlinkCmpItemIdx", -- optional, only if you want to change its color
                },
              },
            },
            auto_show = function(ctx)
              return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
            end,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 50, -- 0
            window = {
              -- border = "rounded",
              border = "single",
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            },
          },
          list = {
            selection = {
              preselect = function(ctx)
                return ctx.mode ~= "cmdline" and not require("blink.cmp").snippet_active({ direction = 1 })
              end,
              -- When using `enter` keymap preset
              -- preselect = false
            },
          },
        },
        signature = {
          enabled = true,
          window = {
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        sources = {
          -- default = { "lsp", "path", "snippets", "buffer" },
          default = { "avante", "lsp", "path", "snippets", "buffer", "go_pkgs" },
          providers = {
            lsp = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              transform_items = function(_, items)
                return vim.tbl_filter(function(item)
                  return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
                end, items)
              end,
            },
            go_pkgs = {
              module = "blink-go-import",
              name = "Import",
            },
            path = {
              opts = {
                get_cwd = function(_)
                  return vim.fn.getcwd()
                end,
              },
            },
            avante = {
              module = "blink-cmp-avante",
              name = "Avante",
            },
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
        cmdline = {
          keymap = {
            ["<Tab>"] = { "show", "accept" }, -- recommended, as the default keymap will only show and select the next item
          },
          completion = {
            menu = { auto_show = true },
            ghost_text = { enabled = false },
          },
        },
      })

      -- Should already be done by ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/coding/blink.lua:142
      -- opts.sources.providers.copilot.transform_items = function(ctx, items)
      --   for _, item in ipairs(items) do
      --     item.kind_icon = ""
      --     item.kind_name = "Copilot"
      --   end
      --   return items
      -- end

      -- opts.sources.providers.copilot.transform_items = function(_, items)
      --   local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
      --   local kind_idx = #CompletionItemKind + 1
      --   CompletionItemKind[kind_idx] = "Copilot"
      --   for _, item in ipairs(items) do
      --     item.kind = kind_idx
      --   end
      --   return items
      -- end
      return new_opts
    end,
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
