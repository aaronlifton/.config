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

local function depriprotize_lsp(name, a, b)
  if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then return end
  return b.client_name == name
end

return {
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
      { "marcoSven/blink-cmp-yanky" },
    },
    optional = true,
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function(_, opts)
      setup_hide_blink_on_copilot_suggestion_autocmds()

      local new_opts = vim.tbl_deep_extend("force", {}, opts, {
        keymap = {
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-y>"] = { "select_and_accept" },
          ["<C-e>"] = { "hide", "fallback" },
          -- Testing
          ["<C-u>"] = { "scroll_signature_up", "fallback" },
          ["<C-d>"] = { "scroll_signature_down", "fallback" },
          -- Supertab
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          -- LazyVim implements this:
          -- ["<Tab>"] = {
          --   -- Ref to: `if cmp.snippet_active() then return cmp.accept() else return cmp.select_and_accept() end`
          --   require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
          --   LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
          --   "fallback",
          -- },
          ["<Tab>"] = {
            "snippet_forward",
            function() -- sidekick next edit suggestion
              return require("sidekick").nes_jump_or_apply()
            end,
            -- function() -- if you are using Neovim's native inline completions
            --   return vim.lsp.inline_completion.get()
            -- end,
            "fallback",
          },
          ["<S-Tab>"] = {
            "snippet_backward",
            "select_prev",
            "fallback",
          },
          -- stylua: ignore start
          ['<M-1>'] = {
            ---@param cmp blink.cmp.API
            function(cmp) cmp.accept({ index = 1 }) end,
          },
          ['<M-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
          ['<M-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
          ['<M-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
          ['<M-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
          ['<M-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
          ['<M-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
          ['<M-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
          ['<M-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
          ['<M-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
          -- stylua: ignore end
          --
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
            -- depriprotize_lsp('emmet_ls'),
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
              -- To right-align the kind label https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
              components = {
                -- kind_icon = { width = { fill = true } },
                item_idx = {
                  text = function(ctx)
                    return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx) .. " "
                  end,
                  highlight = "BlinkCmpItemIdx", -- optional, only if you want to change its color
                },
              },
            },
            auto_show = function(ctx)
              -- return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
              return vim.fn.getcmdtype() == ":"
            end,
            -- auto_show_delay_ms = 200,
            direction_priority = function()
              local ctx = require("blink.cmp").get_context()
              local item = require("blink.cmp").get_selected_item()
              if ctx == nil or item == nil then return { "s", "n" } end

              local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
              local is_multi_line = item_text:find("\n") ~= nil

              -- after showing the menu upwards, we want to maintain that direction
              -- until we re-open the menu, so store the context id in a global variable
              if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
                vim.g.blink_cmp_upwards_ctx_id = ctx.id
                return { "n", "s" }
              end
              return { "s", "n" }
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
            border = "single",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        sources = {
          -- default = function(ctx)
          --   if vim.bo.filetype == "AvantePromptInput" then
          --     return { "buffer" }
          --   else
          --     return { "copilot", "avante", "yank", "lsp", "path", "snippets", "buffer", "go_pkgs" }
          --   end
          -- end,
          providers = {
            lsp = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              transform_items = function(_, items)
                -- ignore keywords like if, while, else, etc.
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
            yank = {
              name = "yank",
              module = "blink-yanky",
              opts = {
                minLength = 5,
                onlyCurrentFiletype = true,
                trigger_characters = { '"' },
                kind_icon = "󰅍",
              },
            },
            -- copilot = {
            --   score_offset = 100
            -- }
            -- buffer = {
            --   should_show_items = false,
            -- },
          },
        },
        cmdline = {
          -- sources = {
          --   "buffer",
          --   "cmdline",
          --   function()
          --     local type = vim.fn.getcmdtype()
          --     -- Search forward and backward
          --     if type == "/" or type == "?" then return { "buffer" } end
          --     -- Commands
          --     if type == ":" then return { "cmdline" } end
          --     return {}
          --   end,
          -- },
        },
      })

      return new_opts
    end,
  },
}
