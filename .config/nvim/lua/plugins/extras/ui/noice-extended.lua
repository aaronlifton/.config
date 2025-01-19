return {
  "folke/noice.nvim",
  optional = true,
  opts = function(_, opts)
    vim.list_extend(opts.routes, {
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = {
          skip = true,
        },
      },
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "Searching",
        },
        opts = {
          skip = true,
        },
      },
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "Processing",
        },
        opts = {
          skip = true,
        },
      },
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "semantic token",
        },
        opts = {
          skip = true,
        },
      },
      {
        filter = {
          event = "notify",
          find = "textDocument/codeLens",
        },
        opts = {
          skip = true,
        },
      },
      {
        filter = {
          event = "notify",
          find = "Query error",
        },
        opts = {
          skip = true,
        },
      },
    })
    opts.presets.lsp_doc_border = true
    -- opts.presets.bottom_search = false
    if LazyVim.cmp_engine() == "nvim-cmp" then opts.popupmenu = { backend = "cmp" } end

    if vim.g.lazyvim_picker == "fzf" then
      require("noice.commands").pick = function()
        require("noice.integrations.fzf").open({})
      end
    end
  end,
  keys = {
    {
      "<leader>snt",
      function()
        require("noice.integrations.fzf").open({})
      end,
      desc = "Noice Picker (Telescope/FzfLua)",
    },
  },
}

-- return {
--   "folke/noice.nvim",
--   opts = function(_, opts)
--     table.insert(opts.routes, {
--       filter = {
--         event = "notify",
--         find = "No information available",
--       },
--       opts = {
--         skip = true,
--       },
--     })
--     table.insert(opts.routes, {
--       filter = {
--         event = "notify",
--         find = "not supported by",
--       },
--       opts = {
--         skip = true,
--       },
--     })
--     table.insert(opts.routes, {
--       filter = {
--         find = "typed: false",
--       },
--       opts = {
--         skip = true,
--       },
--     })
--     table.insert(opts.routes, {
--       filter = {
--         event = "notify",
--         find = "TypeScript Server Error",
--       },
--       opts = {
--         skip = true,
--       },
--     })
--     local focused = true
--     vim.api.nvim_create_autocmd("FocusGained", {
--       callback = function()
--         focused = true
--       end,
--     })
--     vim.api.nvim_create_autocmd("FocusLost", {
--       callback = function()
--         focused = false
--       end,
--     })
--     -- from folke
--     table.insert(opts.routes, 1, {
--       filter = {
--         ["not"] = {
--           event = "lsp",
--           kind = "progress",
--         },
--         cond = function()
--           return not focused
--         end,
--       },
--       view = "notify_send",
--       opts = { stop = false },
--     })
--     opts.commands = {
--       all = {
--         -- options for the message history that you get with `:Noice`
--         view = "split",
--         opts = { enter = true, format = "details" },
--         filter = {},
--       },
--     }
--     -- opts.status = { lsp_progress = { event = "lsp", kind = "progress" } }
--     opts.presets.lsp_doc_border = true
--     opts.presets.bottom_search = false
--     -- opts.lsp.message.enabled = false
--     return opts
--   end,
-- }
